#!/bin/bash

#/backup.sh
#/restore.sh
mongodump --out /backup/meteorback --host ${MONGODB_BACKUP_HOST} --port ${MONGODB_BACKUP_PORT} --db=${MONGODB_BACKUP_DB}
if mongorestore --drop --host ${MONGODB_RESTORE_HOST} --port ${MONGODB_RESTORE_PORT} --db=${MONGODB_RESTORE_DB} /backup/meteorback; then
    echo "   Restore succeeded"
else
    echo "   Restore failed"
fi
