# DB host (secondary preferred as to avoid impacting primary performance)
HOST=localhost
PORT=27017

# DB name
DBNAME=blank  # Populate
DBAUTH=blank  # Populate 
DBUSER=""     # Populate 
DBPASS=""     # Populate 

# S3 bucket name
BUCKET=example-bucket-name # Replace

# Linux user account
USER= # Populate

# Current time
TIME=$(/bin/date +%d-%m-%Y-%T)
QDATE=$(/bin/date +%Y-%m-%d)

# Backup directory
DEST=/data/tmp/bck

# Tar file of backup directory
TAR=$DEST/../$QDATE.tar

# Create backup dir (-p to avoid warning if already exists)
/bin/mkdir -p $DEST

# Log
echo "Backing up $HOST/$DBNAME to s3://$BUCKET/ on $TIME";

# Dump from mongodb host into backup directory
# mongodump -h $HOST -d $DBNAME -o $DEST
echo "mongoexport --authenticationDatabase $DBAUTH -u $DBUSER -p $DBPASS -h $HOST:$PORT -d $DBNAME -o ./collection_name.csv -c Alert --type=csv"
mongoexport --authenticationDatabase $DBAUTH -u $DBUSER -p $DBPASS -h $HOST:$PORT -d $DBNAME -o $DEST/collection_name.csv -c Alert --type=csv

# echo "mongo $DBNAME --eval 'db.collection_name.deleteMany( { \"date\": { $lt: \"$QDATE\" } } );'"
# mongo  --authenticationDatabase $DBAUTH -u $DBUSER -p $DBPASS $HOST:$PORT/$DBNAME --eval 'db.collection_name.deleteMany( { "date": { $lt: "'$QDATE'" } } );'

# Create tar of backup directory
/bin/tar -jcvf "$TAR" -C $DEST .

# Extract contents of TAR
/bin/tar -xf "$TAR" -C "$QDATE".json

# Upload file to s3
/usr/bin/aws s3 cp $QDATE.csv s3://$BUCKET/

# Remove tar file locally
/bin/rm -f "$TAR"

# Remove backup directory
/bin/rm -rf $DEST

# All done
echo "Backup available at https://s3.amazonaws.com/$BUCKET/$QDATE_$TIME.csv"