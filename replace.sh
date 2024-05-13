#!/bin/bash

    echo "Running replace scrpt..."
    envsubst < mongodump_script.sh > tmp.sh && mv tmp.sh mongodump_script.sh
    echo "$CRON_TIME /bin/bash /mongodump_script.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/mongodump-cron
    crontab /etc/cron.d/mongodump-cron
    echo "Replace script done!"