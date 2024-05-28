#!/bin/bash
# Previusly you need to install aws-cli and configure it with your credentials
# set envs: MONGODB_URI, DB_NAME, S3_BUCKET_NAME, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
# Usage: ./mongo-backup.sh mydb
echo ******************************************************
echo Starting-BACKUP
echo ******************************************************

DB_NAME=${1:-"mydb"}
NOW=$(date +'%Y%m%d_%H%M%S')
FILE="$DB_NAME-$NOW-archive.gz"

mongodump --gzip --uri=$MONGODB_URI --db=$DB_NAME --archive=$PWD/$FILE

if [[ -n $S3_BUCKET_NAME ]]; then
  echo "Uploading $FILE to S3"
  aws s3 cp $PWD/$FILE s3://$S3_BUCKET_NAME/backups/$DB_NAME/
fi

sleep 5 | echo End-BACKUP
