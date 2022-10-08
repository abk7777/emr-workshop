SERVICE := base-vpc
EC2_KEY_PAIR_NAME := $${STAGE}-$${APP_NAME}-$${AWS_REGION}-aws-devops-key

target:
	$(info ${HELP_MESSAGE})
	@exit 0

# service.check-key-pair: ##=> Checks if the key pair already exists and creates it if it does not
# 	@echo "$$(gdate -u +'%Y-%m-%d %H:%M:%S.%3N') - Checking for key pair ${EC2_KEY_PAIR_NAME}"
# 	@key_pair="$$(aws ec2 describe-key-pairs --key-name ${EC2_KEY_PAIR_NAME} | jq '.KeyPairs[0].KeyName' || true)" && \
# 	[ "$$key_pair" ] && echo "Key pair found: $$key_pair" && exit 0 || echo "No key pair found..." && \
# 	echo "Creating EC2 key pair \"${EC2_KEY_PAIR_NAME}\"" && \
# 	aws ec2 create-key-pair --key-name ${EC2_KEY_PAIR_NAME} | jq -r '.KeyMaterial' > ${EC2_KEY_PAIR_NAME}.pem && \
# 	aws ssm put-parameter \
# 		--name "/$${APP_NAME}/$${STAGE}/$${AWS_REGION}/EC2KeyPairName" \
# 		--type "String" \
# 		--value "${EC2_KEY_PAIR_NAME}" \
# 		--overwrite >/dev/null 2>&1 || true

deploy: 
	@echo "$$(gdate -u +'%Y-%m-%d %H:%M:%S.%3N') - Deploying ${SERVICE} service"
	$(MAKE) service.deploy

# TODO test AWSCLI output and validate the stack was created successfully
service.deploy:
	@echo "$$(gdate -u +'%Y-%m-%d %H:%M:%S.%3N') - Deploying CloudFormation"
	@aws cloudformation deploy \
		--region $${AWS_REGION} \
		--template-file template.yaml \
		--stack-name "$${STAGE}-$${APP_NAME}-${SERVICE}" \
		--capabilities CAPABILITY_IAM \
		--tags stage="$${STAGE}" app="$${APP_NAME}" \
		--parameter-overrides \
			Stage="$${STAGE}" \
			AppName="$${APP_NAME}"

delete: ##=> Delete resources
	@echo "$$(gdate -u +'%Y-%m-%d %H:%M:%S.%3N') - Deleting ${SERVICE} service"
ifeq ($(data),true)
	@echo "$$(gdate -u +'%Y-%m-%d %H:%M:%S.%3N') - Deleting data in $$DATA_BUCKET_NAME"
	@aws s3 rm --recursive s3://$$DATA_BUCKET_NAME/
endif
	$(MAKE) delete.cfn

delete.cfn:
	@echo "$$(gdate -u +'%Y-%m-%d %H:%M:%S.%3N') - Deleting CloudFormation"
	@aws cloudformation delete-stack \
		--stack-name "$${STAGE}-$${APP_NAME}-${SERVICE}" >/dev/null 2>&1 || true && \
	aws cloudformation wait stack-delete-complete \
		--stack-name "$${STAGE}-$${APP_NAME}-${SERVICE}" >/dev/null 2>&1 || true

#############
#  Helpers  #
#############

define HELP_MESSAGE

	Environment variables:

	SERVICE: "${SERVICE}"
		Description: Name of the service being deployed

	Common usage:

	...::: Deploy all CloudFormation based services :::...
	$ make deploy

	...::: Delete all CloudFormation based services :::...
	$ make delete

endef