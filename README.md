# terraform-aws-ethereum-nodes
Terraform to build Ethereum geth nodes infrastructure on AWS for fsbft(Fast and Simple BFT) experiment.
Powered by [**Terraform**](https://www.terraform.io/docs/providers/aws/) & [**Terragrunt**](https://davidbegin.github.io/terragrunt/).

## Develop Environment
1. Install Terraform: Follow the [**Official Document**](https://www.terraform.io/intro/getting-started/install.html) to install Terraform version **v0.11.11**, macOS user could use brew to install it directly
2. Install Terragrunt: Follow the [**Installation Guide**](https://davidbegin.github.io/terragrunt/) to install Terragrunt version **v0.17.4**
3. Check whether there is proper permission to manage AWS resource in the machine. Using AWS profile is suggested.
4. git clone this repository
	```
	~$ git clone git@github.com:charles-hsiao/terraform-aws-ethereum-nodes.git
	```

## Folder Structure
When executing Native Terragrunt Command, that will take effect in current folder, so before doing something, please switch the **"Correct"** folder
Below is the folder structure of this project
```
├── fsbft (AWS Account)
│   ├── prod (Environment)
│   └── stag 
│       └── us-west-2 (Region)
│           └── fsbft (Project)
│               ├── env.tfvars
│               ├── geth-nodes (Roles)
│               │   └── terraform.tfvars
│               ├── terraform.tfvars
│               └── vpc (Base Network)
│                   └── terraform.tfvars
└── modules
    └── fsbft
        ├── geth-nodes
        │   ├── asg.tf
        │   └── ...
        └── vpc
            ├── main.tf
            ├── outputs.tf
            ├── variables.tf
            └── vpc.tf
```
