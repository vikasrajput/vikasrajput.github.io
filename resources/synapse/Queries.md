-- Replicated table monitoring cache status 
SELECT ReplicatedTable = t.Name 
FROM sys.tables t 
JOIN sys.pdw_replicated_table_cache_state c 
ON c.object_id = t.object_id
JOIN sys.pdw_table_distribution_properties p 
ON p.object_id = t.object_id 
WHERE c.state = 'NotReady' 
AND p.distribution_policy_desc = 'REPLICATE'; 

