---
layout: page
title: Azure Synapse - Optimize SQL Pools - Design  
---
How to optimize performance with dedicated sql pool?

- [Optimize Design](#design-for-performance) 
    - [Table](#tables)
        - [Distributed Tables](#distributed-tables) 
        - [Replicated Tables](#replicated-table) 
        - [Partitions](#partitions) 
        - [Indexes](#indexes) 
        - [Temp Tables](#temporary-tables) 
        - [External Tables](#external-tables) 
        - [Statistics](#statistics)
    - [Materialized Views](#materialized-views)

<br><br>

## DESIGN FOR PERFORMANCE 
- [Core Platform Flow and Components](https://mrpaulandrew.files.wordpress.com/2021/05/synapse-logical-architecture-v1-1.png){:target="_blank" rel="noopener}
- [Synapse SQL Architecture](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/media/overview-architecture/sql-architecture.png){:target="_blank" rel="noopener}
- [Synapse Network Architecture](https://mrpaulandrew.files.wordpress.com/2021/06/azure-synapse-physical-architecture-v1.jpg){:target="_blank" rel="noopener}


### Tables 
#### (Hash) Distributed Tables 
- [Distributed Table Guidance](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute?context=/azure/synapse-analytics/context/context){:target="_blank" rel="noopener}
- Table size >2GB. Suited with frequent Insert, Update, Delete. 
- Choose a distribution column that 
    - minimize data movement (used in JOIN, GROUP BY, DISTINCT, OVER, HAVING. Not in WHERE, or Date. Exact datatype)
    - minimize data skew (across distributions, think cardinality, no NULLS or few atleast, not a date column)
        - minimum 60*10 distinct values. UniqueIDs arent great distribution keys 
    - maximizes balanced execution (query design, using distributed nodes and distributions. WHERE on HASH key will cause unbalanced exec.)
- Check Data Skew (DBCC PDW_SHOWSPACEUSED, [vTableSizes](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-overview#table-size-queries){:target="_blank" rel="noopener}), check query plan for data movement
- Resolve a distribution column problem (sometimes by recreating table as temp table with different distribution - for large queries)
- [Limitation of using IDENTITY Column with Dedicated Tables](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-identity#limitations){:target="_blank" rel="noopener}

### Round Robin Tables 
- Each table is divided evenly across 60 distributions. Data distributed in round robin fashion across the distributions.
- Each distribution holds unique data, and can be partitioned – each distribution has it’s own partitioned table.
- Good for data loading, or when there's no  good distribution key or static data tables (larger than replicate capacity)
- Will always incur data movement, except when JOIN with REPLICATE or single table SELECT
- Note that Data Skew is not a challenge with Round Robin tables 


#### Replicated Table 
- [Guidance](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/design-guidance-for-replicated-tables){:target="_blank" rel="noopener}
- Initially stored as round robin, with complete table cached to each compute node (and on first distribution of the node)
- Modifications to table (DML, DDL) or database scaling invalidates cached replicate table. Can be partitioned. 
- Table size <2GB. Check for BroadcastMoveOperation in sys.dm_pdw_request_steps to find where replicated table should be created. 
- Dont use if 
    - there's frequent data / table changes 
    - there's frequent scaling leading to replicate tables rebuild
    - table has large number of columns - in such case instead create index on frequently used columns
- Use them where you have simple predicates e.g equality, inequality. For complex predicates (e.g. LIKE) use distributed. 
- Not rebuilt after PAUSE RESUME operation. Use indexes atop of replicated tables sparingly.  
- Re-cache triggered by the first query that accesses the table (SELECT TOP 1 * FROM TableName)
    - Cache / re-cache is a-synchronous
    - Monitoring Caching state: sys.pdw_replicated_table_cache_state 



#### Partitions
- [Reference](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-partition){:target="_blank" rel="noopener"}  
- Row vs Column Store
- Mostly paritioned on date column 
- Benefits 
    - Data Loads 
        - Avoidance of transaction logging. Partition Switching. Drop partition instead of DELETE. 
    - Queries 
        - Avoids a full table scan and only scan a smaller subset of data when filtering
- Parition Sizing 
    - A table with too many paritions can hurt performance. A successful partitioning scheme usually has tens to hundreds of partitions, not thousands.
    - For clustered columnstore tables, have min 1mil rows per partition (that is beyond a table distributed amongst 60 distributed databases)
    - Any partitioning added to a table is in addition to the distributions created behind the scenes. If a table contains fewer than the recommended minimum number of rows per partition, consider using fewer partitions in order to increase the number of rows per partition.
- [DBCC PDW_SHOWPARTITIONSTATS](https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-pdw-showpartitionstats-transact-sql?view=aps-pdw-2016-au7){:target="_blank" rel="noopener"} 
- Core Tech References 
    - [Column store partitioning in SQL Server](https://www.red-gate.com/simple-talk/wp-content/uploads/2019/07/loading-into-a-clustered-columnstore-index.gif){:target="_blank" rel="noopener"} 
    - [SQL Server Partition Switching](https://docs.microsoft.com/en-us/archive/msdn-magazine/2014/october/sql-server-implement-large-fast-updatable-tables-for-responsive-real-time-reporting){:target="_blank" rel="noopener"}, and [another great, foundation article from Gail on this topic](https://www.red-gate.com/simple-talk/databases/sql-server/database-administration-sql-server/gail-shaws-sql-server-howlers/){:target="_blank" rel="noopener"} 


#### Indexes
- [Reference](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-ordered-cci){:target="_blank"} 
- Indexes - and their impact on storage, retrieval and write / update operations
<br><br>
- [Big Picture and Index Design Guide](https://docs.microsoft.com/en-us/sql/relational-databases/sql-server-index-design-guide){:target="_blank"}
    - Rowstore (SQL)
        - [Heap](https://www.sqlshack.com/wp-content/uploads/2019/06/basic-heap-storage-structure.png){:target="_blank"} 
        - [Clustered Index](https://www.sqlshack.com/wp-content/uploads/2019/06/basic-clustered-index-binary-tree-b-tree-storage-1.png){:target="_blank"} 
        - [Non-Clustered Index](https://www.sqlshack.com/wp-content/uploads/2020/01/non-clustered-index-in-sql-server01.png){:target="_blank"}, [ref](https://www.sqlshack.com/overview-of-non-clustered-indexes-in-sql-server/){:target="_blank"}
            - If it has CI, leaf node points to the clustered index data page containing actual data
            - If its a Heap, leaf node points to the heap page
            - [Covering Index / Included columns](https://www.sqlshack.com/wp-content/uploads/2020/01/sql-server-clustered-index.png){:target="_blank"}
        - Unique 
        - Filtered 
    - Columnstore (SQL, Synapse)
        - Considerations 
            - Rowgroup: 1mil rows. Column Segment. Columnstore (compression) and Deltastore
        - [Clustered Columnstore Index](https://docs.microsoft.com/en-us/sql/relational-databases/indexes/media/sql-server-pdw-columnstore-load-process.png){:target="_blank"}
        - Nonclustered Columnstore 
    - Others 
        - [XML Indexes](https://docs.microsoft.com/en-us/sql/relational-databases/xml/xml-indexes-sql-server?view=sql-server-ver15){:target="_blank"}, [Spatial Indexes](https://docs.microsoft.com/en-us/sql/relational-databases/spatial/spatial-indexes-overview?view=sql-server-ver15){:target="_blank"}, Full Text Indexes
- Indexes ([CI](https://tsmatz.files.wordpress.com/2020/10/20201020_rowstate_clustered2.jpg){:target="_blank"}, [NCI](https://tsmatz.files.wordpress.com/2020/10/20201020_rowstate_nonclustered.jpg){:target="_blank"})
    - Better suited for search or predicate based row lookup. Columnstore are suited for narrow, deep, whole of column data access patterns. 
    - CI can benefit when specific columns are filtered on. Combine them with NCI to improve filter on other columns. 
<br<br>
- Clustered Columnstore indexes 
    - By default, dedicated SQL pool creates a clustered columnstore index when no index options are specified on a table. Clustered columnstore tables offer both the highest level of data compression and the best overall query performance, generally outperforming clustered index. They are useful except when 
        - you have n/varchar(max) or varbinary(max) datatypes
        - less efficient for transient data and/or when having less thank 60mil rows. 
    - Optimize for Performance 
        - Compress is optimal when rows >60mil. For less than 60mil rows, use Heaps 
        - Check segment quality ([vColumnstoreDensity](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-index#optimizing-clustered-columnstore-indexes){:target="_blank" rel="noopener"}). Optimal rowgroup compression when rows >100K (max can be 1mil). Common reasons for [poor index segment](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-index#causes-of-poor-columnstore-index-quality){:target="_blank" rel="noopener"} quality: 
            - memory pressure when rebuidling index 
            - high DML operations volume 
            - small or trickle load operations 
            - too many partitions 
    - Resolve segmentation issue by rebuidling index, including CCI. 
    - Impact of Index Maintenance: check vColumnstoreDensity.Rebuild_Index_SQL. Use ALTER INDEX REBUILD to resort data using tempdb. Use ALTER INDEX REORGANIZE to go without re-sorted data. Ensure you allocate enough memory to index rebuild session
        - Rebuild index to improve segment quality (using elevated resource class)
        - Rebuild index with CTAS, Parititon Switching 
    - Performance Tuning with Ordered CCI 
        - CCI vs Ordered CCI 
            - CCI by default doesnt order the segment before compression, so segments with overlapping value ranges could cause queries to read more segments 
            - With ordered CCI, data is sorted within batch, and not global sorting. If you think data has changed considerably, trigger REBUILD ordered CCI. 
                - In dedicate SQL Pool, columnstore REBUILD is offline operation 
                - If table is partition, REBUILD is one partition at a time 
        - Query Performance, depends on
            - query patterns, 
            - size of data, 
            - data sorting & physical structure of segments, and 
            - DWU and resource class chosen for the query execution
        - Data Load Performance of ordered CCI is similar to paritions  
            - Loading data to ordered CCI could be slower than CCI, but retrieval is faster 
        - Reducing Segment Overlap
            - Depends on 
                - size of data to sort 
                - available memory, 
                - MAXDOP  
            - Options to reduce segment overlap 
                - use xlargec with higher DWU 
                - create ordered CCI with MAXDOP = 1. Using parallel threads will reduce time but will lead to higher overlapping segments
        - Creating ordered CCI on large tables 
            - ordered CCI creation is offline operation, for table no partition - table will be accessible to users after the job is completed 
            - consider partitioning with large tables 


#### Temporary Tables
- [Reference](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-temporary){:target="_blank" rel="noopener"}
- Dedicated SQL Pool 
    - Temp Tables are created on local SSD 
    - In comparison to SQL Server, Dedicated SQL Pool allows you to use temp table outside the USP which created it. They can be used **anywhere** in the user session. But remember the dependency created. 
        - Only session scoped temporary tables are supported. Global Temporary Tables aren't supported.
        - Views can't be created on temporary tables.
        - Temporary tables can only be created with hash or round robin distribution. Replicated temporary table distribution isn't supported.
    - Consider creating / testing performance impact of stats (not auto created on temp tables)
- Serverless SQL Pool 
    - Limited scope and usage. 
    - Cant be joined with Data from files. Limited to 100 in count and total size less than 100MB 
- [OPENROWSET Function](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-openrowset){:target="_blank" rel="noopener} - supports [Delta Lake access](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-delta-lake-format){:target="_blank" rel="noopener} 

#### External Tables
- [Reference](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-external-tables?tabs=hadoop){:target="_blank" rel="noopener"} 
- Uses: data source, format of files, table definition

#### Statistics
- [Reference](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics){:target="_blank" rel="noopener"}
- Dedicated SQL Pool 
    - AUTO_CREATE_STATISTICS set to ON (default) - not triggered automatically on External or Temp tables 
    - Can be created on one, specific, or all columns in a table 
    - Auto creation triggred by SELECT, INSERT-SELECT, CTAS, UPDATE, DELETE, EXPLAIN 
    - Update Stats: Daily on Date columns. Sparingly on say Country column (if they hardly get new country added)
        - Sampling: <1bil rows uses 20% sampling. >1bil rows uses 2% sample. 
        - [Determin last Stats Update](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics#determine-last-statistics-update){:target="_blank" rel="noopener"}
        - [Implement Stats Management](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics#implement-statistics-management){:target="_blank" rel="noopener"}
            - Focus on columns participating in JOIN, GROUP BY, ORDER BY, and DISTINCT clauses.
    - DBCC SHOW_STATISTICS () WITH state_header, histogram, density_vector. Its different to DBCC SHOW_STATS in SQL Server ([ref](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics#dbcc-show_statistics-differences){:target="_blank" rel="noopener"})
- [Serverless SQL Pool](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics#statistics-in-serverless-sql-pool){:target="_blank" rel="noopener"} 
    - SELECT triggers stats creation for missing stats. Enabled by default for Parquet files, you need to enable to CSV files
    - Automatic creation of statistics is done synchronously so you may incur slightly degraded query performance if your columns are missing statistics 
    - Serverless pool recreates stats if data is changed considerable. Older stats are deleted and then recreated. 
    - Manual stats are never declared stale! They can be created for single columns only at the moment (e.g. using OPENROWSET). 
    - Stats Metadata: ref STATS_DATE() or use catalog views (sys.stats, sys.stats_columns etc.)

### Views
- SQL Server 
    - Are ‘compiled’ objects
    - Tied to the referenced tables / views
- SQL Pool 
    - Are conceptualized as defined subqueries
    - Are not compiled and tied to the referenced tables / views
    - SQL Pool Views are fully expanded by the MPP Query optimizer when creating the distributed query plan
    - Can create a complex view, with large number of columns - an **Omnibus** View
- Should be 
    - Narrow (less columns, avoid omnibus)
    - Abstract to avoid load table complexity (referenced tables can be recreated or replaced without invalidating view)



### Materialized Views
- [Reference](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/performance-tuning-materialized-views){:target="_blank" rel="noopener"}
- Common Scenarios 
    - Need faster performance with no or minimum query changes
        - eliminate run time data movement (do once and contain)
        - contained aggregation in the query (e.g. MAX, MIN, AVG, SUM, COUNT etc)
    - Need different data distribution strategy for faster query performance (including different distribution key) - cant reference another view thought (standard or materialized)
    - Can be Hash or Round robin distributed, auto refreshed (with base table updates) 
- Design Guidance 
    - Design for your workload
    - Faster query vs cost (of storage and auto refresh for table UPDATE)
    - Not all performance tuning requires query change (sql optimizer automatically decides to use MatViews where appropriate)
    - Can be created on partitioned tables (support SPLIT/MERGE, but not SWITCH)
    - Monitor materialized views (DBCC PDW_ShowMaterializedViewOverhead)
    - Materialized view and result set caching
    - Check for MatView Overhead 
        - DBCC_ShowMaterializedViewOverhead (base_view_rows, total_rows, overhead_ratio)
        - After rebuilding a materialized view, all tracking rows for incremental data changes are eliminated and the view overhead ratio is reduced


