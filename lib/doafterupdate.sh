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

sqlite3 "${IM_DB_FILE}" < "${myDir}/schema_views.sql"

echo "**** Please check the README.md file. ****"