#!/bin/sh

export HOME=/home/#DB Username/

HOST=localhost

# DB name
DBNAME=#DB Name

# S3 bucket name
BUCKET= #Bucket Name

# Linux user account
USER=#Bucket User

# Current time
TIME=`/bin/date +%d-%m-%Y`

# Backup directory
DEST=/home/$USER/tmp

# Tar file of backup directory
TAR=$DEST/../$TIME.tar

# Create backup dir (-p to avoid warning if already exists)
/bin/mkdir -p $DEST

# Log
echo "Backing up $HOST/$DBNAME to s3://$BUCKET/ on $TIME";

# Dump from mongodb host into backup directory
/home/ssm-user/mongodb-database-tools-amazon2-x86_64-100.5.1/bin/mongoexport -h $HOST -d $DBNAME --collection=Alerts -o $DEST

# Create tar of backup directory
/bin/tar cvf $TAR -C $DEST .

# Upload tar to s3
/usr/bin/aws s3 cp $TAR s3://$BUCKET/ --storage-class STANDARD_IA

# Remove tar file locally
/bin/rm -f $TAR

# Remove backup directory
/bin/rm -rf $DEST

# All done
echo "Backup available at https://s3.amazonaws.com/$BUCKET/$TIME.tar"