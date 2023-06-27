1. Funnel Analysis & dropoff
  
WITH total_users AS(
SELECT app_download_key
FROM app_downloads),


signup AS(
    SELECT  s.user_id  
   
    FROM  signups s
     LEFT JOIN total_users t ON s.session_id=t.app_download_key
),
requests AS(
    SELECT DISTINCT r.user_id ,r.ride_id,r.dropoff_ts
    FROM signup s
    LEFT JOIN  ride_requests r
    ON s.user_id=r.user_id
),


purchase AS(
    SELECT DISTINCT(r.user_id) , t.ride_id
   
     FROM transactions t
     LEFT JOIN requests r  
    ON t.ride_id=r.ride_id WHERE r.dropoff_ts IS NOT NULL
),
 reviews AS(
      SELECT DISTINCT  rw.user_id
      FROM purchase  p
      LEFT JOIN reviews rw
      ON p.ride_id=rw.ride_id),


funnel_stages AS(
SELECT 1 AS Funnel_step ,'Downloads' AS funnel_name,
COUNT(total_users) AS value
FROM total_users


UNION
SELECT 2 AS Funnel_step,'Signups' AS funnel_name,
COUNT(signup) AS value
FROM signup


UNION
SELECT 3 AS Funnel_step,'Ride_requests' AS funnel_name,
COUNT(DISTINCT user_id) AS value
FROM requests
UNION
SELECT 4 AS Funnel_step,'Transactions' AS funnel_name,
COUNT( DISTINCT user_id) AS value
FROM purchase
UNION
SELECT 5 AS Funnel_step,'Reviews' AS funnel_name,
COUNT( DISTINCT user_id) AS value
FROM reviews)


SELECT *,
lag(value) OVER(ORDER BY funnel_step) AS previous_value,
ROUND(value::numeric/lag(value) OVER(ORDER BY funnel_step)*100,2)
 AS previous_valuePCT,
 ROUND((1 - value ::numeric/ lag(value) over (ORDER BY funnel_step))*100,2) AS drop_off  FROM funnel_stages

2. Adding more columns to funnel stages

WITH total_users AS (SELECT a.app_download_key,a.platform,
signups.age_range,a.download_ts
FROM app_downloads a  LEFT JOIN signups
ON a.app_download_key=signups.session_id),


signup AS(SELECT s.user_id ,t.platform,s.age_range,t.download_ts
FROM total_users t
LEFT JOIN signups s ON s.session_id=t.app_download_key
),


ride_request AS(SELECT DISTINCT r.user_id,r.ride_id,r.dropoff_ts,
s.platform,s.age_range,s.download_ts
FROM ride_requests r
 INNER JOIN signup s ON s.user_id=r.user_id),
 
 ride_accepted AS( SELECT DISTINCT r.user_id,ride_id,s.platform,
 s.age_range,s.download_ts
 FROM ride_requests r JOIN signup s ON s.user_id=r.user_id
 WHERE accept_ts IS NOT NULL ),


 ride_completed AS( SELECT DISTINCT r.user_id,ride_id,s.platform,
 s.age_range,s.download_ts
 FROM ride_requests r JOIN signup s ON s.user_id=r.user_id
 WHERE pickup_ts IS NOT NULL AND dropoff_ts IS NOT NULL),


 transaction AS(SELECT DISTINCT rr.user_id,t.ride_id,rr.platform,
 t.charge_status,rr.age_range,rr.download_ts
 FROM transactions t
 LEFT JOIN ride_request rr ON rr.ride_id=t.ride_id
 WHERE dropoff_ts IS NOT NULL AND charge_status='Approved'),


 review AS(SELECT DISTINCT  rw.user_id,rw.ride_id,t.platform,
 t.age_range,t.download_ts
      FROM transaction t
      LEFT JOIN reviews rw
      ON t.ride_id=rw.ride_id),


funnel_stages AS(
SELECT 0 AS Funnel_step,'Download 'AS Funnel_name,platform,
age_range,download_ts,
COUNT(app_download_key) AS User_count, 0 AS
ride_count
FROM total_users GROUP BY platform,age_range,download_ts
UNION
SELECT 1 AS Funnel_step,'Signups' AS Funnel_name,platform,
age_range,download_ts,
COUNT(user_id) AS User_count, 0 AS
ride_count
FROM signup GROUP BY platform,age_range,download_ts
UNION
SELECT 2 AS Funnel_step,'Ride_requests' AS Funnel_name,platform,
age_range,download_ts,
COUNT(DISTINCT user_id) AS User_count,COUNT(ride_id) AS
ride_count
FROM ride_request GROUP BY platform,age_range,download_ts
UNION
SELECT 3 AS Funnel_step,'Rides_accepted' AS Funnel_name,
platform,age_range,download_ts,
COUNT(DISTINCT user_id) AS User_count,COUNT(ride_id) AS
ride_count
FROM ride_accepted GROUP BY platform,age_range,download_ts
UNION
SELECT 4 AS Funnel_step,'Rides_completed' AS Funnel_name,
platform,age_range,download_ts,
COUNT(DISTINCT user_id) AS User_count,COUNT(ride_id) AS
ride_count
FROM ride_completed GROUP BY platform,age_range,download_ts
UNION
SELECT 5 AS Funnel_step,'Payment' AS Funnel_name,
platform,age_range,download_ts,
COUNT(DISTINCT user_id) AS User_count,COUNT(ride_id) AS
ride_count
FROM transaction GROUP BY platform,age_range,download_ts
UNION
SELECT 6 AS Funnel_step,'Review' AS Funnel_name,
platform,age_range,download_ts,
COUNT(DISTINCT user_id) AS User_count,COUNT(ride_id) AS
ride_count
FROM review GROUP BY platform,age_range,download_ts)


SELECT Funnel_step,Funnel_name,platform,age_range,
DATE( download_ts) AS download_dt,user_count,ride_count
FROM funnel_stages
ORDER BY Funnel_step,platform



