CREATE DATABASE  "SNOWFLAKE_USAGE_TS";
CREATE SCHEMA “SNOWFLAKE_USAGE_TS”."SNOWFLAKE";
CREATE OR REPLACE TASK UPDATE_QUERY_HISTORY
WAREHOUSE = <YOUR_WAREHOUSE>
SCHEDULE = 'USING CRON 0 0 1 * * UTC'
AS CREATE OR REPLACE TABLE "SNOWFLAKE_USAGE_TS"."SNOWFLAKE"."QUERY_HISTORY" AS (SELECT
"QUERY_ID",
"QUERY_TEXT",
"DATABASE_ID",
"DATABASE_NAME",
"SCHEMA_ID",
"SCHEMA_NAME",
"QUERY_TYPE",
"SESSION_ID",
"USER_NAME",
"ROLE_NAME",
"WAREHOUSE_ID",
"WAREHOUSE_NAME",
"WAREHOUSE_SIZE",
"WAREHOUSE_TYPE",
"QUERY_TAG",
"EXECUTION_STATUS",
"ERROR_CODE",
"ERROR_MESSAGE",
"START_TIME",
"ROWS_PRODUCED",
"PARTITIONS_SCANNED",
"PARTITIONS_TOTAL",
"PERCENTAGE_SCANNED_FROM_CACHE",
"BYTES_SPILLED_TO_LOCAL_STORAGE",
"BYTES_SPILLED_TO_REMOTE_STORAGE",
"QUEUED_REPAIR_TIME",
"QUEUED_OVERLOAD_TIME",
"QUEUED_PROVISIONING_TIME",
"TOTAL_ELAPSED_TIME",
"COMPILATION_TIME",
"EXECUTION_TIME" FROM "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY");
CREATE OR REPLACE TASK UPDATE_WAREHOUSE_METERING_HISTORY
WAREHOUSE = <YOUR_WAREHOUSE>
SCHEDULE = 'USING CRON 0 0 1 * * UTC'
AS CREATE OR REPLACE TABLE "SNOWFLAKE_USAGE_TS"."SNOWFLAKE"."WAREHOUSE_METERING_HISTORY" AS (SELECT
"WAREHOUSE_ID",
"WAREHOUSE_NAME",
"START_TIME",
"CREDITS_USED",
"CREDITS_USED_COMPUTE",
"CREDITS_USED_CLOUD_SERVICES",
"END_TIME" FROM "SNOWFLAKE"."ACCOUNT_USAGE"."WAREHOUSE_METERING_HISTORY");
CREATE OR REPLACE TASK UPDATE_STAGES
WAREHOUSE = <YOUR_WAREHOUSE>
SCHEDULE = 'USING CRON 0 0 1 * * UTC'
AS CREATE OR REPLACE TABLE "SNOWFLAKE_USAGE_TS"."SNOWFLAKE"."STAGES" AS (SELECT
"STAGE_ID",
"STAGE_NAME",
"STAGE_SCHEMA_ID",
"STAGE_SCHEMA",
"STAGE_CATALOG_ID",
"STAGE_CATALOG",
"STAGE_TYPE",
"STAGE_OWNER",
"DELETED" FROM "SNOWFLAKE"."ACCOUNT_USAGE"."STAGES");
CREATE OR REPLACE TASK UPDATE_STORAGE_USAGE
WAREHOUSE = <YOUR_WAREHOUSE>
SCHEDULE = 'USING CRON 0 0 1 * * UTC'
AS CREATE OR REPLACE TABLE "SNOWFLAKE_USAGE_TS"."SNOWFLAKE"."STORAGE_USAGE" AS (SELECT
"USAGE_DATE",
"FAILSAFE_BYTES",
"STAGE_BYTES",
"STORAGE_BYTES" FROM "SNOWFLAKE"."ACCOUNT_USAGE"."STORAGE_USAGE");
CREATE OR REPLACE TASK UPDATE_DATABASE_STORAGE_USAGE_HISTORY
WAREHOUSE = <YOUR_WAREHOUSE>
SCHEDULE = 'USING CRON 0 0 1 * * UTC'
AS CREATE OR REPLACE TABLE "SNOWFLAKE_USAGE_TS"."SNOWFLAKE"."DATABASE_STORAGE_USAGE_HISTORY" AS (SELECT
"USAGE_DATE",
"DATABASE_ID",
"DATABASE_NAME",
"DELETED",
"AVERAGE_DATABASE_BYTES",
"AVERAGE_FAILSAFE_BYTES" FROM "SNOWFLAKE"."ACCOUNT_USAGE"."DATABASE_STORAGE_USAGE_HISTORY");
alter task UPDATE_DATABASE_STORAGE_USAGE_HISTORY RESUME;
alter task UPDATE_STORAGE_USAGE RESUME;
alter task UPDATE_STAGES RESUME;
alter task UPDATE_WAREHOUSE_METERING_HISTORY RESUME;
alter task UPDATE_QUERY_HISTORY RESUME;
execute task UPDATE_DATABASE_STORAGE_USAGE_HISTORY;
execute task UPDATE_STORAGE_USAGE;
execute task UPDATE_STAGES;
execute task UPDATE_WAREHOUSE_METERING_HISTORY;
execute task UPDATE_QUERY_HISTORY;
GRANT USAGE ON DATABASE "SNOWFLAKE_USAGE_TS" TO ROLE <YOUR_ROLE>;
GRANT USAGE ON SCHEMA "SNOWFLAKE_USAGE_TS"."SNOWFLAKE" TO ROLE <YOUR_ROLE>;
GRANT SELECT ON ALL TABLES IN SCHEMA "SNOWFLAKE_USAGE_TS"."SNOWFLAKE" TO ROLE <YOUR_ROLE>;;