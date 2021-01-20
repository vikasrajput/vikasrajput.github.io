# AZ-400 (Azure DevOps Expert) Certification Notes 
If you are preparing for AZ-400 cert, below are some reference points: 
- [Guidance Page](https://docs.microsoft.com/en-us/learn/certifications/exams/az-400)
- [Microsoft Learning Path](https://docs.microsoft.com/en-us/learn/browse/?roles=devops-engineer&products=azure%2Cgithub&resource_type=learning%20path)
- [DevOps Labs](https://azuredevopslabs.com/)
- [DevOps Labs - Github](https://github.com/microsoft/azuredevopslabs)
- [Labs Prerequisite Setup](https://www.azuredevopslabs.com/labs/azuredevops/prereq/)
<br/><br/>

## Workflow 
Below is an high level grouping of key resources and labs which can help in preparation of the exam. Its not to go beyond or replace the official curriculum, but my personal view of way to group the learnings / exercises together - and should be looked as such only. 

### 1. Overview, Boards, Repos  
- Labs 
	- Module 01: DevOps Planning	
	- Module 02, 04: Source Control, Enterprise DevOps [Link1](https://www.azuredevopslabs.com/labs/azuredevops/git/),  [Link2](https://www.azuredevopslabs.com/labs/azuredevops/agile/)
	- Module 04: Technical Debt	 [Link](https://www.azuredevopslabs.com/labs/azuredevops/sonarcloud/) 
- Ref
    - [Demo: Local Git](https://vikasrajput.github.io/architecture/labs/lab-git-local.sh)
	- [Agile Manifesto](https://www.agilealliance.org/agile101/the-agile-manifesto/)
	- [State of DevOps by Puppet](https://puppet.com/resources/report/state-of-devops-report)
	- [Git Branching Models](https://nvie.com/posts/a-successful-git-branching-model/)
	- [Dashboards, Charts, Reports, Widgets](https://docs.microsoft.com/en-us/azure/devops/report/dashboards/overview?view=azure-devops&viewFallbackFrom=vsts)
<br/><br/>

### 2. Artifacts, Pipelines 
- Labs
	- Module 05, 06: Azure Pipelines, CI	[Link1](https://www.azuredevopslabs.com/labs/azuredevops/continuousintegration/), [Link2](https://docs.microsoft.com/en-us/azure/devops/pipelines/artifacts/universal-packages?view=azure-devops&tabs=classic), 
	[Link3](https://www.azuredevopslabs.com/labs/azuredevops/github-integration/) 
	- Module 07: App Config	 [Link](https://www.azuredevopslabs.com/labs/vstsextend/azurekeyvault/)  
	- Module 08: GitHub Actions [Link](https://github.com/MicrosoftLearning/AZ400-DesigningandImplementingMicrosoftDevOpsSolutions/blob/master/Instructions/Labs/AZ400_M08_GitHub_Actions_Continuous_Integration.md)
	- Module 09: Dependency Management [Link](https://www.azuredevopslabs.com/labs/azuredevops/packagemanagement/)
- Ref
	- [Putting it all together](https://www.edmondek.com/images/blue_green_azure_devops_app_service.png)
	- [Feed Permissions](https://docs.microsoft.com/en-us/azure/devops/artifacts/feeds/feed-permissions?view=azure-devops) 
	- [Service Feed Views](https://docs.microsoft.com/en-us/azure/devops/artifacts/concepts/views?view=azure-devops) 
<br/><br/>

### 3. Release Management 
- Labs
	- Module 10: Release Strategy
	- Module 11: Continuous Deployment [Link1](https://azuredevopslabs.com/labs/vstsextend/releasegates/), [Link2](https://www.azuredevopslabs.com/labs/azuredevops/yaml/)
	- Module 12: Deployment Patterns [Blue Green](https://azuredevopslabs.com/labs/azuredevops/continuousdeployment/), [Launch Darkly](https://www.azuredevopslabs.com/labs/vstsextend/launchdarkly/) 	 
- Ref
	- [Team Project Health](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.TeamProjectHealth)
	- [PostMan](https://www.postman.com/) 
	- [Feature Toggle](https://docs.microsoft.com/en-us/azure/devops/migrate/phase-features-with-feature-flags?view=azure-devops&viewFallbackFrom=vsts)
	- Deployment Patterns: [Blue-Green](https://res.cloudinary.com/practicaldev/image/fetch/s--fJ4tYKdy--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https:/thepracticaldev.s3.amazonaws.com/i/78dk41w8qmuy9f9pvrf6.png), [Canary](https://res.cloudinary.com/practicaldev/image/fetch/s--7PmOiuG9--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https:/thepracticaldev.s3.amazonaws.com/i/zvf9rbd1x38umph98zro.png), [Progressive Exposure or Rolling](https://res.cloudinary.com/practicaldev/image/fetch/s--RbA0NHA6--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https:/thepracticaldev.s3.amazonaws.com/i/divuxihkun2p186c9mye.png)
<br/><br/>

### 4. Infrastructure 
- Labs 	 	
	- Module 13: Manage Infra, Config [Link1](http://microsoft.github.io/PartsUnlimited/iac/200.2x-IaC-AZ-400T05AppInfra.html), [Link2](https://www.azuredevopslabs.com/labs/vstsextend/aspnetmodernize/) 	
	- Module 14: 3rd Party Tools *[Terraform](https://azuredevopslabs.com/labs/vstsextend/terraform/), [Ansible](http://microsoft.github.io/PartsUnlimitedMRP/iac/200.2x-IaC-AnsiblewithAzure.html), [Chef](http://microsoft.github.io/PartsUnlimitedMRP/iac/200.2x-IaC-DeployappwithChefonAzure.html), [Puppet](http://microsoft.github.io/PartsUnlimitedMRP/iac/200.2x-IaC-DeployappwithPuppetonAzure.html)
	- Module 15: Docker	 [Link](https://azuredevopslabs.com/labs/vstsextend/dockerjava/) 	 
	- Module 16: Kubernetes	[Link](https://azuredevopslabs.com/labs/vstsextend/kubernetes/)
- Ref 
<br/><br/>

### 5. Feedback
- Labs 	 	
	- Module 17: Dev Feedback [Link](https://azuredevopslabs.com/labs/azuredevops/appinsights/) 
	- Module 18: System Feedback 	
	- Module 19: Security in DevOps	[Link](http://microsoft.github.io/PartsUnlimited/iac/200.2x-IaC-SecurityandComplianceinpipeline.html)  		 
	- Module 20: Compliance 
- Ref 
<br/><br/>

### 6. Test Plans 