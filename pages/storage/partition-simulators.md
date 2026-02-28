---
layout: page
title: Azure Storage – Partition Strategy Simulators
---

<style>
  .sim-hub { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; }
  .sim-hub p.intro { color: #666; font-size: 14px; line-height: 1.6; margin-bottom: 24px; }
  .card-grid { display: grid; grid-template-columns: 1fr; gap: 20px; margin-bottom: 30px; }
  .card { background: #f8f9fa; border: 1px solid #e0e0e0; border-radius: 10px; padding: 24px; transition: box-shadow 0.2s, transform 0.2s; }
  .card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.1); transform: translateY(-2px); }
  .card h3 { margin: 0 0 8px 0; font-size: 20px; }
  .card h3 a { color: #4183C4; text-decoration: none; }
  .card h3 a:hover { text-decoration: underline; }
  .card .desc { color: #555; font-size: 13px; line-height: 1.5; margin-bottom: 12px; }
  .card .features { list-style: none; padding: 0; margin: 0 0 14px 0; }
  .card .features li { font-size: 12px; color: #444; padding: 3px 0; }
  .card .features li::before { content: "✓ "; color: #28a745; font-weight: bold; }
  .card .complexity { display: inline-block; font-size: 11px; padding: 3px 10px; border-radius: 12px; font-weight: 600; }
  .card .complexity.high { background: #d4edda; color: #155724; }
  .card .complexity.medium { background: #fff3cd; color: #856404; }
  .card .complexity.low { background: #d1ecf1; color: #0c5460; }
  .link-btn { display: inline-block; background: #4183C4; color: #fff; padding: 8px 20px; border-radius: 5px; text-decoration: none; font-size: 13px; font-weight: 600; }
  .link-btn:hover { background: #3572a5; color: #fff; text-decoration: none; }
  .concept-box { background: #f0f7ff; border: 1px solid #b8d4f0; border-radius: 8px; padding: 16px 20px; margin-bottom: 24px; font-size: 13px; color: #333; line-height: 1.6; }
  .concept-box h4 { margin: 0 0 8px 0; color: #222; }
</style>

<div class="sim-hub">



  <div class="concept-box">
    <h4>Why Partitioning Matters</h4>
    Azure Storage distributes data across <strong>partition servers</strong> to scale horizontally. Each partition server 
    has throughput limits. If your data or access patterns concentrate on a single partition ("hot partition"), 
    you hit throttling — even if the overall storage account has capacity. The key to high performance is 
    <strong>spreading load evenly across partitions</strong>.
  </div>

  <div class="card-grid">

    <div class="card">
      <h3>🗃️ <a href="{{ site.baseurl }}/pages/storage/table-partition-simulator">Table Storage</a></h3>
      <p class="desc">
        Table Storage gives you <strong>explicit control</strong> over the PartitionKey — making it the most impactful 
        design decision. Simulate date-based, category-based, unique, composite, and hash-bucket strategies.
      </p>
      <ul class="features">
        <li>Visualize entity distribution across partitions</li>
        <li>Detect hot partitions exceeding 2,000 ops/sec</li>
        <li>Compare 6 different PartitionKey strategies</li>
        <li>Factor in query patterns and data skew</li>
      </ul>
      <span class="complexity high">User Control: High</span>
      &nbsp;
      <a href="{{ site.baseurl }}/pages/storage/table-partition-simulator" class="link-btn">Open Simulator →</a>
    </div>

    <div class="card">
      <h3>📦 <a href="{{ site.baseurl }}/pages/storage/blob-partition-simulator">Blob Storage</a></h3>
      <p class="desc">
        Blob partitioning is driven by <strong>naming patterns</strong>. Sequential names are the #1 anti-pattern. 
        Simulate how different naming conventions (hash-prefix, GUID, timestamp) affect partition distribution.
      </p>
      <ul class="features">
        <li>Compare 6 blob naming conventions</li>
        <li>Visualize partition server distribution</li>
        <li>Detect hot-spot risk from sequential names</li>
        <li>Model container strategies and access patterns</li>
      </ul>
      <span class="complexity medium">User Control: Medium</span>
      &nbsp;
      <a href="{{ site.baseurl }}/pages/storage/blob-partition-simulator" class="link-btn">Open Simulator →</a>
    </div>

    <div class="card">
      <h3>📁 <a href="{{ site.baseurl }}/pages/storage/files-partition-simulator">Azure Files</a></h3>
      <p class="desc">
        Azure Files performance is driven by <strong>share size, tier, and protocol</strong> rather than naming. 
        Simulate IOPS, throughput, and capacity against provisioned limits across shares.
      </p>
      <ul class="features">
        <li>Model Premium, Hot, and Cool tier limits</li>
        <li>Visualize IOPS and throughput gauges per share</li>
        <li>Plan multi-share distribution strategies</li>
        <li>SMB multichannel and NFS recommendations</li>
      </ul>
      <span class="complexity low">User Control: Low</span>
      &nbsp;
      <a href="{{ site.baseurl }}/pages/storage/files-partition-simulator" class="link-btn">Open Simulator →</a>
    </div>

  </div>

  <div class="concept-box">
    <h4>Quick Decision Guide</h4>
    <table style="width:100%;font-size:13px;border-collapse:collapse;">
      <thead><tr style="border-bottom:2px solid #4183C4;">
        <th style="padding:6px;text-align:left;">If you need…</th>
        <th style="padding:6px;text-align:left;">Start with…</th>
      </tr></thead>
      <tbody>
        <tr style="border-bottom:1px solid #ddd;"><td style="padding:6px;">High-throughput structured data, batch operations</td><td style="padding:6px;"><strong>Table Storage</strong> simulator — PartitionKey design is critical</td></tr>
        <tr style="border-bottom:1px solid #ddd;"><td style="padding:6px;">Large-scale blob ingestion (IoT, logs, media)</td><td style="padding:6px;"><strong>Blob Storage</strong> simulator — naming pattern determines scale</td></tr>
        <tr><td style="padding:6px;">Shared file system (SMB/NFS lift-and-shift)</td><td style="padding:6px;"><strong>Azure Files</strong> simulator — tier and share sizing are key</td></tr>
      </tbody>
    </table>
  </div>

</div>
