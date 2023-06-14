 1.How many times was the app downloaded?
  SELECT COUNT(*)
  FROM app_downloads;
  ANS:23608
  
 2.How many users signed up for the app?
  SELECT COUNT(*)
  FROM signups;
  ANS:17623
  
 3.How many rides were requested through the app?
   SELECT COUNT(*)
   FROM ride_requests;
   ANS: 385477
   
 4.How many rides were requested and completed through the app?
   SELECT COUNT(*) AS total_rides,(SELECT COUNT(*) AS completed
   FROM ride_requests
   WHERE pickup_ts IS NOT NULL AND dropoff_ts IS NOT NULL)
   FROM ride_requests;
   ANS:385477, 223652
   
 5.How many rides were requested and how many unique users requested a ride?
   SELECT COUNT(*) AS total_rides,
   COUNT(Distinct user_id) AS completed
   FROM ride_requests;
 ANS: 385477,12406
  
 6.What is the average time of a ride from pick up to drop off?
    SELECT AVG(dropoff_ts-pickup_ts)
    FROM ride_requests;
    ANS:52 minutes 36.738773 seconds
   
 7.How many rides were accepted by a driver?
    SELECT Count(accept_ts) As accepted_rides
    FROM ride_requests;
    ANS: 248379
    
 8.How many rides did we successfully collect payments and how much was collected?
    SELECT COUNT(ride_id) AS rides,ROUND(Sum(purchase_amount_usd)::numeric,2) AS payments_collected
    FROM transactions
    WHERE charge_status ='Approved';
    ANS:212628,4251667.61
    
  9.How many ride requests happened on each platform?
     SELECT count(*),a.platform
     FROM app_downloads a
     LEFT JOIN signups s
     ON a.app_download_key=s.session_id
     RIGHT JOIN  ride_requests r
     using(user_id)
     GROUP BY a.platform;
     ANS:112,317 android, 234,693 ios, 38,467 web
     
  10.What is the drop-off from users signing up to users requesting a ride?
      SELECT ROUND((COUNT(DISTINCT s.user_id) - COUNT(DISTINCT r.user_id)) /
      COUNT(DISTINCT s.user_id)::numeric * 100,2) AS drop_off
      FROM signups s
      LEFT JOIN ride_requests r ON s.user_id = r.user_id;
      ANS: 29.60








 
