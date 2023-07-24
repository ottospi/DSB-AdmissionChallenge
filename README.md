# DSB-AdmissionChallenge
Data Science Bootcamp Application - Admissions Challenge


## Settings:

First need to make a database.

We are gonna use a mysql (it's a requeriment to use mysql).


To save some memory and make it more modern we are gonna use a docker conteiner, follow it's the instuctions:
(need to know the basic of docker to folloew this tutorial)

Open the terminal and follow the commands:

### Creating a mysql database:
```
    docker run --name mysqlTest 
        -p 3306:3306 
        -e MYSQL_ROOT_PASSWORD=mysqlPW 
        -e MYSQL_DATABASE=mysqlDB 
        -e MYSQL_USER=mysqlUser 
        -e MYSQL_PASSWORD=mysqlPassword 
        -d mysql: 8.0.31
```

> (version 8.0.31 is a request from the challenge)

to connect to the database (I'm using the Dbeaver's client ):

``` 
    jdbc:mysql://localhost:3306/mysqlDB?allowPublicKeyRetrieval=true&useSSL=false
```

Credentials:

```
    MYSQL_USER=mysqlUser 
    MYSQL_PASSWORD=mysqlPassword 
```

---
---
## Part 01 - Preliminary analysis in SQL :


> Notes: Keep in mind the data is not completely clean and it is possible that you will have to make assumptions on what data to ignore and why. Be sure to address these decisions and assumptions in your report.

>Three key variables to pay attention to in your analysis are: Campaign goals in dollars, Number of backers, and Length of campaigns

I'm adding a new column in the currency's table, the ratio to USD dollar, so it's able to normalize the values in USD dollar.

ID | Coin  | Ratio_to_dollar
-- | ----- | ---
1 | GBP   | 1.22
2 | USD   | 1
3 | CAD   | 0.79
4 | AUD   | 0.71
5 | NOK   | 0.10
6 | EUR   | 0.92
7 | MXN   | 20.37
8 | SEK   | 0.10
9 | NZD   | 0.65
10 | CHF   | 0.99
11 | DKK   | 0.14
12 | HKD   | 7.84
13 | SGD   | 0.74
14 | JPY   | 0.0093

### Questions to be answered
---
1. Are the goals for dollars raised significantly different between campaigns that are successful and unsuccessful?

- Defining 3 types of campaigns: **Successful**, **Failed** and **Undefined**. 

To ensure the reliability of our analysis, we need to normalize the results in USD and then add the comparative to predicted values per backer:


| | UNITS | AVERAGE GOAL | AVERAGE PLEDGED |SUM PLEDGED | BACKERS   | SUM PLEDGED / BACKER |
| ---------- | ----- | --------- | ------- |------------- | --------  | --------- |
| Successful | 5,319 | $10,151   | $22,948 | $11,717,920  | 1,500,730 | $81.34    |
| Failed     | 7,850 | $97,296   | $1,493  | $122,062,216 | 139,114   | $84.23     |
| Undefined   | 1,831 | $144,821  | $2,410  | $4,413,122   | 36,844    | $119.78    |
| All        | 15,000 | $72,195  | $9,213  | $138,193,258 | 1,676,688 | $82.42     |
 
<dl>
    <dt>Overview:</dt>
    <dt>- Successful campaigns</dt>

- The average pledge per backer for successful campaigns is $81.34, while the average pledge per backer for failed campaigns is $84.23. This suggests that the amount of money that people are willing to pledge to Kickstarter campaigns is not significantly affected by whether the campaign is successful or failed.

- The average goal for successful campaigns is $10,151, while the average goal for failed campaigns is $97,296. This suggests that successful campaigns are more likely to have realistic goals, while failed campaigns are more likely to have ambitious goals that are difficult to achieve.

- Successful campaigns tend to have lower average goals and higher average pledges than failed campaigns. This is likely because successful campaigns are more likely to be well-planned and well-executed, and they are more likely to have a strong community of backers who are willing to pledge more money.

- The average pledge for successful campaigns is $22,948, while the average pledge for failed campaigns is $1,493. This suggests that successful campaigns are more likely to attract a large number of backers who are willing to pledge a significant amount of money.
</dl>

<dl>
  <dt>- Undefined campaigns</dt>

- The average pledge per backer is relatively consistent across all three categories. This suggests that the amount of money that people are willing to pledge to Kickstarter campaigns is not significantly affected by whether the campaign is successful, failed, or undefined.

- The average pledge per backer is higher for undefined campaigns than for successful or failed campaigns. This is likely because undefined campaigns are more likely to be ambitious and to have larger goals, which means that they need to attract more backers in order to be successful.
</dl>

THE QUERY TO EXECUTE THE RESULTS: 
```SQL
SELECT 
COUNT(campaign.id) as Units,
FORMAT( AVG( campaign.goal ) ,0) as AVG_Goal,
FORMAT( AVG( campaign.pledged ) ,0) as AVG_Pledged,
FORMAT( 
    AVG( 
      campaign.goal * (
            select ratio_to_dollar from currency c where campaign.currency_id = c.id 
            )
    ) 
,0) as AVG_Goal_Dollar,
FORMAT(
	AVG(
        campaign.pledged * (
            select ratio_to_dollar from currency c where campaign.currency_id = c.id 
            )
    )
,0)as AVG_Pledged_Dollar, 
FORMAT( 
	SUM( 
        campaign.pledged * ( 
            select ratio_to_dollar from currency c where campaign.currency_id = c.id
            ) 
    )
,0) as SUM_Pledged_Dollar,
SUM(campaign.backers) as SUM_backers,
FORMAT( 
	SUM( 
        campaign.pledged * ( 
            select ratio_to_dollar from currency c where campaign.currency_id = c.id 
            )
        )
	/
	SUM(campaign.backers)
,2) 
as ratio
FROM campaign campaign 
JOIN sub_category sub_c ON sub_c.id = campaign.sub_category_id
-- WHERE campaign.outcome 
-- = 'failed'
-- = 'successful'
-- in ('canceled', 'suspended', 'undefined', 'live' )
```
     
---
2. What are the top/bottom 3 categories with the most backers? 

<table align="center" >
<tr><th>TOP 3  </th><th>BOTTOM 3</th></tr>
<tr><td>

| Category   | Backers |
|------------|---------|
| Games      | 411,671 |
| Technology | 329,751 |
| Design     | 262,245 |

</td><td>

| Category   | Backers |
|------------|---------|
| Dance      | 6,022   |
| Journalism | 6,206   |
| Crafts     | 10,418  |

</td></tr> </table>


```sql
select 
(select name from category c where category_id = c.id) as category_name, 
sum(campaign.backers) as backers 
FROM campaign campaign 
join sub_category sub_c on sub_c.id = campaign.sub_category_id
group by category_name
order by backers 
-- asc
-- desc
```

---
3. What are the top/bottom 3 subcategories by backers?

<table align="center" >
<tr><th>TOP 3  </th><th>BOTTOM 3</th></tr>
<tr><td>

| Sub Category   | Backers |
|----------------|---------|
| Tabletop Games | 247,120 |
| Product Design | 221,931 |
| Video Games    | 141052 |

</td><td>

| Sub Category   | Backers |
|------------|---------|
| Glass      | 2       |
| Photo      | 12      |
| Latin      | 13      |

</td></tr> </table>

```sql
select 
sub_c.name as sub_cat_name, 
sum(campaign.backers) as backers 
FROM campaign campaign 
join sub_category sub_c on sub_c.id = campaign.sub_category_id
group by sub_c.name 
order by backers 
-- asc
-- desc
```

---
4. What are the top/bottom 3 categories that have raised the most money? 

<table align="center" >
<tr><th>TOP 3  </th><th>BOTTOM 3</th></tr>
<tr><td>

| Category       | Money |
|------------|---------|
| Technology | $28,760,280 |
| Games      | $28,491,570 |
| Design     | $25,395,194 |

</td><td>

| Category   | Money  |
|------------|--------- |
| Journalism | $455,930 |
| Dance      | $530,460 |
| Crafts     | $620,131 |

</td></tr> </table>

```sql
select 
(select name from category c where category_id = c.id) as category_name,
FORMAT(
	SUM(
		campaign.pledged
         *
        ( select ratio_to_dollar from currency c where campaign.currency_id = c.id ) 
    ) 
,0,'en_US') as SUM_Pledged_Dollar
FROM campaign campaign 
join sub_category sub_c on sub_c.id = campaign.sub_category_id
group by category_name 
```

---
5. What are the top/bottom 3 subcategories that have raised the most money?


<table align="center" >
<tr><th>TOP 3  </th><th>BOTTOM 3</th></tr>
<tr><td>

| Sub Category       | Backers        |
|------------    |----------------|
|Product Design	 | $22,544,640.36 |
|Tabletop Games	 | $9,293,162.87  |
|Video Games	 | $7,913,822.82  |

</td><td>

| Sub Category | Backers  |
|----------|--------- |
| Glass	   | $150.0   |
| Crochet  | $173.00  |
| Latin	   | $268.0   |

</td></tr> </table>

```sql
SELECT 
sub_c.name as sub_cat_name, 
SUM(
    campaign.pledged 
    * 
    ( select ratio_to_dollar from currency c where campaign.currency_id = c.id ) 
) as SUM_Pledged_Dollar
FROM campaign campaign JOIN sub_category sub_c ON sub_c.id = campaign.sub_category_id
GROUP BY sub_c.name 
ORDER BY SUM_Pledged_Dollar DESC 
```

---
6. What was the amount the most successful board game company raised? 
How many backers did they have?

|ID | Name | SubCategory | Category | Contry | Currency| Goal | Pledged | Backers | Launched | Deadline | CampaingDuration |
|----|----|----|----|----|----|----|----|----|----|----|----|
| 7161 | Bring Reading Rainbow Back for Every Child, Everywhere! | Web | Technology | US | USD | 1,000,000.0 | **5,408,916.95** | **105,857** | 2014-05-28 | 2014-07-02 | 35 days|


```sql
SELECT 
campaign.id ,
campaign.name AS campaing_name, 
sub_c.name AS sub_cat_name, 
(SELECT name FROM category c WHERE category_id = c.id) AS category_name, 
(SELECT name FROM country c WHERE campaign.country_id = c.id) AS country,
(SELECT name FROM currency c WHERE campaign.currency_id = c.id) AS currency,
(SELECT ratio_to_dollar FROM currency c WHERE campaign.currency_id = c.id) AS ratio,
campaign.goal * (SELECT  ratio_to_dollar FROM currency c WHERE campaign.currency_id = c.id) AS Goal_Dollar,
campaign.pledged * (SELECT  ratio_to_dollar FROM currency c WHERE campaign.currency_id = c.id) AS Pledged_Dollar, 
campaign.goal, 
campaign.pledged,
campaign.backers, 
campaign.outcome,
campaign.launched, 
campaign.deadline,
DATEDIFF( campaign.deadline, campaign.launched ) AS CampaingDuration
FROM campaign campaign  JOIN sub_category sub_c ON sub_c.id = campaign.sub_category_id
order by Pledged_Dollar DESC LIMIT 1 
```

---
7. Rank the top three countries with the most successful campaigns in terms of dollars (total amount pledged), and in terms of the number of campaigns backed.

- TOP 3 CONTRIES WITH MOST SUCESS

<div align="center" >

| Country | SUM OF SUCCESSFUL CAMPAIGN | BACKERS |
| :-----: | :----------: | :----------: |
|   US    |   4365       |  1,295,509   |
|   GB    |   487        |  90,729      |
|   CA    |   137        |  28,466      |

</div>

```SQL 
SELECT
(SELECT NAME FROM country c WHERE campaign.country_id = c.id) AS country,
COUNT(campaign.id ) AS id,
SUM(campaign.backers) AS backers
FROM campaign campaign  JOIN  sub_category sub_c ON sub_c.id = campaign.sub_category_id
WHERE campaign.outcome = 'successful'
GROUP BY country
ORDER BY id DESC LIMIT 3
```

- TOP 3 CONTRIES WITH MOST BACKERS

<div align="center">

| Country | SUM OF SUCCESSFUL CAMPAIGN | BACKERS |
| :-----: | :----------: | :----------: |
|   US    |   4365       |  1,295,509   |
|   GB    |   487        |  90,729      |
|   AU    |   84         |  29,704      |

</div>

```SQL 
SELECT
(SELECT NAME FROM country c WHERE campaign.country_id = c.id) AS country,
COUNT(campaign.id ) AS SUM_campaign,
SUM(campaign.backers AS BACKERS
FROM campaign campaign  JOIN  sub_category sub_c ON sub_c.id = campaign.sub_category_id
WHERE campaign.outcome = 'successful'
GROUP BY country
order by BACKERS DESC LIMIT 3
```

---
8. Do longer, or shorter campaigns tend to raise more money? Why?

- Determining that a short campaigns is 30 days, medium is 31 to 60 days and a long campaign is 61-100 we got this results:

<div align="center">

| SUM of units | success | failed | undefined | success % | failed % | undefined % | duration |
|:------------:|:-------:|:------:|:--------:|:---------:|:--------:|:----------:|:--------:|
|     9,433    |  3,413  |  4,971 |  1,049   |   36.1 %  |   52.7 % |   11.1 %   |  short   |
|     5,331    |  1,811  |  2,761 |   759    |   33.9 %  |   51.8 % |   14.2 %   |  medium  |
|     236      |    95   |    118 |   23     | **40.2 %**|**50.0 %**|  **9.7 %** | **long** |

</div>

```SQL
SELECT  
COUNT( campaign.id ) AS UNITS,
SUM(campaign.outcome = 'successful') AS SUCC,
SUM(campaign.outcome = 'failed') AS FAILED,
SUM(campaign.outcome IN ('canceled', 'suspended', 'undefined', 'live' ) ) AS UNDEFINED,
(SUM(campaign.outcome = 'successful')*100)/COUNT( campaign.id ) AS SUCCESS_PORCERT,
(SUM(campaign.outcome = 'failed')*100)/COUNT( campaign.id ) as FAILED_PORCERT,
(SUM(campaign.outcome IN ('canceled', 'suspended', 'undefined', 'live' ))*100)/COUNT( campaign.id ) as UNDEFINED_PORCERT,
CASE 
	WHEN DATEDIFF( campaign.deadline, campaign.launched ) <= 30 THEN 'short'
	WHEN DATEDIFF( campaign.deadline, campaign.launched ) <= 60 THEN 'medium'
	ELSE 'long' 
END AS duration
FROM campaign campaign JOIN sub_category sub_c ON sub_c.id = campaign.sub_category_id
GROUP BY duration
```

---
---
## Part 2 - Visualize the Data:

The executives have asked you to create 5 data visualizations that illustrate the key insights, trends, patterns, and oddities in the data.

Your visualizations must include titles and labels, and a summary of why each visualization might be important for your client and/or relevant to solving their business problem. You can use any visualization tool of your choice to create these 5 visualizations (Excel, Google Sheets etc.)

5 visualizations
    titles 
    labels
    summary

1.
        Title: Crowdfunding Outcomes

        Labels:

        - Outcome: The outcome of the crowdfunding campaign.
        - Average of Goal in Dollar: The average goal amount for campaigns with that outcome.
        - Average de Pledged inDollar: The average pledged amount for campaigns with that outcome.

        Summary: 
        This graph shows the average goal and pledged amounts for different crowdfunding outcomes.

    ![alt text](https://docs.google.com/spreadsheets/d/e/2PACX-1vQ8yZ1pxsbCJOcPAwSaqWoE37TRcjvEof_3DaL5RRkpGhm8PSSrGDuVc-oKgljVxiKY4Oqos2TNYmVK/pubchart?oid=123406733&format=image )

2.
        Title: Crowdfunding Outcomes for Games

        Labels:

        - Outcome: The outcome of the crowdfunding campaign.
        - Average of Goal in Dollar: The average goal amount for campaigns with that outcome.
        - Average de Pledged inDollar: The average pledged amount for campaigns with that outcome.

        Summary: 
        This graph shows the average goal and pledged amounts for different crowdfunding outcomes for games.

        Notes:
        There are no games in the "suspended" outcome category. The average goal amount for games is lower than the average goal amount for all campaigns. The average pledged amount for games is a little higher than the average pledged amount for all campaigns.

    ![alt text](https://docs.google.com/spreadsheets/d/e/2PACX-1vQ8yZ1pxsbCJOcPAwSaqWoE37TRcjvEof_3DaL5RRkpGhm8PSSrGDuVc-oKgljVxiKY4Oqos2TNYmVK/pubchart?oid=1373526640&format=image)

3.
        Title: Crowdfunding Outcomes by Category

        Labels:

        Category name: The category of the crowdfunding project.
        - Average of backers: The average number of backers for projects in that category.
        - Average of Pledged in Dollar: The average amount pledged for projects in that category.
        - Average of Goal in Dollar: The average goal amount for projects in that category.
        
        Summary:
        This graph shows the average number of backers, pledged amount, and goal amount for different crowdfunding categories. The average number of backers is highest for games, followed by comics and art. The average pledged amount is highest for games, followed by film & video and technology. The average goal amount is highest for games, followed by film & video and design.

        Notes:
        The average goal amount is higher for categories that are more ambitious, such as games and film & video.


    ![alt text](https://docs.google.com/spreadsheets/d/e/2PACX-1vQ8yZ1pxsbCJOcPAwSaqWoE37TRcjvEof_3DaL5RRkpGhm8PSSrGDuVc-oKgljVxiKY4Oqos2TNYmVK/pubchart?oid=1020757324&format=image)

4.
        Title: Crowdfunding Outcomes for Successful Campaigns by Category
        
        Labels:

        - Category name: The category of the crowdfunding project.
        - Average of backers: The average number of backers for successful projects in that category.
        - Average of Pledged in Dollar: The average amount pledged for successful projects in that category.
        - Average of Goal in Dollar: The average goal amount for successful projects in that category.

        Summary:
        This graph shows the average number of backers, pledged amount, and goal amount for different crowdfunding categories for successful campaigns. The average number of backers is highest for games, followed by comics and art. The average pledged amount is highest for games, followed by film & video and technology. The average goal amount is highest for games, followed by film & video and design.

        Notes:
        - The average pledged amount is higher for categories that are more expensive, such as film & video and technology.
        - The average goal amount is higher for categories that are more ambitious, such as games and film & video.
        - The average number of backers for successful campaigns is higher than the average number of backers for all campaigns.
        - The average pledged amount for successful campaigns is higher than the average pledged amount for all campaigns.
        - The average goal amount for successful campaigns is higher than the average goal amount for all campaigns.
        - This suggests that successful campaigns are more likely to be popular, expensive, and ambitious than all campaigns.

    ![alt text](https://docs.google.com/spreadsheets/d/e/2PACX-1vQ8yZ1pxsbCJOcPAwSaqWoE37TRcjvEof_3DaL5RRkpGhm8PSSrGDuVc-oKgljVxiKY4Oqos2TNYmVK/pubchart?oid=1720896683&format=image)

5.
        Title: Crowdfunding Campaign Durations

        Labels:

        - Outcome: The outcome of the crowdfunding campaign.
        - Average Campaing Duration: The average campaign duration for campaigns with that outcome.
        Summary:

        Those graphs shows the average campaign duration for different crowdfunding outcomes. The average campaign duration is highest for canceled campaigns, followed by failed campaigns. The average campaign duration is lowest for successful campaigns.

        Notes:

        The average campaign duration for all campaigns is 34 days.
        The average campaign duration for games is 32 days.
        This suggests that games have shorter campaign durations than all campaigns (~6% less time).

    ![alt text](https://docs.google.com/spreadsheets/d/e/2PACX-1vQ8yZ1pxsbCJOcPAwSaqWoE37TRcjvEof_3DaL5RRkpGhm8PSSrGDuVc-oKgljVxiKY4Oqos2TNYmVK/pubchart?oid=227040019&format=image)
    ![alt text](https://docs.google.com/spreadsheets/d/e/2PACX-1vQ8yZ1pxsbCJOcPAwSaqWoE37TRcjvEof_3DaL5RRkpGhm8PSSrGDuVc-oKgljVxiKY4Oqos2TNYmVK/pubchart?oid=471199400&format=image)

6.
        Title: Average Number of Backers for Game Crowdfunding Campaigns

        Labels:

        - Outcome: The outcome of the crowdfunding campaign.
        - Average of Backers: The average number of backers for games campaigns in that outcome.
        Summary:

        This graph shows the average number of backers for game crowdfunding campaigns with different outcomes. The average number of backers is highest for successful campaigns, followed by live campaigns. The average number of backers is lowest for canceled campaigns.

        Notes:

        Comparing to all games and all campaigns:

        - The average number of backers for all games campaigns is 99.30943931 backers.
        - The average number of backers for all campaigns is 53.6266108 backers.
        
        This suggests that game campaigns have more backers than all campaigns.

    ![alt text](https://docs.google.com/spreadsheets/d/e/2PACX-1vQ8yZ1pxsbCJOcPAwSaqWoE37TRcjvEof_3DaL5RRkpGhm8PSSrGDuVc-oKgljVxiKY4Oqos2TNYmVK/pubchart?oid=1690578335&format=image)

---
---
## Part 3 - Findings & Recommendations :

Based on Parts 1 and 2, write a 2-4 page business recommendation report to the company’s executive board that answers the 3 key questions outlined in the business challenge:

- What is a realistic Kickstarter campaign goal (in dollars) should the company aim to raise?
- How many backers will be needed to meet their goal?
- How many backers can the company realistically expect, based on trends in their category?
Your report must include:

- An introduction outlining the business problem at hand
- A description of the analytical process you went through (based on your work on Parts 1 and 2). The goal here is to understand your thought process, and any assumptions you may have made.
- The 5 data visualizations you created in Part 2
- Your final business recommendation for the 3 business questions. Your recommendations must be data-driven, specific, and actionable.

Note: The report should be written for a non-technical, executive audience, should address each of the report requirements below, and ultimately, should emphasize how and why your data-driven recommendations will contribute to the success of this next Kickstarter campaign.

---
---
## Submission Format :

Please submit your Admissions Challenge as a zipped folder with the following items:

Your 2-4 page business report as a PDF
One .sql script with the full, working queries you performed (zipped file)
A maximum of 3 supplementary file types you’ve used in your visualization or analysis.
Note: If you are using Excel for your visuals or working files, please combine each of your working files together as separate tabs in a single Excel workbook.

