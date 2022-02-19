#!/bin/sh

IM_DB_DIR="${HOME}/.im_db"
IM_DB_FILE="${IM_DB_DIR}/imapp_account.sqlite3"
myDir=$(
  cd $(dirname "$0")
  pwd
)
appRootDir=$(dirname "${myDir}")
imRoot="${appRootDir}/vendor/inter-mediator/inter-mediator"

mkdir -p "${IM_DB_DIR}"
if [ -e "${IM_DB_FILE}" ]; then
  echo "The database file alread exists as '${IM_DB_FILE}'."
  /bin/echo -n "If you want to delete the db file and reinstall the db schema, type 'YES'. -->"
  read choice
  if [ "${choice}" == "YES" ]; then
    rm "${IM_DB_FILE}"
  else
    echo "The db file didn't touch so far."
    exit 9
  fi
fi
sqlite3 "${IM_DB_FILE}" <"${myDir}/basic_schema.sql"
echo "The database file is istalled as '${IM_DB_FILE}'."
