
# Perform mongodump with the specified output directory
echo "Database backup is in proccess..."
mongodump --uri "mongodb://$MONGO_DB_USER:$MONGO_DB_PASS@$MONGO_DB_HOST:27017/" --out "/backup/db_$(date +%Y-%m-%d_%H-%M-%S)"

cd /backup
duplicacy backup -stats

# Keep only the three most recent backup directories
ls -dt /backup/* | tail -n +$MONGO_DB_NUM | xargs rm -rf
echo "Database backup complete!"