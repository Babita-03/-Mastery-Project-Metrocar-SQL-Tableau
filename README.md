### -Mastery-Project-Metrocar-SQL-Tableau

>**This project aims to analyze the customer funnel of Metrocar, a ride-sharing app (similar to Uber/Lyft), to identify areas for improvement and optimization. The stakeholders have asked several business questions that can uncover valuable insights for improving specific areas of the customer funnel. Your task is to conduct a funnel analysis and present your analysis and recommendation.**
>-  Conduct funnel analysis to calculate drop-offs in the customer journey using SQL spreadsheets and Tableau.
>- Answer specific business research questions to identify areas for improvement and optimization and make recommendations to stakeholders.
 > 
 >1. What steps of the funnel should we research and improve? Are there any specific drop-off points preventing users from completing their first ride?
>2. Metrocar currently supports 3 different platforms: ios, android, and web. To recommend where to focus our marketing budget for the upcoming year, what insights can we make based on the platform?
>3. What age groups perform best at each stage of our funnel? Which age group(s) likely contain our target customers?
>4. Surge pricing is the practice of increasing the price of goods or services when there is the greatest demand for them. If we want 
   to adopt a price-surging strategy, what does the distribution of ride requests look like throughout the day?
>5. What part of our funnel has the lowest conversion rate? What can we do to improve this part of the funnel?
>
>- Perform an analysis using multiple tools: SQL spreadsheets and Tableau.
>- Interpret and communicate data effectively through written reports and video presentations.

![image](https://github.com/Babita-03/-Mastery-Project-Metrocar-SQL-Tableau/assets/130641794/be761f5a-41c5-4c3c-8ed0-e5e7ae51ac8a)
***

  **Dataset structure**

 You can find a description of each table and its columns below.

**- app_downloads: contains information about app downloads  completed rides**

app_download_key: unique id of an app download

platform: ios, android or web

download_ts: download timestamp

**- signups: contains information about new user signups**
  
user_id: primary id for a user

session_id: id of app download

signup_ts: signup timestamp

**- ride_requests: contains information about rides**
  
ride_id: primary id for a ride

user_id: foreign key to user (requester)

driver_id: foreign key to driver

request_ts: ride request timestamp

accept_ts: driver accept timestamp

pickup_location: pickup coordinates

destination_location: destination coordinates

pickup_ts: pickup timestamp

dropoff_ts: dropoff timestamp

cancel_ts: ride cancel timestamp (accept, pickup and dropoff timestamps may be null)

**- transactions: contains information about financial transactions based on completed rides:**

ride_id: foreign key to ride

purchase_amount_usd: purchase amount in USD

charge_status: approved, cancelled

transaction_ts: transaction timestamp

**- reviews: contains information about driver reviews once rides are completed**

review_id: primary id of review

ride_id: foreign key to ride

driver_id: foreign key to driver

user_id: foreign key to user (requester)

rating: rating from 0 to 5

free_response: text response given by user/requester
