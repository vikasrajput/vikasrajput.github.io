---
layout: page
title: Azure Synapse - Optimize SQL Pools - Monitor 
---
How to optimize performance with dedicated sql pool?

- [Manage & Govern for Performance](#manage--govern-for-performance) 
    - [Workload Management](#workload-management) 
        - [Classification](#workload-classification)
        - [Importance](#workload-importance) 
        - [Isolation](#workload-isolation)
    - [Cache Management](#cache-management)
    - [Manageability & Monitoring](#manageability-and-monitoring) 
- [What to Monitor](#what-to-monitor)
- [Query Optimization](#query-optimization) 
- [Best Practices Review](#best-practices---review)

<br><br>

## MANAGE & GOVERN FOR PERFORMANCE 

### Workload Management
- Example / Business Groups
    ```
    -- Group A
    CREATE WORKLOAD GROUP wgSample_groupA
    WITH (
    MIN_PERCENTAGE_RESOURCE = 40
    , REQUEST_MIN_RESOURCE_GRANT_PERCENT = 8
    , REQUEST_MAX_RESOURCE_GRANT_PERCENT = 16
    , CAP_PERCENTAGE_RESOURCE = 100 -- ( effective 70%)
    , IMPORTANCE = HIGH
    );
    -- Group B
    CREATE WORKLOAD GROUP wgSample_groupB
    WITH (
    MIN_PERCENTAGE_RESOURCE = 30
    , REQUEST_MIN_RESOURCE_GRANT_PERCENT = 5
    , REQUEST_MAX_RESOURCE_GRANT_PERCENT = 10
    , CAP_PERCENTAGE_RESOURCE = 100 -- ( effective 60%)
    );
    ```
- Shared Pool = 100 - (40 + 30) = 30%
- Guaranteed Concurrency 
    - GroupA = 40/8 = 5 
    - GroupB = 30/5 = 6
- Maximum Concurrency (min resource + shared)
    - GroupA = 70/8 = 9 (8.75)
    - GroupB = 60/5 = 12
- Applying Workload Classification (using workload group)
    ```
    CREATE WORKLOAD CLASSIFIER classifier_name
    WITH (
    WORKLOAD_GROUP = ‘name’
    , MEMBERNAME = ‘security_account’
    [ [ , ] IMPORTANCE = { LOW | BELOW_NORMAL | NORMAL | ABOVE_NORMAL | HIGH } ] )
    [ [ , ] WLM_LABEL = ‘label’ ]
    [ [ , ] WLM_CONTEXT = ‘name’ ]
    [ [ , ] START_TIME = ‘start_time’ ]
    [ [ , ] END_TIME = ‘end_time’ ]
    )[ ; ]
    ```

#### Workload Classification
- (and subclassification)
- CREATE WORKLOAD CLASSIFIER 
- Weighting
    - User: 64. Role: 32. WLM_Label: 16. WLM_CONTEXT: 8. Start/EndTime: 4 

#### Workload Importance 
- Levels: low, below_normal, **normal**, above_normal, and high
- Can help with locking and non-uniform request scenarios (example [here](https://miro.medium.com/max/1400/1*K5VEtbxpNqt6SnjC42Km-A.png){:target="_blank" rel="noopener"})

#### Workload Isolation 
- Use isolation carefully as it means resources are blocked even if unused 
    - Use them to achieve business SLAs, but use shared poool otherwise (and prefer workload importance instead)
- CREATE WORKLOAD GROUP 
- Works with **MIN_PERCENTAGE_RESOURCE (isolation)** and **CAP_PERCENTAGE_RESOURCE (containment)** paramters 
    - [Guaranteed Concurrency] = MIN_PERCENTAGE_RESOURCE / REQUEST_MIN_RESOURCE_GRANT_PERCENT
    - [Max Concurrency] = [CAP_PERCENTAGE_RESOURCE] / [REQUEST_MIN_RESOURCE_GRANT_PERCENT]
- There are more [scenarios](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-workload-isolation){:target="_blank" rel="noopener"} when concurrency can deviate
    - REQUEST_MAX_RESOURCE_GRANT_PERCENT is an optional parameter that defaults to the same value that is specified for REQUEST_MIN_RESOURCE_GRANT_PERCENT.
    - For allocating more resources per request, set REQUEST_MAX_RESOURCE_GRANT_PERCENT to value greater than REQUEST_MIN_RESOURCE_GRANT_PERCENT 
- In the absence of workload isolation, requests operate in the shared pool of resources. Access to resources in the shared pool is not guaranteed and is assigned on an importance basis.
    - [Shared Pool] = 100 - [sum of MIN_PERCENTAGE_RESOURCE across all workload groups]
- Execution Rules 
    - To set query execution timeout rule. QUERY_EXECUTION_TIMEOUT_SEC. 
- Shared Pool Resources 
    - [Shared Pool] = 100 - [sum of MIN_PERCENTAGE_RESOURCE across all workload groups]

### Memory & Concurrency Limits
- [Reference](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/memory-concurrency-limits){:target="_blank" rel="noopener"} 
- [Service Levels](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/memory-concurrency-limits#service-levels){:target="_blank" rel="noopener"}
- [Concurrency limits for workload groups](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/memory-concurrency-limits#concurrency-maximums-for-workload-groups){:target="_blank" rel="noopener"}
- [Concurrency maximus for Resource Classes](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/memory-concurrency-limits#concurrency-maximums-for-resource-classes){:target="_blank" rel="noopener"}

### Resource Classes 
- Static Resource Classes: allocate the same amount of memory regardless of the current performance level. staticrc[10,20,30,40,50,60,70,80]
- ideal if the data volume is known and constant
- [Dynamic Resource Classes](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/resource-classes-for-workload-management#dynamic-resource-classes){:target="_blank" rel="noopener"}: allocate a variable amount of memory depending on the current service level. **smallrc**, mediucrc, largerc, xlargerc. 
    - checkout default distribution for specific DWUs
- There are specific [operations governed by resource classes](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/resource-classes-for-workload-management#operations-governed-by-resource-classes){:target="_blank" rel="noopener"}
    - SELECT statements on dynamic management views (DMVs) or other system views are not governed by any of the concurrency limits. You can monitor the system regardless of the number of queries executing on it.
- And there are [opterations not governed by resource classes](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/resource-classes-for-workload-management#operations-not-governed-by-resource-classes){:target="_blank" rel="noopener"}
- Concurrency Slots
    - They are like tickets that you purchase to reserve seats at a concert because seating is limited. More slots means more resources for operations. 
    - Only resource governed queries consume concurrency slots. System queries and some trivial queries don't consume any slots. The exact number of concurrency slots consumed is determined by the query's resource class.
- RC Precedence: If an user is member of multiple RC: 
    - Dynamic takes precedence over static. Larger RC takes precedence over smaller. 
- Recommendations
    - Leverage workload management capabilities (isolation, classification, importance)
    - Data Load: Static RC if load is known, else dynamic 
    - Queries: Dynamic for complex-but-low-concurrency queries. Static RC when resource expectations vary throughout the day. When scaling DW, memory allocated to user doesnt changed. 
        - use dbo.prc_workload_management_by_DWU 

### Cache Management
- [Reference](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-result-set-caching){:target="_blank" rel="noopener"}
- Whats not cached (when turned ON for a DB)
    - Queries with built-in functions or runtime expressions that are non-deterministic even if there’s no change in base table data or query. E.g. DateTime.Now(), GetDate().
    - Queries using user defined functions
    - Queries using tables with row level security or column level security enabled
    - Queries returning data with row size larger than 64KB
    - Queries returning large data in size (>10GB)
        - The operations to create result set cache and retrieve data from the cache happen on the control node of a dedicated SQL pool instance. When result set caching is turned ON, running queries that return large result set (for example, >1GB) can cause high throttling on the control node and slow down the overall query response on the instance. To avoid stressing the control node and cause performance issue, users should turn OFF result set caching on the database before running such queries.
- Cache Results Management 
    - Max size of 1TB per DB. Cache results are automatically invalidate if underlying query data changes
    - Dedicated SQL Pool manages cache eviction automatically 
        - every 48hrs if result set hasnt been used or invalidated 
        - when result cache approaches max size (1TB per DB)
    - Cache eviction can be managed manually using 
        - Turn OFF result cache for DB 
        - Run DBCC DropResultCache. Pausing DB wont empty cached result set. 
- Setting Result Caching 
    - [For Database](https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-database-transact-sql-set-options?toc=%2Fazure%2Fsynapse-analytics%2Fsql-data-warehouse%2Ftoc.json&bc=%2Fazure%2Fsynapse-analytics%2Fsql-data-warehouse%2Fbreadcrumb%2Ftoc.json&view=azure-sqldw-latest){:target="_blank" rel="noopener"}: ALTER DATABASE <> SET RESULT_SET_CACHING ON|OFF
    - [For Session](https://docs.microsoft.com/en-us/sql/t-sql/statements/set-result-set-caching-transact-sql?toc=%2Fazure%2Fsynapse-analytics%2Fsql-data-warehouse%2Ftoc.json&bc=%2Fazure%2Fsynapse-analytics%2Fsql-data-warehouse%2Fbreadcrumb%2Ftoc.json&view=azure-sqldw-latest){:target="_blank" rel="noopener"}: SET RESULT SET CACHING ON|OFF
    - Check Cache Size: DBCC ShowResultCacheSpaceUsed 
    - Clean up Cache: DBCC DropResultSetCache 

### Manageability and Monitoring
- Scale, Pause, Resume 
    - On Pause
        - Compute and memory resources are returned to the pool of available resources in the data center
        - Data warehouse unit costs are zero for the duration of the pause.
        - Data storage is not affected and your data stays intact.
        - All running or queued operations are cancelled.
        - DMV counters are reset.
    - On resume 
        - The dedicated SQL pool (formerly SQL DW) acquires compute and memory resources for your data warehouse units setting.
        - Compute charges for your data warehouse units resume.
        - Your data becomes available.
        - After the dedicated SQL pool (formerly SQL DW) is online, you need to restart your workload queries.
    - Drain transactions before pausing or scaling 
        - SELECT queries will be cancelled. But transactional queries could trigger rollback the changes which could take time. 
- [Resource Monitoring](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-concept-resource-utilization-query-activity#resource-utilization){:target="_blank" rel="noopener"}: Azure Monitor 
- Query Monitoring: [DMVs](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/reference-tsql-system-views#dedicated-sql-pool-dynamic-management-views-dmvs){:target="_blank" rel="noopener"}, Log Analytics, Explain Plan ([EXPLAIN command](https://docs.microsoft.com/en-us/sql/t-sql/queries/explain-transact-sql?view=azure-sqldw-latest){:target="_blank" rel="noopener"})
- [Workload Monitoring](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-workload-management-portal-monitor){:target="_blank" rel="noopener"}


### What to Monitor 
1. System Level 

    1.1 Resource (e.g. DWU%, CPU%, DataIO%)

    1.2 Cache (e.g. Cache Hit vs Used%)

    1.3 Data Movement (e.g. TempDB%)

    1.4 Allocation (e.g. Workload Group Allocation)

    1.5 Wait (e.g. Active vs Queued Queries)

2. Application 

    2.1 20 longest queries by execution time (excluding batches)

    2.2 Most Rows Moved by Query 

    2.3 Rows processed per hour

    2.4 Longest BuildReplicatedTableCache

    2.5 Frequent BuildReplicatedTableCache


#### Interpretations 
- High TempDB 
    - Could be from high broadcast move or row processed by query step
    - Could indicate memory pressure, indicating spill to tempdb 
- High CPU: If its consisently high 
    - Could be queries with large row by row operations (e.g. CASE queries)
    - Consider setting a resource cap to workload group (adhoc e.g.)
- High IO 
    - Its averaged across nodes. So some nodes could be throttled but average could be showing OK. Fairly unlikely issue. 
- Adaptive Cache Usage 
    - >95% CacheHit, >95% CacheUsed: Caching is good, look elsewhere
    - <95% CacheHit, >95% CacheUsed: Queries running slow, but unrelated to cache. Can scale down to reduce cache size to reduce costs. 
    - >95% CacheHit, <95% CacheUsed: Workload cant fit into cache causing physical reads. Consider scaling up and rerun the workload. 
    - <95% CacheHit, <95% CacheUsed: Cold cache (rerun queries) or your working set is already residing in memory. 
- Queued Queries 
    - Its not the queueing, its whether critical queries are queued 
    - Use workload management to control what gets queued 
- High Query, Step Execution Time
    - if there's no particular step taking too long, look at stats, query text, hints etc.
    - if there's a particular step taking too long, check estimate plans to see where there's large amount of weight or row count
    - Rows Moved by Query Step 
        - ShuffleMove: not so bad
        - Broadcast: bad if for large number of rows.
    - Rows process by RequestID
        - Its not so much rows moved by an individual query step, but in some cases there are too many data movement operations when executed in same query. Consider opportunities for optimization at query level/ filtering
- BuildReplicatedTableCache
    - Execution Time: Beyond seconds or few minutes could mean table >2GB
    - Frequency: If recached >30 times a day, may not be good candidate for replicated, but if its accessed say thrice more, perhaps it isnt major issue. 


### Query Optimization
- Queries impacting System Performance 
    - Resource Contention 
        - Compute : Heavy query steps. CPU intensive ops. CASE. Type conversions. 
        - Memory : Large data moement
        - Data IO : Queued queries (could be because of other resources too)
        - TempDB : Large data movement. Large broadcast (bad) vs large shuffle.
    - Query Plan, Statistics, Transaction Management 
    - Data Volume and Fast Access
        - Filtered, narrow Select. Storage (Order / Segment, Indexing, Partition, Distribuion, Data movement), Raw storage location 
        - Locking and Blocking 
- Identify Query Execution Issues



### Best Practices - Review 
- [Serverless SQL pool best practices](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-serverless-sql-pool){:target="_blank" rel="noopener"} 
- [Dedicated SQL pool best practices](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-dedicated-sql-pool){:target="_blank" rel="noopener"} 
- [Capacity Limits.](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-service-capacity-limits?context=/azure/synapse-analytics/context/context){:target="_blank" rel="noopener"}

