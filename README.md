# Snowflake Performance & Consumption Analytics TML Blocks

SpotApps are ThoughtSpot’s out-of-the-box solution templates built for specific use cases and data sources. They are built on ThoughtSpot Modeling Language (TML) Blocks, which are pre-built pieces of code that are easy to download and implement directly from the product.

The Snowflake Performance and Consumption SpotApp mimics the Snowflake data model. When you deploy it, ThoughtSpot creates several Worksheets, Answers, and Liveboards, based on your Snowflake data in your cloud data warehouse.

Use the Snowflake Performance and Consumption SpotApp to manage Snowflake costs and investigate query performance. Track how and where your users consume credits, and triage and resolve any performance bottlenecks.

# Artifacts 

## Worksheets 
snowflake_tmlblocks_worksheets.zip
- Stage Analysis
- Database Storage History
- Database Storage Usage
- Warehouse Metering History
- Storage Usage

## Liveboards 
snowflake_tmlblocks_liveboards.zip
- Snowflake Query Volume: are queries TS Index queries, queued, using cloud services?
- Snowflake Query Performance: what is the latency of queries?
- Snowflake Query Credit Costs: identify potentially expensive queries?
- Snowflake Stages: meta data information for stages? I.e. owners, databases.
- Snowflake Database Storage: how is storage being consumed and estimated costs?
- Snowflake Warehouse Consumption: which warehouses are consuming credits?
- Snowflake Storage


# Prerequisites

Before you can deploy the Snowflake Performance and Consumption SpotApp, you must complete the following prerequisites:

- **Review the required tables and columns for the SpotApp.**
  
- **Ensure that your columns match the required column type listed in the schema for your SpotApp.**
  
- **Sync all tables and columns from Snowflake to your cloud data warehouse.** You can sync only the required tables and columns, but ThoughtSpot recommends syncing all tables and columns from Snowflake to your CDW. The columns can be Snowflake’s out-of-the-box columns, or any custom columns that you are using instead of the out-of-the-box columns.
  
- **If you are using an ETL/ELT tool or working with another team in your organization to move data, our recommendation is that you sync all columns from the tables listed in the SpotApp.**

- **Obtain credentials and SYSADMIN privileges to connect to your Snowflake environment.** Your Snowflake environment must contain the data you would like ThoughtSpot to use to create Answers, Liveboards, and Worksheets. Refer to the connection reference for Snowflake for information about required credentials.
  
- **The connection name for each new SpotApp must be unique.**
  
- **ACCOUNTADMIN access to Snowflake.**
  
- **Access to the SNOWFLAKE database in your Snowflake environment.**
  
- **Access to the following Snowflake tables in your Snowflake environment.** Refer to Snowflake Performance and Consumption SpotApp schema for more details.
  - `DATABASE_STORAGE_USAGE_HISTORY`
  - `QUERY_HISTORY`
  - `STAGES`
  - `STORAGE_USAGE`
  - `WAREHOUSE_METERING_HISTORY`

- **Run the required SQL commands in your cloud data warehouse.** Refer to Run SQL commands. Note that you have two options to set up the SpotApp; only choose one of the options.

## Run SQL commands

You can set up the SpotApp in one of two ways:

#### Option 1: Copy the data from the SNOWFLAKE database to a different database using Snowflake tasks.
This option has faster performance and a customizable cost. Refer to Option 1 SQL commands.

#### Option 2: Query on the system database directly.
This option has slower performance and may be more expensive. Refer to Option 2 SQL commands.

### Option 1

The following SQL commands grant permission for the role you use in your Snowflake connection to use the Snowflake database. They create a separate database and schema for the data in the Snowflake database, and create the tables with the data. Then, they grant permission for the role you use in your Snowflake connection to use the Snowflake database. Replace `<YOUR_ROLE>` and `<YOUR_WAREHOUSE>` with your specific information. The role should be either ACCOUNTADMIN or a custom SpotApps role. You can also modify the schedule. The following commands set the schedule to refresh the table data monthly. Changing the schedule may have performance and cost implications.

ThoughtSpot recommends you create the database and schema with the suggested names, using the first two commands in the SQL script. However, you can also use your own names. If you use different names, you must replace ThoughtSpot’s suggested names with the names you used.
Run these commands as the ACCOUNTADMIN. If you don’t have account admin access, you can create a custom role with the permissions required to execute tasks. See the Snowflake documentation.

Make sure to be consistent in your SQL script. If you use double quotes as object identifiers for one object, you must use double quotes for all objects. If you run all the commands at once, use semicolons to separate the commands.

[Option 1 SQL Commands](https://github.com/thoughtspot/tmlblock-snowflake_perf_and_consumption/blob/main/Option1.sql)


### Option 2

The following SQL commands grant permission for the role you use in your Snowflake connection to use the Snowflake database. They prepare you to query on the system database directly. Replace YOUR_ROLE with your specific information, either the ACCOUNTADMIN or a custom SpotApps role.

Run these commands as the ACCOUNTADMIN. If you don’t have account admin access, you can create a custom role with the permissions required to execute tasks. See the Snowflake documentation.

Make sure to be consistent in your SQL script. If you use double quotes as object identifiers for one object, you must use double quotes for all objects. If you run all the commands at once, use semicolons to separate the commands.

[Option 2 SQL Commands](https://github.com/thoughtspot/tmlblock-snowflake_perf_and_consumption/blob/main/Option2.sql)


## Connect Thoughtspot and Snowflake
Log into your ThoughtSpot instance and create an Embrace connection to each of the five following views: 
- DATABASE_STORAGE_USAGE_HISTORY
- QUERY_HISTORY
- STAGES
- STORAGE_USAGE
- WAREHOUSE_METERING_HISTORY

## Import TML Blocks 
1) Import the TML for the worksheets(snowflake_tmlblocks_worksheets) and verify that it has all been imported without any errors.
2) Afterwards, import the TML for the liveboards(snowflake_tmlblocks_liveboards) and verify that it has all been imported without any errors.

# Query Performance Considerations 

## Option 1: Shared View 

The QUERY_HISTORY table is slow to query. This requires either an X-LARGE or XX-LARGE warehouse to ensure queries are returned in a search time.
In addition an override parameter must be included in the ThoughtSpot URL, where the following increases the timeout to 3 mins.<br>
`https://[thoughtspotIP]/?queryDeadlineMs=300000/#/`<br>
Recommend that this is a separate Embrace connection so this warehouse can be isolated.

## Option 2: Replicate Data to Local Snowflake Cluster
Create a Snowflake task to replicate this data to local storage. 

--Create Database and Schema--<br>
`CREATE DATABASE  "SNOWFLAKE_USAGE_TS";
CREATE SCHEMA "ACCOUNT_USAGE";`

--Create Task --<br>
`CREATE TASK UPDATE_QUERY_HISTORY<br>
  WAREHOUSE = PMM_WH
  SCHEDULE = 'USING CRON 0 2 * * * UTC'
AS
CREATE OR REPLACE TABLE "SNOWFLAKE_USAGE_TS"."ACCOUNT_USAGE"."QUERY_HISTORY" AS (
  SELECT *
  FROM "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY"
  );`

# Liveboard Screenshots 

### Snowflake Query Volume
<img width="1500" alt="Snowflake Query Volume" src="https://user-images.githubusercontent.com/102629468/161118984-74c6c6e3-331d-430b-aec9-e30b37388473.png">

### Snowflake Query Performance
<img width="1500" alt="Snowflake Query Performance" src="https://user-images.githubusercontent.com/102629468/161119009-31e71eca-45cb-470e-b3d2-68ea5bf726a7.png">

### Snowflake Query Credit Costs
<img width="1500" alt="Snowflake Query Credit Costs" src="https://user-images.githubusercontent.com/102629468/161119036-92d781a5-3a3a-4750-ad1b-2f0891451ea7.png">

### Snowflake Stages
<img width="1500" alt="Snowflake Stages" src="https://user-images.githubusercontent.com/102629468/161119061-2e84b434-83fc-44ae-a93d-77f6b9d25e05.png">

### Snowflake Storage
<img width="1500" alt="Snowflake Storage" src="https://user-images.githubusercontent.com/102629468/161119088-2385a002-e518-43d6-9e7c-75cb65e38444.png">

### Snowflake Warehouse Consumption
<img width="1500" alt="Snowflake Warehouse Consumption" src="https://user-images.githubusercontent.com/102629468/161119106-1858f56f-6c45-4866-bbee-25c54e34d8e0.png">





