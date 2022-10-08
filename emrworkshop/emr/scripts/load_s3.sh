#! usr/bin/bash

ROOT_DIR=.
ENV_PATH=$ROOT_DIR/.env

source $ENV_PATH

# Get data bucket name
DATA_BUCKET_NAME=$(aws ssm get-parameters \
    --names "/${APP_NAME}/${STAGE}/${AWS_REGION}/DataBucketName" \
    | jq -r '.Parameters[0].Value')

echo $DATA_BUCKET_NAME

TRIP_DATA_URL=https://static.us-east-1.prod.workshops.aws/public/37c55bac-9e64-4410-831c-8630f6365626/static/files/spark-etl/tripdata.csv
SALES_DATA_URL=https://static.us-east-1.prod.workshops.aws/public/37c55bac-9e64-4410-831c-8630f6365626/static/files/spark-etl/sales.csv

mkdir tmp

curl -SL $TRIP_DATA_URL > tmp/tripdata.csv
curl -SL $SALES_DATA_URL > tmp/sales.csv

aws s3 cp ./tmp/tripdata.csv s3://$DATA_BUCKET_NAME/input/tripdata.csv
aws s3 cp ./tmp/sales.csv s3://$DATA_BUCKET_NAME/data/sales.csv

rm -rf tmp/