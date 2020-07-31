USE WideWorldImporters;
GO

/* Lightweight profiling. 
- Auto enabled in SQL2019, Azure SQL, SQL MI with option LIGHTWEIGHT_QUERY_PROFILING 
*/

--SELECT StockItemName, 
--       UnitPrice * QuantityPerOuter AS CostPerOuterBox, 
--       QuantityOnHand
--FROM Warehouse.stockitems s
--     INNER JOIN warehouse.StockItemHoldings sh ON s.StockItemID = sh.StockItemID
--ORDER BY CostPerOuterBox OPTION(USE HINT('QUERY_PLAN_PROFILE'));

/* DMV sys.dm_exec_query_plan_stats*/

--SELECT *
--FROM sys.dm_exec_cached_plans AS cp
--     CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
--     CROSS APPLY sys.dm_exec_query_plan_stats(plan_handle) AS qps;

/* DMV sys.dm_exec_query_plan_stats and trace flag 2451*/

--DBCC TRACEON(2451, -1); 
--GO 
--USE WideWorldImporters; 
--GO 
--SELECT ol.StockItemID, 
--       ol.Description, 
--       SUM(ol.quantity - ol.pickedquantity) AS allocatedQuantity
--FROM sales.OrderLines ol WITH(NOLOCK)
--GROUP BY ol.StockItemID, 
--         ol.Description;
--GO
--SELECT qps.query_plan, 
--       st.text, 
--       DB_NAME(st.dbid) DBName, 
--       OBJECT_NAME(st.objectid) objectName, 
--       cp.useCounts, 
--       cp.objType
--FROM sys.dm_exec_cached_plans cp
--     CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
--     CROSS APPLY sys.dm_exec_query_plan_stats(plan_handle) AS qps
--WHERE st.encrypted = 0
--      AND st.text LIKE 'SELECT ol.%';
--GO 
--DBCC TRACEON(2451, 0); 
--GO

/* Hardware Problems 
- CPU: SOS_SCHEDULER_YIELD, CXPACKET  
- Storage: disk seconds/read, disk seconds/write, pageiolatch_sh
- SARGArbility -- WHERE leading to SEEK 
- indexes: sys.dm_db_index_operational_stats, sys.dm_db_index_usage_stats
- old stats: trace flag 2371 (<SQL2016). >2016 - default auto-update
- query optimizer: OPTION (OPTIMIZE FOR (@city_name = 'CityName'))
- Parameter sniffing (OPTION(RECOMPILE) for a specific value within the USP)
*/

/* Perf based DB Design 
- Normalization: 1NF, 2NF, 3NF, Denormalization, Star Schema.
- Desing Index: CI, NCI (index node, root node). Columnstore Index (COMPRESS_ALL_ROW_GROUPS) 
	- Row Compression. Page Compression. MS XPRESS algorithm. 
*/ 
/* DMV, DMF 
- VIEW SERVER/DATABASE STATE
- DMV/DMF: sys.dm_exec_sql_text, sys.dm_exec_query_plan
- Wait Stats: sys.dm_os_wait_stats, dm_db_wait_stats, dm_exec_session_wait_stats
- Waits: CXPACKET, SOS_SCHEDULER_YIELD, RESOURCE_SEMAPHORE, LCK_M_X, PAGEIOLATCH_SH, SOS_SCHEDULER_YIELD, 
- Index (reorg/rebuild): sys.dm_db_index_physical_stats, dm_dm_column_store_group_physical_stats
- Columnstore: sys.dm_dm_column_store_row_group_physical_stats
*/