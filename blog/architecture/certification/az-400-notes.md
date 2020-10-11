# AZ-400 (Azure DevOps Expert) Certification Notes 
If you are preparing for AZ-400 cert, below are some reference points: 
- [Guidance Page](https://docs.microsoft.com/en-us/learn/certifications/exams/az-400)
- [Microsoft Learning Path](https://docs.microsoft.com/en-us/learn/browse/?roles=devops-engineer&products=azure%2Cgithub&resource_type=learning%20path)
- [DevOps Labs](https://azuredevopslabs.com/)
- [DevOps Labs - Github](https://github.com/microsoft/azuredevopslabs)
- [Labs Prerequisite Setup](https://www.azuredevopslabs.com/labs/azuredevops/prereq/)

## Workflow 
### 1. Overview, Boards, Repos 
- Labs 
    - Module 01: [Agile Planning and Portfolio Management with Azure Boards](https://www.azuredevopslabs.com/labs/azuredevops/agile/)
    - Module 02,03: [Version Controlling with Git in Visual Studio Code and Azure DevOps](https://www.azuredevopslabs.com/labs/azuredevops/git/)
    - Module 19 (optional): [Integration between Azure DevOps and Teams](https://azuredevopslabs.com/labs/vsts/teams)
- Ref
    - [Demo: Local Git](https://vikasrajput.github.io/blog/architecture/labs/lab-git-local.sh)
	- [Agile Manifesto](https://www.agilealliance.org/agile101/the-agile-manifesto/)
	- [State of DevOps by Puppet](https://puppet.com/resources/report/state-of-devops-report)
	- [Git Branching Models](https://nvie.com/posts/a-successful-git-branching-model/)

### 2. Pipelines - CI/CD 
- Labs 
    - Module 05: [Enabling Continuous Integration with Azure Pipelines](https://www.azuredevopslabs.com/labs/azuredevops/continuousintegration/), 
	[Integrate Your GitHub Projects With Azure Pipelines](https://www.azuredevopslabs.com/labs/azuredevops/github-integration/)
    - Module 14: [Azure Deployments using Resource Manager templates](http://microsoft.github.io/PartsUnlimited/iac/200.2x-IaC-AZ-400T05AppInfra.html)
    - Module 17 (optional): 
	[Terraform](https://azuredevopslabs.com/labs/vstsextend/terraform/), 
	[Chef](http://microsoft.github.io/PartsUnlimitedMRP/iac/200.2x-IaC-DeployappwithChefonAzure.html), 
	[Puppet](http://microsoft.github.io/PartsUnlimitedMRP/iac/200.2x-IaC-DeployappwithPuppetonAzure.html), 
	[Ansible](http://microsoft.github.io/PartsUnlimitedMRP/iac/200.2x-IaC-AnsiblewithAzure.html)
- Ref
	- [Putting it all together](https://www.edmondek.com/images/blue_green_azure_devops_app_service.png)

### 3. Release Management 
- Labs 
	- Module 10: N/A
	- Module 11: [Configuring CI/CD Pipelines as Code with YAML in Azure DevOps](https://www.azuredevopslabs.com/labs/azuredevops/yaml/),
	[Controlling Deployments using Release Gates](https://azuredevopslabs.com/labs/vstsextend/releasegates/), 
	[Using secrets from Azure Key Vault in a pipeline](https://www.azuredevopslabs.com/labs/vstsextend/azurekeyvault/)
	- Module 20: [Monitoring Application Performance with Application Insights](https://www.azuredevopslabs.com/labs/azuredevops/appinsights/),
	[Web Application Load and Performance Testing](https://www.azuredevopslabs.com/labs/azuredevops/load/)
- Ref
	- [Team Project Health](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.TeamProjectHealth)
	- [PostMan](https://www.postman.com/) 
	- [Feature Toggle](https://docs.microsoft.com/en-us/azure/devops/migrate/phase-features-with-feature-flags?view=azure-devops&viewFallbackFrom=vsts)
	- [Dashboards, Charts, Reports, Widgets](https://docs.microsoft.com/en-us/azure/devops/report/dashboards/overview?view=azure-devops&viewFallbackFrom=vsts)
	- Deployment Patterns: [Blue-Green](https://res.cloudinary.com/practicaldev/image/fetch/s--fJ4tYKdy--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https:/thepracticaldev.s3.amazonaws.com/i/78dk41w8qmuy9f9pvrf6.png), [Canary](https://res.cloudinary.com/practicaldev/image/fetch/s--7PmOiuG9--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https:/thepracticaldev.s3.amazonaws.com/i/zvf9rbd1x38umph98zro.png), [Progressive Exposure or Rolling](https://res.cloudinary.com/practicaldev/image/fetch/s--RbA0NHA6--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https:/thepracticaldev.s3.amazonaws.com/i/divuxihkun2p186c9mye.png)

### 4. Continuous Delivery 
- Labs 
	- Module 15: [Deploying a Dockerized Java app to Azure Web App for Containers](https://azuredevopslabs.com/labs/vstsextend/dockerjava/) 
	- Module 12: [Feature Flag Management with LaunchDarkly and AzureDevOps](https://www.azuredevopslabs.com/labs/vstsextend/launchdarkly/) 
	- Module 08: [Deploy existing .NET apps as Windows containers](https://www.azuredevopslabs.com/labs/vstsextend/aspnetmodernize/) 
	- Module 16: [Deploying a multi-container application to Azure Kubernetes Services](https://azuredevopslabs.com/labs/vstsextend/kubernetes/) 

### 5. Artifacts, Compliance 
- Labs 
	- Module 04: [Package Management with Azure Artifacts](https://www.azuredevopslabs.com/labs/azuredevops/packagemanagement/) 
	- Module 06: [Using secrets from Azure Key Vault in a pipeline](https://www.azuredevopslabs.com/labs/vstsextend/azurekeyvault/) 
	- Module 07: [Managing Technical Debt with Azure DevOps and SonarCloud](https://www.azuredevopslabs.com/labs/azuredevops/sonarcloud/) 
	- Module 09: [Managing Open-source security and license with WhiteSource](https://www.azuredevopslabs.com/labs/vstsextend/WhiteSource/) 
	- Module 13: [Monitoring Application Performance with Application Insights](https://azuredevopslabs.com/labs/azuredevops/appinsights/) 
	- Module 18: [Implement Security and Compliance in an Azure DevOps pipeline](http://microsoft.github.io/PartsUnlimited/iac/200.2x-IaC-SecurityandComplianceinpipeline.html) 
- Ref 
	- [Feed Permissions](https://docs.microsoft.com/en-us/azure/devops/artifacts/feeds/feed-permissions?view=azure-devops) 
	- [Service Feed Views](https://docs.microsoft.com/en-us/azure/devops/artifacts/concepts/views?view=azure-devops) 

### 6. Test Plans 