#!/bin/sh

IM_DB_DIR="~/.im_db"
IM_DB_FILE="${IM_DB_DIR}/imapp_account.sqlite3"
myDir=$(
  cd $(dirname "$0")
  pwd
)
appRootDir=$(dirname "${myDir}")
imRoot="${appRootDir}/vendor/inter-mediator/inter-mediator"
