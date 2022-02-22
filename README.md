# IMApp_Account
Accounting web application by INTER-Mediator.

## Preparation
Installing PHP, git, composer, SQLite and Node.js with npm.

## Setup
This web app based on the composer. So you clone this repository, following to execute the composer command on the root of the repository.
```
git clone https://github.com/inter-mediator/IMApp_Account
cd IMApp_Account
composer install
```

## Getting Started App
The quick way to host the web app, the php command's server mode is convenient.
```
php -S localhost:9000
```
After that, you can access the application with url http://localhost:9000/ from any browser that executing on the same host.

## Database Operations

Within the ```composer install```, the database is going to initialize on the .im_db directory of home. If the file already exists, you can choose overwriting or leave it.

The command ```composer db-backup``` copies the database file to db-backup directory in the repository. Also the timestamp is going to add to the backuped file name.

The command ```composer db-restore``` restores the latest database file to .im_db directory of home.

The db-backup directory of this repository is out of git management initially. If you want store the contents of db-backup to repository, you have to folk or new repository and modify the .gitignore file.