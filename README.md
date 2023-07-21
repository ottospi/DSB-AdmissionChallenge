# DSB-AdmissionChallenge
Data Science Bootcamp Application - Admissions Challenge

---

First need to make a database.

We are gonna use a mysql (it's a requeriment to use mysql).

To save some memory and make it more modern we are gonna use a docker conteiner, follow it's the instuctions:


### We are creating a mysql database:

    docker run --name mysqlTest 
    -p 3306:3306 
    -e MYSQL_ROOT_PASSWORD=mysqlPW 
    -e MYSQL_DATABASE=mysqlDB 
    -e MYSQL_USER=mysqlUser 
    -e MYSQL_PASSWORD=mysqlPassword 
    -d mysql: 8.0.31

(version 8.0.31 is a request from the challenge)

to connect to the database (I'm using the Dbeaver client so this are the folloewing ):

    jdbc:mysql://localhost:3306/mysqlDB?allowPublicKeyRetrieval=true&useSSL=false

---
    MYSQL_USER=mysqlUser 
    MYSQL_PASSWORD=mysqlPassword 

---
---
---
## Part 01 - Preliminary analysis in SQL :

> Notes: Keep in mind the data is not completely clean and it is possible that you will have to make assumptions on what data to ignore and why. Be sure to address these decisions and assumptions in your report.

>Three key variables to pay attention to in your analysis are: Campaign goals in dollars, Number of backers, and Length of campaigns

1. Are the goals for dollars raised significantly different between campaigns that are successful and unsuccessful?

| Successful | Failed   | Undefined | All      |
| --------   | -------  | -------- | -------  |
| $9,743     | $97,520  | $146,401 | $72,361  |


- 'successful' avg of the goal is 9,743
- 'failed' avg of the goal is 97,520
- 'undefined' avg of the goal is 146,401
- all avg of the goal is 72,361


```
SELECT avg(goal) FROM campaign 
where outcome 
-- = 'failed'
-- = 'successful'
-- in ('canceled', 'suspended', 'undefined', 'live' )
```

        

2. What are the top/bottom 3 categories with the most backers? 

- 

3. What are the top/bottom 3 subcategories by backers?

- 

4. What are the top/bottom 3 categories that have raised the most money? 

- 

5. What are the top/bottom 3 subcategories that have raised the most money?

- 

6. What was the amount the most successful board game company raised? 
How many backers did they have?

- 

7. Rank the top three countries with the most successful campaigns in terms of dollars (total amount pledged), and in terms of the number of campaigns backed.

- 

8. Do longer, or shorter campaigns tend to raise more money? Why?

- 

---
---
## Part 2 - Visualize the Data:

The executives have asked you to create 5 data visualizations that illustrate the key insights, trends, patterns, and oddities in the data.

Your visualizations must include titles and labels, and a summary of why each visualization might be important for your client and/or relevant to solving their business problem. You can use any visualization tool of your choice to create these 5 visualizations (Excel, Google Sheets etc.)


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

