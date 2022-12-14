##########################
# Bootstrapping variables
##########################

# Application specific environment variables
include .env
export

# Base settings, these should almost never change
export AWS_ACCOUNT ?= $(shell aws sts get-caller-identity --query Account --output text)
export ROOT_DIR ?= $(shell pwd)

target:
	$(info ${HELP_MESSAGE})
	@exit 0

check.env:
ifndef STAGE
$(error STAGE is not set. Please add STAGE to the environment variables.)
endif
ifndef APP_NAME
$(error APP_NAME is not set. Please add APP_NAME to the environment variables.)
endif
ifndef AWS_PROFILE
$(error AWS_PROFILE is not set. Please select an AWS profile to use.)
endif
ifndef ADMIN_EMAIL
$(error ADMIN_EMAIL is not set. Please add ADMIN_EMAIL to the environment variables.)
endif

deploy: ##=> Deploy services
	$(MAKE) base.deploy
	$(MAKE) emr.deploy

# Deploy specific stacks
base.deploy:
	$(MAKE) -C ${APP_NAME}/base/ deploy

emr.deploy:
	$(MAKE) -C ${APP_NAME}/emr/ deploy


delete: ##=> Delete services
	$(MAKE) base.delete
	$(MAKE) emr.delete

# Delete specific stacks
base.delete:
	$(MAKE) -C ${APP_NAME}/base/ delete

emr.delete:
	$(MAKE) -C ${APP_NAME}/emr/ delete

define HELP_MESSAGE

	Environment variables:

	STAGE: "${STAGE}"
		Description: Feature branch name used as part of stacks name

	APP_NAME: "${APP_NAME}"
		Description: Stack Name already deployed

	AWS_ACCOUNT: "${AWS_ACCOUNT}":
		Description: AWS account ID for deployment

	AWS_REGION: "${AWS_REGION}":
		Description: AWS region for deployment

	Common usage:

	...::: Deploy all CloudFormation based services :::...
	$ make deploy

	...::: Delete all CloudFormation based services and data :::...
	$ make delete

endef
