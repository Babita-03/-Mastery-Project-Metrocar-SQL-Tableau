`1. Funnel Analysis
  WITH visitors AS (
SELECT DISTINCT app_download_key -- effectively a user_id
FROM app_downloads
   ),
  -- SIGN-UPS (FROM THE VISITORS ABOVE)
sign_ups AS (
  SELECT
    DISTINCT s.user_id
  FROM visitors v -- ensures we only look at the Visitors defined above
  INNER JOIN signups s ON v.app_download_key = s.session_id
),
-- ACTIVATIONS (FROM THE SIGN-UPS ABOVE)
riderequests AS (
  SELECT
    DISTINCT r.user_id,r.ride_id
  FROM ride_requests r  -- ensures we only look at the Signups defined above
  INNER JOIN signups s ON s.user_id = r.user_id),
  
  transactions AS (
      SELECT  DISTINCT(r.user_id),t.ride_id
      FROM transactions t
      JOIN riderequests r ON t.ride_id= r.ride_id
  ),
  reviews AS(
      SELECT DISTINCT  rw.user_id, rw.ride_id
      FROM reviews rw
      INNER JOIN transactions t ON t.ride_id=rw.ride_id
  ),

  steps AS(SELECT 'Visit' as step, COUNT(*) FROM visitors
  UNION -- joins the output of queries together (as long as they have the same columns)
SELECT 'Sign Up' AS step, COUNT(*) from sign_ups
  UNION
SELECT 'Ride_request' AS step, COUNT(DISTINCT user_id) FROM ride_requests
  UNION
SELECT 'Transaction' as step, COUNT(DISTINCT user_id) FROM transactions
UNION
SELECT 'Reviews' AS step, COUNT(DISTINCT user_id) FROM reviews
ORDER BY COUNT DESC)
 -- applies to the whole result)
SELECT
  step,
  COUNT,
  LAG(COUNT, 1) over (),
  ROUND(COUNT::numeric/LAG(COUNT, 1) over ()*100,2) AS percentage,
  ROUND((1 - COUNT ::numeric/ LAG(COUNT, 1) over ())*100,2) AS drop_off
  --round((1.0 - count::numeric/lag(count, 1) over ()),2)
FROM steps;`
