#!/bin/bash

MONGODB_HOST=${MONGODB_RESTORE_PORT_27017_TCP_ADDR:-${MONGODB_RESTORE_HOST}}
MONGODB_HOST=${MONGODB_RESTORE_PORT_1_27017_TCP_ADDR:-${MONGODB_RESTORE_HOST}}
MONGODB_PORT=${MONGODB_RESTORE_PORT_27017_TCP_PORT:-${MONGODB_RESTORE_PORT}}
MONGODB_PORT=${MONGODB_RESTORE_PORT_1_27017_TCP_PORT:-${MONGODB_RESTORE_PORT}}
MONGODB_USER=${MONGODB_RESTORE_USER:-${MONGODB_RESTORE_ENV_MONGODB_USER}}
MONGODB_PASS=${MONGODB_RESTORE_PASS:-${MONGODB_RESTORE_ENV_MONGODB_PASS}}

[[ ( -z "${MONGODB_RESTORE_USER}" ) && ( -n "${MONGODB_RESTORE_PASS}" ) ]] && MONGODB_RESTORE_USER='admin'

[[ ( -n "${MONGODB_RESTORE_USER}" ) ]] && USER_RESTORE_STR=" --username ${MONGODB_RESTORE_USER}"
[[ ( -n "${MONGODB_RESTORE_PASS}" ) ]] && PASS_RESTORE_STR=" --password ${MONGODB_RESTORE_PASS}"
[[ ( -n "${MONGODB_RESTORE_DB}" ) ]] && USER_RESTORE_STR=" --db ${MONGODB_RESTORE_DB}"

FILE_TO_RESTORE=${1}

[[ -z "${1}" ]] && FILE_TO_RESTORE=$(ls /backup -N1 | grep -iv ".tgz" | sort -r | head -n 1)

echo "=> Restore database from ${FILE_TO_RESTORE} to ${MONGODB_RESTORE_HOST}:${MONGODB_RESTORE_PORT} to db ${USER_RESTORE_STR} ${PASS_RESTORE_STR}"
if mongorestore --drop --host ${MONGODB_RESTORE_HOST} --port ${MONGODB_RESTORE_PORT} ${USER_RESTORE_STR} ${PASS_RESTORE_STR} /backup/$FILE_TO_RESTORE/meteor; then
    echo "   Restore succeeded"
else
    echo "   Restore failed"
fi
echo "=> Done"
