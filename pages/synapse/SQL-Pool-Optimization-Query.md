---
layout: page
title: Azure Synapse - Optimize SQL Pools - Query Optimization
---
How to optimize performance with dedicated sql pool?

- [Optimize Queries](#optimize-queries) 
    - [Transactions](#transactions) 
    - [Execution Plan](#execution-plan)
    - [Statistics](#statistics)
    - [Data Load](#data-loading) 
    - [Data Movement](#data-movement) 
    - Execution Plan 


<br><br>

## OPTIMIZE QUERIES 
### Transactions 
- [Transactions in Dedicated SQL Pool](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-transactions){:target="_blank" rel="noopener"}
    - Isolation levels
        - Default: READ UNCOMMITTED.  
        - Can be changed to READ COMMITTED SNAPSHOT ISOLATION at DB level, but then cant use READ UNCOMMITTED at session level
    - Transaction size 
        - varies with DWU capacity 
        - ceilings are presumed when data is evenly distributed with HASH or ROUND_ROBIN. If data is skewed, limits will be reached earlier 
    - Trasaction state : XACT_STATE() returned with value -2
    - Limitations 
        - No distributed transactions
        - No nested transactions permitted
        - No save points allowed
        - No named transactions
        - No marked transactions
        - No support for DDL such as CREATE TABLE inside a user-defined transaction
    - THROW, RAISERROR 
        - THROW is the more modern implementation for raising exceptions in dedicated SQL pool but RAISERROR is also supported
        - THROW: 100K-150K. RAISERROR: 50K 
        - Use of sys.messages not supported 
- [Transaction Optimization Best Practices](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-transaction-best-practices){:target="_blank" rel="noopener"}
    - Transactions and logging 
        - Each distribution has its own transaction log, log writes are automatic but can be made efficient with good code 
            - use minimal logging where possible 
            - process data as scoped batch instead of individual transactions 
            - adopt partition switching patter for large updates
        - Min vs Full logging 
            - minimal logging involves logging only the informati   on that is required to roll back the transaction after a failure, or for an explicit request (ROLLBACK TRAN). Since minimally logged operations can participate in explicit transactions, they can be rolled back as well. 
                - CREATE INDEX, ALTER INDEX REBUILD, DROP INDEX, TRUNCATE TABLE, DROP TABLE, ALTER TABLE SWITCH PARTITION
                - CREATE TABLE AS SELECT (CTAS), INSERT..SELECT (they both are bulk load options)
                    - Any writes to update CI or NCI will always be fully logged operation
                    - When loading to non-empty, CI table, operation is mix of full logged if writing to non empty page, and min logged if writing to empty page.  
                - Internal data movement operations (such as BROADCAST and SHUFFLE) are not affected by the transaction safety limit
            - Optimize for [DELETE](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-transaction-best-practices#optimize-deletes){:target="_blank" rel="noopener"} and [UPDATE](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-transaction-best-practices#optimize-updates){:target="_blank" rel="noopener"} using mil-logged options, or use [Partition Switching](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/eddevelop-transaction-best-practices#optimize-with-partition-switching){:target="_blank" rel="noopener"}. Another option is to use smaller batch. 
        - Pause, Scaling 
            - When you pause or scale your dedicated SQL pool, it is important to understand that any in-flight transactions are terminated immediately; causing any open transactions to be rolled back.
- Key Call out's
    - [Dynamic SQL](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-dynamic-sql){:target="_blank" rel="noopener"} 
        - Synapse doesnt support blob data type, meaning very large strings cant stored in memory. You need to break the code into chunks and use the EXEC statement instead.
    - [GROUP BY](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-group-by-options){:target="_blank" rel="noopener"} 
        - Limited support by dedicated SQL Pool, and not supported by serverless sql pool

### Execution Plan 
- MPP Plan (D-SQL)
- SMP Plan 


### Statistics
#### Stats in dedicated SQL Pool 
- [REF](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics){:target="_blank"}
- Auto creation of stats 
- Update stats 
- Last stats update 
- Managing Stats
    - USP to create stats on all columns in a Database  
    - Stats Metadata 
        - Catalog Views 
        - System Functions 
        - DBCC SHOW_STATISTICS()
#### Stats in serverless SQL Pool 
- Auto creation of stats 
- Manual creation of stats 
- Update stats 
- Managing stats 
    - Stats Metadata 
        - Catalog Views 
        - System Functions 


### Data Loading 
- [Best Practices](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/data-loading-best-practices?toc=/azure/synapse-analytics/sql-data-warehouse/toc.json){:target="_blank" rel="noopener"}
	- Prepare data in Azure Storage
	- Run loads with enough compute <!-- How to estimate your compute efficiency?  -->
	- Allow multiple users to load (DENY CONTROL across different schemas)
	- Load to a staging table
	- Load to a columnstore index
	- Increase batch size when using SQLBulkCopy API or BCP
	- Manage loading failures
	- Insert data into a production table
	- Create statistics after the load
	- Rotate storage keys
- Delta Lake integration is a key ask which can be referenced [here](https://www.jamesserra.com/archive/2022/03/azure-synapse-and-delta-lake/){:target="_blank" rel="noopener"}

### Data Movement
- [Shuffle_Move](https://blog.engineer-memo.com/wp-content/2020/09/image-42.png){:target="_blank" rel="noopener"}, and [this](https://www.purplefrogsystems.com/blog/2021/03/azure-synapse-series-hash-distribution-and-shuffle/){:target="_blank" rel="noopener"}, and [another example](https://community.microstrategy.com/s/article/Best-practices-for-performance-tuning-based-on-Azure-Synapse-Analytics?language=en_US){:target="_blank" rel="noopener"}, and [this]
- [Broadcast_Move](https://blog.engineer-memo.com/wp-content/2020/09/image-38.png){:target="_blank" rel="noopener"}, and [this](https://stackoverflow.com/questions/68082666/why-synapse-analytics-chooses-a-much-bigger-table-to-broadcast-when-joining){:target="_blank" rel="noopener"}
- ReturnOperation: ReturnOperation is the process of getting results at each Compute Node based on redistribution data.
- Distribute_Replicated_Table_Move 
- Master_Table_Move 
- Partition_Move 
- Trim_Move 

