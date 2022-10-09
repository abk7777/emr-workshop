SERVICE := emr
SERVICE_DIR := ${ROOT_DIR}/${APP_NAME}/${SERVICE}
EC2_KEY_PAIR_NAME := $${STAGE}-$${APP_NAME}-$${AWS_REGION}-ec2-key-pair

# test:
# 	@echo ${SERVICE_DIR}

target:
	$(info ${HELP_MESSAGE})
	@exit 0

service.check-key-pair: ##=> Checks if the key pair already exists and creates it if it does not
	@echo "$$(gdate -u +'%Y-%m-%d %H:%M:%S.%3N') - Checking for key pair ${EC2_KEY_PAIR_NAME}"
	@key_pair="$$(aws ec2 describe-key-pairs --key-name ${EC2_KEY_PAIR_NAME} | jq '.KeyPairs[0].KeyName' || true)" && \
	[ "$$key_pair" ] && echo "Key pair found: $$key_pair" && exit 0 || echo "No key pair found..." && \
	echo "Creating EC2 key pair \"${EC2_KEY_PAIR_NAME}\"" && \
	aws ec2 create-key-pair --key-name ${EC2_KEY_PAIR_NAME} | jq -r '.KeyMaterial' > ${ROOT_DIR}/${EC2_KEY_PAIR_NAME}.pem && \
	aws ssm put-parameter \
		--name "/$${APP_NAME}/$${STAGE}/$${AWS_REGION}/EC2KeyPairName" \
		--type "String" \
		--value "${EC2_KEY_PAIR_NAME}" \
		--overwrite 2>&1
	@echo "Don't forget to udate key permissions using \`chmod 400 ${EC2_KEY_PAIR_NAME}\`"

deploy: service.check-key-pair
	@echo "$$(gdate -u +'%Y-%m-%d %H:%M:%S.%3N') - Deploying ${SERVICE} service"
	$(MAKE) service.deploy
	$(MAKE) service.jobs.deploy

service.data.deploy:
	@bash scripts/load_s3.sh

service.jobs.deploy:
	@file_path=spark-jobs/spark-etl-01.py && \
	s3_path=files/spark-etl-01.py && \
	aws s3 cp \
		${SERVICE_DIR}/$$file_path \
		s3://${DATA_BUCKET_NAME}/$$s3_path
	@file_path=spark-jobs/spark-etl-02.py && \
	s3_path=files/spark-etl-02.py && \
	aws s3 cp \
		${SERVICE_DIR}/$$file_path \
		s3://${DATA_BUCKET_NAME}/$$s3_path
	@file_path=hive-scripts/ny-taxi.hql && \
	s3_path=files/ny-taxi.hql && \
	aws s3 cp \
		${SERVICE_DIR}/$$file_path \
		s3://${DATA_BUCKET_NAME}/$$s3_path


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

delete:
	$(MAKE) delete.cfn
	$(MAKE) service.delete-key-pair

delete.cfn:
	@echo "$$(gdate -u +'%Y-%m-%d %H:%M:%S.%3N') - Deleting CloudFormation"
	@aws cloudformation delete-stack \
		--stack-name "$${STAGE}-$${APP_NAME}-${SERVICE}" 2>&1 || true
	@aws cloudformation wait stack-delete-complete \
		--stack-name "$${STAGE}-$${APP_NAME}-${SERVICE}" 2>&1 || true

service.delete-key-pair:
	aws ec2 delete-key-pair --key-name "${EC2_KEY_PAIR_NAME}" 2>&1 || true && \
	aws ssm delete-parameter --name "/$${APP_NAME}/$${STAGE}/$${AWS_REGION}/EC2KeyPairName" 2>&1 || true

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