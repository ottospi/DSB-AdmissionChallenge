select * from campaign;

select count(*) from campaign where outcome='successful';
select count(*) from campaign where outcome='failed';

select count(*) from campaign where outcome not  IN ('failed', 'successful', 'canceled') 

select * from campaign 
where outcome not IN 
('failed', 'successful', 'canceled', 'suspended', 'undefined', 'live')


select * from campaign 
where outcome not IN 
('failed', 'successful', 'canceled', 'suspended', 'undefined', 'live')

success:
'successful'

unsuccess:
'failed', 

undefined:
'canceled', 
'suspended', 
'undefined', 
'live'

all: 
('failed', 'successful', 'canceled', 'suspended', 'undefined', 'live')

SELECT 
-- id,
name, 
goal, 
pledged, 
outcome 
FROM campaign
where outcome = 'successful'  


SELECT 
-- id,
-- name, 
avg(goal)
-- pledged, 
-- outcome
FROM campaign
where outcome 
-- = 'failed'
-- = 'successful'
in ('canceled', 'suspended', 'undefined', 'live' )

-- AND pledged >= goal
'successful' avg of the goal is 9,743
'failed'avg of the goal is 97,520



select * from currency 



SELECT 
id,
name, 
(select name from sub_category sc where sub_category_id = sc.id) as sub_category, 
(select name from country c where country_id = c.id) as country,
(select name from currency c where currency_id = c.id) as currency, 
launched, 
deadline, 
goal, 
pledged, 
backers, 
outcome
FROM campaign  


select 
campaign.id as id_campaign,
campaign.name as campaing_name, 
sub_c.name as sub_cat_name, 
(select name from category c where category_id = c.id) as category_name, 
(select name from country c where campaign.country_id = c.id) as country,
(select name from currency c where campaign.currency_id = c.id) as currency, 
campaign.launched, 
campaign.deadline, 
campaign.goal, 
campaign.pledged, 
campaign.backers, 
campaign.outcome
FROM campaign campaign 
join sub_category sub_c where sub_c.id = campaign.sub_category_id


Moeda	Valor
GBP	1.22
USD	1
CAD	0.79
AUD	0.71
NOK	0.10
EUR	0.92
MXN	20.37
SEK	0.10
NZD	0.65
CHF	0.99
DKK	0.14
HKD	7.84
SGD	0.74
JPY	0.0093


-- --------------------------------
-- ---- DADO NORMALIZADO E CORRETO
-- --------------------------------
select 
campaign.id as id,
campaign.name as campaing_name, 
sub_c.name as sub_cat_name, 
(select name from category c where category_id = c.id) as category_name, 
(select name from country c where campaign.country_id = c.id) as country,
(select name from currency c where campaign.currency_id = c.id) as currency,
(select ratio_to_dollar from currency c where campaign.currency_id = c.id) as ratio,
campaign.goal * (select ratio_to_dollar from currency c where campaign.currency_id = c.id) as Goal_Dollar,
campaign.pledged * (select ratio_to_dollar from currency c where campaign.currency_id = c.id) as Pledged_Dollar, 
campaign.goal, 
campaign.pledged,
campaign.backers, 
campaign.outcome,
campaign.launched, 
campaign.deadline
FROM campaign campaign 
join sub_category sub_c on sub_c.id = campaign.sub_category_id
where campaign.outcome 
-- = 'failed'
= 'successful'
-- in ('canceled', 'suspended', 'undefined', 'live' )
-- group by currency
order by Pledged_Dollar desc
-- --------------------------------
-- ---- DADO NORMALIZADO E CORRETO
-- --------------------------------

valueInDollar
ratio_to_dollar



SELECT 
COUNT(campaign.id) as Units,
FORMAT( AVG( campaign.goal ) ,0) as AVG_Goal,
FORMAT( AVG( campaign.pledged ) ,0) as AVG_Pledged,
FORMAT( AVG( campaign.goal * ( select ratio_to_dollar from currency c where campaign.currency_id = c.id ) ) ,0) as AVG_Goal_Dollar,
FORMAT( AVG( campaign.pledged * ( select ratio_to_dollar from currency c where campaign.currency_id = c.id ) ) ,0)as AVG_Pledged_Dollar, 
FORMAT( SUM( campaign.pledged * ( select ratio_to_dollar from currency c where campaign.currency_id = c.id ) ) ,0) as SUM_Pledged_Dollar,
SUM(campaign.backers) as SUM_backers,
FORMAT( SUM( campaign.pledged * ( select ratio_to_dollar from currency c where campaign.currency_id = c.id ) ) / SUM(campaign.backers) ,2) 
as ratio
FROM campaign campaign 
JOIN sub_category sub_c ON sub_c.id = campaign.sub_category_id
where 
(select name from category c where category_id = c.id) = 'Games'
-- and sub_c.name = 'Tabletop Games'
-- WHERE campaign.outcome 
-- = 'failed'
-- = 'successful'
-- in ('canceled', 'suspended', 'undefined', 'live' )


SELECT 
COUNT(campaign.id) as Units,
FORMAT( AVG( campaign.goal * ( select ratio_to_dollar from currency c where campaign.currency_id = c.id ) ) ,0) as AVG_Goal_Dollar,
FORMAT( AVG( campaign.pledged * ( select ratio_to_dollar from currency c where campaign.currency_id = c.id ) ) ,0)as AVG_Pledged_Dollar
-- FORMAT( SUM( campaign.pledged * ( select ratio_to_dollar from currency c where campaign.currency_id = c.id ) ) ,0) as SUM_Pledged_Dollar,
-- SUM(campaign.backers) as SUM_backers,
-- FORMAT( SUM( campaign.pledged * ( select ratio_to_dollar from currency c where campaign.currency_id = c.id ) ) / SUM(campaign.backers) ,2) as ratio
FROM campaign campaign 
JOIN sub_category sub_c ON sub_c.id = campaign.sub_category_id
where 
(select name from category c where category_id = c.id) = 'Games'


-- ------------

select  
COUNT( campaign.id )as UNITS,
SUM(campaign.outcome = 'successful') AS SUCC,
SUM(campaign.outcome = 'failed') AS FAILED,
SUM(campaign.outcome in ('canceled', 'suspended', 'undefined', 'live' ) ) AS UNDEFINED,
(SUM(campaign.outcome = 'successful')*100)/COUNT( campaign.id ) as SUCCESS_PORCERT,
(SUM(campaign.outcome = 'failed')*100)/COUNT( campaign.id ) as FAILED_PORCERT,
(SUM(campaign.outcome in ('canceled', 'suspended', 'undefined', 'live' ))*100)/COUNT( campaign.id ) as UNDEFINED_PORCERT,
CASE 
	WHEN DATEDIFF( campaign.deadline, campaign.launched ) <= 30 THEN 'short'
	WHEN DATEDIFF( campaign.deadline, campaign.launched ) <= 60 THEN 'medium'
	ELSE 'long' 
END AS duration
FROM campaign campaign  join sub_category sub_c on sub_c.id = campaign.sub_category_id
GROUP BY duration 


0-30
31-60
61-100

|SUM|success|failed|undefined|success %|failed %|undefined %|duration|
|--|--|--|--|--|--|--|
| 9433 | 3413 | 4971 | 1049 | 36.1815 | 52.6980 | 11.1205 | short |
| 5331 | 1811 | 2761 | 759 | 33.9711 | 51.7914	14.2375 | medium |
| 236 | 95 | 118 | 23 | 40.2542 | 50.0000 | 9.7458 | long |


ID | Name | SubCategory | Category | Contry | Currency| Goal | Pledged | Backers | Launched | Deadline |
7161 | Bring Reading Rainbow Back for Every Child, Everywhere!	| Web | Technology | US | USD | 1000000.0 | 5408916.95 | 105,857 | 2014-05-28 | 2014-07-02 |



SELECT 
campaign.id ,
campaign.name AS campaing_name, 
sub_c.name AS sub_cat_name, 
(SELECT name FROM category c WHERE category_id = c.id) AS category_name, 
(SELECT name FROM country c WHERE campaign.country_id = c.id) AS country,
(SELECT name FROM currency c WHERE campaign.currency_id = c.id) AS currency,
(SELECT ratio_to_dollar FROM currency c WHERE campaign.currency_id = c.id) AS ratio,
format(campaign.goal,0) as goal,
format(campaign.pledged,0) pledged,
format(goal * (SELECT  ratio_to_dollar FROM currency c WHERE campaign.currency_id = c.id) ,0) AS Goal_Dollar,
format(pledged * (SELECT  ratio_to_dollar FROM currency c WHERE campaign.currency_id = c.id) ,0) AS Pledged_Dollar, 
campaign.backers, 
campaign.outcome,
campaign.launched, 
campaign.deadline,
DATEDIFF( campaign.deadline, campaign.launched ) AS CampaingDuration
FROM campaign campaign  JOIN sub_category sub_c ON sub_c.id = campaign.sub_category_id

order by Pledged_Dollar desc



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
-- where (select name from category c where category_id = c.id) = 'Games' 
GROUP BY duration





------





SELECT 
COUNT(campaign.id) as Units,
-- FORMAT( AVG( campaign.goal ) ,0) as AVG_Goal,
-- FORMAT( AVG( campaign.pledged ) ,0) as AVG_Pledged,
FORMAT( AVG( campaign.goal * ( select ratio_to_dollar from currency c where campaign.currency_id = c.id ) ) ,0) as AVG_Goal_Dollar,
FORMAT( AVG( campaign.pledged * ( select ratio_to_dollar from currency c where campaign.currency_id = c.id ) ) ,0)as AVG_Pledged_Dollar, 
-- FORMAT( SUM( campaign.pledged * ( select ratio_to_dollar from currency c where campaign.currency_id = c.id ) ) ,0) as SUM_Pledged_Dollar,
-- SUM(campaign.backers) as SUM_backers,
-- FORMAT( SUM( campaign.pledged * ( select ratio_to_dollar from currency c where campaign.currency_id = c.id ) ) / SUM(campaign.backers) ,2) 
-- as ratio
-- --------------
-- campaign.id as id,
-- campaign.name as campaing_name, 
-- sub_c.name as sub_cat_name, 
-- (select name from category c where category_id = c.id) as category_name, 
-- (select name from country c where campaign.country_id = c.id) as country,
-- (select name from currency c where campaign.currency_id = c.id) as currency,
-- (select ratio_to_dollar from currency c where campaign.currency_id = c.id) as ratio,
-- FORMAT( campaign.goal * (select ratio_to_dollar from currency c where campaign.currency_id = c.id)  ,0) as Goal_Dollar,
-- FORMAT( campaign.pledged * (select ratio_to_dollar from currency c where campaign.currency_id = c.id) ,0) as Pledged_Dollar 
-- campaign.goal, 
-- campaign.pledged,
FORMAT( avg(campaign.backers) ,0),
AVG( campaign.pledged * ( select ratio_to_dollar from currency c where campaign.currency_id = c.id ) ) / avg(campaign.backers) as mediaDasDoações
-- campaign.outcome,
-- campaign.launched, 
-- campaign.deadline
FROM campaign campaign 
JOIN sub_category sub_c ON sub_c.id = campaign.sub_category_id
where 
(select name from category c where category_id = c.id) = 'Games'
-- and sub_c.name = 'Tabletop Games'
-- WHERE campaign.outcome 
-- = 'failed'
-- = 'successful'
-- in ('canceled', 'suspended', 'undefined', 'live' )
order by campaign.launched desc



SELECT  
COUNT( campaign.id ) AS UNITS,
SUM(campaign.outcome = 'successful') AS SUCCESSFULL,
SUM(campaign.outcome = 'failed') AS FAILED,
SUM(campaign.outcome IN ('canceled', 'suspended', 'undefined', 'live' ) ) AS UNDEFINED,
(SUM(campaign.outcome = 'successful')*100)/COUNT( campaign.id ) AS SUCCESS_PORCERT,
(SUM(campaign.outcome = 'failed')*100)/COUNT( campaign.id ) as FAILED_PORCERT,
(SUM(campaign.outcome IN ('canceled', 'suspended', 'undefined', 'live' ))*100)/COUNT( campaign.id ) as UNDEFINED_PORCERT,
CASE 
	WHEN DATEDIFF( campaign.deadline, campaign.launched ) <= 30 THEN 'short'
	WHEN DATEDIFF( campaign.deadline, campaign.launched ) <= 60 THEN 'medium'
	ELSE 'long' 
END AS DURATION
FROM campaign campaign JOIN sub_category sub_c ON sub_c.id = campaign.sub_category_id
where (select name from category c where category_id = c.id) = 'Games'
and sub_c.name = 'Tabletop Games'
GROUP BY DURATION



