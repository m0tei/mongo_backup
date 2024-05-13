# Generate current date in YYYY-MM-DD format
CURRENT_DATETIME=$(date +%Y-%m-%d_%H-%M-%S)

# Append current date to the backup directory name
BACKUP_DIR="/backup/db_$CURRENT_DATETIME"

# Construct MongoDB URI
MONGO_URI="mongodb://$MONGO_DB_USER:$MONGO_DB_PASS@$MONGO_DB_HOST:27017/"

# Perform mongodump with the specified output directory
mongodump --uri "$MONGO_URI" --out "$BACKUP_DIR"

cd /backup
duplicacy backup -stats

# Keep only the three most recent backup directories
ls -dt /backup/* | tail -n +4 | xargs rm -rf