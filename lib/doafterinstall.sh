#!/bin/sh

DB_PREFIX="imapp_account"
IM_DB_DIR="${HOME}/.im_db"
IM_DB_FILE="${IM_DB_DIR}/${DB_PREFIX}.sqlite3"
myDir=$(
  cd $(dirname "$0")
  pwd
)
appRootDir=$(dirname "${myDir}")
imRoot="${appRootDir}/vendor/inter-mediator/inter-mediator"

mkdir -p "${IM_DB_DIR}"
if [ -e "${IM_DB_FILE}" ]; then
  echo "The database file alread exists as '${IM_DB_FILE}'."
  read -p "If you want to delete the db file and reinstall the db schema, type 'YES'. -->" choice
  if [ " ${choice}" = " YES" ]; then
    rm "${IM_DB_FILE}"
  else
    echo "The db file didn't touch so far."
    exit 0
  fi
fi
sqlite3 "${IM_DB_FILE}" < "${myDir}/schema_basic.sql"
sqlite3 "${IM_DB_FILE}" < "${myDir}/schema_views.sql"
sqlite3 "${IM_DB_FILE}" < "${myDir}/schema_initial_data.sql"
PRIV_SRC="${appRootDir}/private/my_initial_data.sql"
if [ -e "${PRIV_SRC}" ]; then
  sqlite3 "${IM_DB_FILE}" < "${PRIV_SRC}"
fi
echo "The database file is installed as '${IM_DB_FILE}'."
