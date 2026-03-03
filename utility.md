---
layout: page
title: Utilities
permalink: /utility/
---

## [Azure Storage – Partition Strategy Simulator](https://vikasrajput.github.io/storage-simulator/simulators/)
Storage throttling is the silent killer of cloud applications — it only surfaces at production scale, and the fix is a schema redesign (the most expensive kind of change). Am sharing **zero-install browser simulators** here which let you visualize partition behaviour and detect hot-spots *before* you deploy. No Azure account needed, no costs involved, no hit and trial.

| Simulator | What It Answers |
|-----------|----------------|
| **[Blob Storage](https://vikasrajput.github.io/storage-simulator/simulators/blob-partition-simulator.html)** | Will my blob naming pattern create a hot partition server? Compares 6 naming strategies, visualizes partition spread. |
| **[Table Storage](https://vikasrajput.github.io/storage-simulator/simulators/table-partition-simulator.html)** | Will my PartitionKey bottleneck under load? Simulates 6 key strategies, flags partitions exceeding 2,000 ops/sec. |
| **[Azure Files](https://vikasrajput.github.io/storage-simulator/simulators/files-partition-simulator.html)** | Is my file share sized correctly? Models IOPS, throughput, and capacity against tier limits with visual gauges. |


## [Field Maps]({% link pages/fieldmap/fieldmaps.md %}) 
Field Maps is a quick and easy way to map Foundational topics (features in a data tech/service) and as Well Architected Framework (aka.ms/waf) pillar features.  
<br><br>

