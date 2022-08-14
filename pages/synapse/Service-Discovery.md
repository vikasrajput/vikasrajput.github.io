---
layout: page
title: Azure Synapse - Service Discovery  
---

Lets explore Azure Synapse Service and its various components.

- [Service Discovery](#service-discovery)
    - [Storage Account](#service-discovery)
    - [Serverless SQL Compute](#serverless-sql-compute)
    - [Dedicated SQL Pool](#dedicated-sql-pool)
    - [Spark Pools](#spark-pools)
    - [Data Explorer](#azure-data-explorer)
- [WAF Pillars](#waf-pillars)
    - [Security](#security)
    - [Cost Optimization](#cost-optimization) 
    - [Operations](#operations)
    - [Reliability](#reliability) 
    - [Performance Efficiency](#performance-efficiency)

# Service Discovery 
## Storage Account 
## Serverless SQL Compute 
## Dedicated SQL Pool 
- [Physical Architecture](https://saldeloera.files.wordpress.com/2012/07/full-rack.png){:target="_blank" rel="noopener"}
### Control Node 
### Compute Nodes 
- Compute to Distribution [relationship](https://blog.engineer-memo.com/wp-content/2020/09/image-36.png){:target="_blank" rel="noopener"}
### Distributions 
## Spark Pools 
## Azure Data Explorer 


<br><br>

# WAF Pillars 
## Security 
- [Security Guidance](https://docs.microsoft.com/en-us/azure/synapse-analytics/guidance/media/security-white-paper-overview/azure-synapse-security-layers.png)
    - [Data Protection](https://docs.microsoft.com/en-us/azure/synapse-analytics/guidance/security-white-paper-data-protection){:target="_blank" rel="noopener"} (encryption at rest and in transit)
    - [Access Control](https://docs.microsoft.com/en-us/azure/synapse-analytics/guidance/security-white-paper-access-control){:target="_blank" rel="noopener"}
        - Object level security 
        - Row level security (azure synapse and dedicated sql pool only)
        - Column level security (azure synapse and dedicated sql pool only)
        - Dynamic data masking (azure synapse and dedicated sql pool only) 
        - Synapse role-based access control 
    - [Authentication](https://docs.microsoft.com/en-us/azure/synapse-analytics/guidance/security-white-paper-authentication){:target="_blank" rel="noopener"}
    - [Network Security](https://docs.microsoft.com/en-us/azure/synapse-analytics/guidance/security-white-paper-network-security){:target="_blank" rel="noopener"}
    - [Threat Protection](https://docs.microsoft.com/en-us/azure/synapse-analytics/guidance/security-white-paper-threat-protection){:target="_blank" rel="noopener"}
### Monitor Users and Apps 
- Azure SQL Auditing
### Information Protection 
- Microsoft Defender for Cloud
- Encryption
- Identity 
- Networking 
    - Private Endpoint 

<br>

## Cost Optimization 
### Estimation 
### Monitor (consumption)
### Optimize (consumption)

<br>

## Operations
### Infra-as-Code 
### DevOps 
### Testing 

<br>

## Reliability 
### Failure Protection 
### DR 
### Monitoring for Failures 

<br>

## Performance Efficiency 
### Capacity Planning and Monitoring 
### Scalability 
### Automated Testing 
