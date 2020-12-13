# AZ-303 (Azure Architect - Technologies) Certification Notes 
If you are preparing for AZ-303 cert, below are some reference points: 
- [Guidance Page](https://docs.microsoft.com/en-us/learn/certifications/exams/az-303)
- [Microsoft Learning Path](https://docs.microsoft.com/en-us/learn/browse/?roles=solution-architect&products=azure&resource_type=learning%20path)

An expanded and suggested list of resources are below: 
- Assets 
    - Compute
        - [VM](https://vikasrajput.github.io/blog/architecture/labs/lab-azure-compute-vm.sh), 
            [VM Scale Sets](https://vikasrajput.github.io/blog/architecture/labs/lab-azure-compute-vmss.sh), 
            [Batch](https://vikasrajput.github.io/blog/architecture/labs/lab-azure-compute-batch.sh)
        - Functions, Container Instance, AKS
    - Storage  
        - File Share, Queue, Disk Storage 
        - Archive, Backup, ADLS 
    - Networking ([Ref](https://docs.microsoft.com/en-us/azure/architecture/guide/technology-choices/load-balancing-overview))
        - VNet,
            VNet Peering, 
            NSG, 
            ASG  
        - [Azure Load Balancer](https://vikasrajput.github.io/blog/architecture/labs/lab-azure-network-loadbalancer.sh), 
            Traffic Manager, 
            [Application Gateway](https://vikasrajput.github.io/blog/architecture/labs/lab-azure-network-applicationgateway.sh), 
            Azure Front Door, 
        - [Firewall](https://vikasrajput.github.io/blog/architecture/labs/lab-azure-network-firewall.sh) - Incomplete Lab!, 
            Web Application Firewall, 
            VPN Gateway, 
            Azure Bastion 
    - Security  
        - AAD, SSO and MFA, Identity Protection, AD Connect 
        - 
        - NSG, DDoS, Key Vault, AIP 
- Manage
    - Governance  
        - RBAC, Azure Lock, Azure Policy
        - Azure Advisor, Automation, ARM Template 
        - Network Watcher, Traffic Manager
    - Monitoring
        - Azure Monitor, ASH, ASC
        - App Insight, Log Analytics 
    - Migration 
        - DB Migration Service, Azure Migrate, ASR
- Applications 
    - Data 
        - SQL DB, Synapse, Cosmos
        - SQL Edge, SQL on VM
    - Apps 
        - App Service, WebApps, API, API Management 
        - CDN, Web App for Containers, Static WebApp



Modules 
1. Azure Active Directory 
    - AD Connect Health 
        - [Pass Through Auth](https://docs.microsoft.com/en-us/azure/active-directory/connect/media/active-directory-aadconnect-pass-through-authentication/pta2.png)
        - [Password Hash Sync](https://wintellisys.com/wp-content/uploads/2020/07/Doc-1-Password-Hash-1024x458.png)
        - [Federation](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/whatis-fed)
        - [When to use what](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/whatis-hybrid-identity#common-scenarios-and-recommendations)
    - Blade Map
        - Users, Groups, Devices, App Registration 
        - Azure AD Connect, Custom Domain, Password Reset
        - Identity Governance (P2)
            - Entitlement Management, Access Review, PIM
        - Security 
            - Identity Protection (P2)
            - Conditional Access, MFA (P1)
            - Named Location, Authentication Methods (policy)
2. Hybrid Identities
3. Virtual Networking 
4. VMs (windows, linux)
5. Storage Accounts
6. Load Balancing and Security 
7. Azure NoSQL Databases 
8. Azure SQL Databases
9. Automated deployment 
10. Azure Migration 
11. Monitoring 
12. Azure Governance 
    - Roles
        - [Classic Roles: Account Admin, Service Admin, Co-Admin](https://docs.microsoft.com/en-us/azure/role-based-access-control/rbac-and-directory-admin-roles#classic-subscription-administrator-roles)
            - no portal access for account admin. service admin has full access
        - [Azure Roles: Owner, Contributor, Reader, User Access Admin](https://docs.microsoft.com/en-us/azure/role-based-access-control/rbac-and-directory-admin-roles#azure-roles)
        - [Azure AD Roles: Global, User, Billing Admin](https://docs.microsoft.com/en-us/azure/role-based-access-control/rbac-and-directory-admin-roles#azure-ad-roles)
        - [Azure vs Azure AD Roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/rbac-and-directory-admin-roles#differences-between-azure-roles-and-azure-ad-roles)
            - Overlap: "Access Management for Azure Resources switch (global admin becomes user access admin)
    - Access Review (within Identity Governance)
        - Options: Azure AD Access Review for Security Group review, Azure AD Enterprise Apps for connected apps, and Azure AD PIM for Azure AD or Azure Resource roles
    - Azure Policy 
        - vs RBAC: Policy is default allow and explicit deny system. Policy focuses on properties during the deployment, RBAC focuses on user actions at different scopes. 
        - Policy Creation: 1. define policy 2. assign defn to scope of resource 3. view policy evaluation results 
        - Authoring:
            - Definition: Policy/Initiative/Export. 
            - Assignment: Policy/Initiative
            - Exemptions: (new feature)
        - Other Tabs: Compliance (report), Remediation
    - Blueprints 
        - Process: Create blueprint. assign blueprint. track assignment 
        - declarative. orchestrate deployment of role assignments, policy assignments, arm templates, resource groups 
        - vs ARM Templates: ARM templates doesnt "live" in azure, whilst with blueprint definition and assignment relationship is preserved. 
        - initiative (plus category definition) -> groups -> policies (initiative and policy parameters)
13. Security for Applications
    - Managed identity: combines Azure AD auth and RBAC 
14. Application Infrastructure 
15. Container based Applications 
