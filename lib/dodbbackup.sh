#!/bin/sh

DB_PREFIX="imapp_account"
IM_DB_DIR="${HOME}/.im_db"
IM_DB_FILE="${IM_DB_DIR}/imapp_account.sqlite3"
myDir=$(
  cd $(dirname "$0")
  pwd
)
appRootDir=$(dirname "${myDir}")
imRoot="${appRootDir}/vendor/inter-mediator/inter-mediator"
backupDir="${appRootDir}/db-backup"

mkdir -p "${backupDir}"
echo "${IM_DB_FILE}"
if [ -e "${IM_DB_FILE}" ]; then
  dt=$(date -u "+%Y-%m-%dT%H:%M:%SZ")
  cp "${IM_DB_FILE}" "${backupDir}/${DB_PREFIX}-${dt}.sqlite3"
  echo "The database file is copied to '${backupDir}/${DB_PREFIX}-${dt}.sqlite3'."
fi
