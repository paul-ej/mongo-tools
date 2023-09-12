# DB Host
HOST=localhost
PORT=27017

# DB NAME
DBNAME=blank # Replace
DBAUTH=blank # Replace
DBUSER=""    # Populate
DBPASS=""    # Populate

# S3 Bucket name
BUCKET=example-bucket-name # Replace

# Linux user
USER= # Populate 

# Current time
TIME=$(/bin/date +%d-%m-%Y-%T)
DATE=$(/bin/date +%Y-%m-%d)

# Backup Dir
DEST=/tmp

# Log to console
echo "Backing up $HOST/$DBNAME to s3://$BUCKET/ on $TIME";

# Run the MongoExport command
echo "mongoexport --authenticationDatabase $DBAUTH -u $DBUSER -p $DBPASS -h $HOST:$PORT -d $DBNAME -o ./$DATE.json -c Alert --noHeaderLine"
# shellcheck disable=SC2086
mongoexport --authenticationDatabase $DBAUTH -u $DBUSER -p $DBPASS -h $HOST:$PORT -d $DBNAME -o $DEST/$DATE.json -c Alert --noHeaderLine

# Upload to S3
# shellcheck disable=SC2086
/usr/bin/aws s3 cp $DEST/$DATE.json s3://$BUCKET

# Remove local file
/bin/rm $DEST/$DATE.json

# Complete
echo "Export of MongoDB data for $DATE complete at $TIME"

