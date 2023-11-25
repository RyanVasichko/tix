#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Database credentials
DB_NAME="dosey_doe_tickets"
DB_USER="dosey_doe_tickets"
CONTAINER_NAME="dosey_doe_tickets-db"

# Retrieve password from Docker container's environment variable
DB_PASSWORD=$(docker exec $CONTAINER_NAME printenv POSTGRES_PASSWORD)

# S3 Bucket details
S3_BUCKET="dosey-doe-tickets-db-backups"
# S3_PATH="path/to/store/backup" # Optional, can be left empty

# Date format for backup file
BACKUP_DATE=$(date +"%Y-%m-%d")
BACKUP_FILENAME="backup_$BACKUP_DATE.sql"
BACKUP_DIR="./backups"

# Create backup
docker exec $CONTAINER_NAME pg_dump -U $DB_USER -d $DB_NAME --no-password > $BACKUP_DIR/$BACKUP_FILENAME

# Upload to S3
aws s3 cp $BACKUP_DIR/$BACKUP_FILENAME s3://$S3_BUCKET/$BACKUP_FILENAME

# Clean up old backups
find $BACKUP_DIR -type f -name 'backup_*.sql' ! -name $BACKUP_FILENAME -delete