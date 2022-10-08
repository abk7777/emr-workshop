# emr-workshop

CloudFormation deployments for the [AWS EMR workshop](https://catalog.us-east-1.prod.workshops.aws/workshops/c86bd131-f6bf-4e8f-b798-58fd450d3c44/en-US).

## Table of Contents
- [emr-workshop](#emr-workshop)
  - [Table of Contents](#table-of-contents)
  - [Project Structure](#project-structure)
  - [Description](#description)
  - [Quickstart](#quickstart)
  - [Application Layers](#application-layers)
    - [Base Infrastructure](#base-infrastructure)
    - [EMR Infrastructure](#emr-infrastructure)
  - [Installation](#installation)
    - [Prerequisites](#prerequisites)
  - [Troubleshooting](#troubleshooting)
  - [References & Links](#references--links)
  - [Authors](#authors)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>


## Project Structure
```bash
.
├── Makefile                            # Root Makefile for build and deployment
├── README.md
├── requirements-dev.txt                # Development requirements
└── emrworkshop                         # Subreddit Data Ingestion Pipeline application
    ├── base                            # analytics infrastructure
    │   ├── Makefile                    # Layer-specific Makefile
    │   └── template.yaml               # Layer-specific CloudFormation
    └── emr                             # Base infrastructure
        ├── Makefile                    # Layer-specific Makefile
        └── template.yaml               # Layer-specific CloudFormation
```

## Description
This project uses CloudFormation templates to deploy resources as part of the [AWS EMR workshop](https://catalog.us-east-1.prod.workshops.aws/workshops/c86bd131-f6bf-4e8f-b798-58fd450d3c44/en-US). 
Resources are organized by layer, the deployment and deletion of which are orchestrated by Makefiles.

<!-- ## Architecture
![sdip-arch-1](docs/source/_static/img/sdip-arch.png) -->

## Quickstart
1. Configure your AWS credentials.
2. Deploy all layers.
   ```bash
   make deploy
   ```

## Application Layers
The application infrastructure is organized into layers. Shared configurations are accessed using environment variables in the Makefiles, SSM Parameter Store or Secrets Manager. Each layer folder contains a `Makefile` and which deploys or deletes AWS infrastructure using CloudFormation defined in `template.yaml`. The Makefiles also contain targets for invoking the data ingestion pipeline and deploying input parameters. 
<!-- See [Usage](#usage) for more information. -->

### Base Infrastructure
VPC, subnets, networking resources, S3 buckets and SSM parameters for data and application configuration.

### EMR Infrastructure
Defines the layer for deploying and configuring the EMR cluster.

## Installation
Follow the steps to set the deployment environment.

### Prerequisites
* AWSCLI
* jq
<!-- * SAM CLI
* Python 3.9 -->

<!-- ### Creating a Python Virtual Environment
When developing locally, create a Python virtual environment to manage dependencies:
```bash
python3 -m venv .venv-dev
source .venv-dev/bin/activate
pip install -U pip
pip install -r requirements.txt
```

### Notebook Setup
To use the virtual environment inside Jupyter Notebook, first activate the virtual environment, then create a kernel for it.
```bash
# Install ipykernal and dot-env
pip install ipykernel python-dotenv

# Add the kernel
python3 -m ipykernel install --user --name=<environment name>

# Delete the kernel
jupyter kernelspec uninstall <environment name>
``` -->

### Environment Variables

Sensitive environment variables containing secrets like passwords and API keys must be exported to the environment first.

Create a `.env` file in the project root.
```bash
STAGE=<value>
APP_NAME=<value>
AWS_REGION=<value>
```

***Important:*** *Always use a `.env` file or AWS SSM Parameter Store or Secrets Manager for sensitive variables like credentials and API keys. Never hard-code them, including when developing. AWS will quarantine an account if any credentials get accidentally exposed and this will cause problems.*

***Make sure that `.env` is listed in `.gitignore`***

### AWS Credentials
Valid AWS credentials must be available to AWS CLI and SAM CLI. The easiest way to do this is running `aws configure`, or by adding them to `~/.aws/credentials` and exporting the `AWS_PROFILE` variable to the environment.

For more information visit the documentation page:
[Configuration and credential file settings](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

## AWS Deployment
Once an AWS profile is configured and environment variables are exported, the application can be deployed using `make`.
```bash
make deploy
```

## Makefile Usage
```bash
# Deploy all layers
make deploy

# Delete all layers (data in S3 must be deleted manually first)
make delete

# Deploy only one layer
make emr.deploy

# Delete only one layer
make emr.delete
```

<!-- ## Testing
### Unit Tests
Create a Python virtual environment to manage test dependencies.

```bash
python3 -m venv .venv-test
source .venv-test/bin/activate
pip install -U pip
pip install -r requirements-tests.txt
```
Run tests with the following command.
```bash
coverage run -m pytest  
``` -->

## Troubleshooting
* Check your AWS credentials in `~/.aws/credentials`
* Check that the environment variables are available to the services that need them
* Check that the correct environment or interpreter is being used for Python

## References & Links
- [AWS EMR workshop](https://catalog.us-east-1.prod.workshops.aws/workshops/c86bd131-f6bf-4e8f-b798-58fd450d3c44/en-US)
- [EMR documentation](https://docs.aws.amazon.com/emr/index.html)
- [CloudFormation EMR documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticmapreduce-cluster.html)

## Authors
**Primary Contact:** Gregory Lindsey (@abk7777)
