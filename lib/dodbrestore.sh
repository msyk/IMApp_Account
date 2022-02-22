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

for entry in $(ls -r "${backupDir}"); do
  rm "${IM_DB_FILE}"
  cp "${backupDir}/${entry}" "${IM_DB_FILE}"
  echo "The database file is restored from '${entry}'."
  exit 0
done

echo "No backup file of the database."
exit 1