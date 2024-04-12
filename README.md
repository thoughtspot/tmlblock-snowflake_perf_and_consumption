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

# Snowflake Performance and Consumption SpotApp - Prerequisites

Before deploying the Snowflake Performance and Consumption SpotApp, ensure the following prerequisites are met:

## Review and Sync Data

- **Review Required Data**: Confirm that your columns match the required column type listed in the SpotApp schema.
- **Sync Data**: Sync all necessary tables and columns from Snowflake to your cloud data warehouse (CDW). While it's possible to sync only required tables and columns, ThoughtSpot recommends syncing all tables and columns for comprehensive integration.

## Credentials and Permissions

- **Snowflake Credentials**: Obtain credentials and SYSADMIN privileges to access your Snowflake environment which should contain the data used by ThoughtSpot to create Answers, Liveboards, and Worksheets.
- **Unique Connection Name**: Each SpotApp connection must have a unique name.
- **Access Requirements**:
  - ACCOUNTADMIN access to Snowflake.
  - Access to the SNOWFLAKE database in your Snowflake environment.
  - Access to specific Snowflake tables: `DATABASE_STORAGE_USAGE_HISTORY`, `QUERY_HISTORY`, `STAGES`, `STORAGE_USAGE`, `WAREHOUSE_METERING_HISTORY`.

## SQL Setup

You can set up the SpotApp using one of two options. Run the required SQL commands in your cloud data warehouse based on your chosen option:

### Option 1: Fast Performance

This option involves copying data from the SNOWFLAKE database to a different database using Snowflake tasks.

#### SQL Commands for Option 1

```sql
CREATE DATABASE "SNOWFLAKE_USAGE_TS";
CREATE SCHEMA "SNOWFLAKE_USAGE_TS"."SNOWFLAKE";
-- Add tasks for each table like QUERY_HISTORY, WAREHOUSE_METERING_HISTORY, etc.
-- Replace <YOUR_WAREHOUSE> with your specific information.

### Option 2: Direct Query

This option involves querying the system database directly, which may be slower and more expensive.

#### SQL Commands for Option 2

```sql
GRANT USAGE ON DATABASE "SNOWFLAKE" TO ROLE <YOUR_ROLE>;
GRANT USAGE ON SCHEMA "SNOWFLAKE"."ACCOUNT_USAGE" TO ROLE <YOUR_ROLE>;
-- Add SELECT permissions for each required table.


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





