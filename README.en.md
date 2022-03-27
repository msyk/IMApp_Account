# IMApp_Account

Masayuki Nii (nii@msyk.net)

[![ja](https://img.shields.io/badge/lang-ja-red)](https://github.com/msyk/IMApp_Account/blob/master/README.md)

Accounting web application by INTER-Mediator.

## Preparation
Installing PHP, git, composer, SQLite and Node.js with npm.
I usually use my Mac only, also Linux is in my field. I'm just check this on Windows Subsystem for Linux (WSL) for Windows OS.

## Setup
This web app based on the composer. So you clone this repository, following to execute the composer command on the root of the repository.
```
git clone https://github.com/msyk/IMApp_Account
cd IMApp_Account
composer install
```
If you want to store this app on your own repository, you can clone from the template repository which is GitHub feature. So you can store it as private repository.

## Getting Started App
The quick way to host the web app, the php command's server mode is convenient.
```
php -S localhost:9000
```
After that, you can access the application with url http://localhost:9000/ from any browser that executing on the same host.

## Setup for S3

I'd like to read the README.md file in private directory. If you create the file named 'aws_setting.php' in it with S3 available account, you can store the files to S3.

## Database Operations

Within the ```composer install```, the database is going to initialize on the .im_db directory of home. If the file already exists, you can choose overwriting or leave it.

The command ```composer db-backup``` copies the database file to db-backup directory in the repository. Also the timestamp is going to add to the backuped file name.

The command ```composer db-restore``` restores the latest database file to .im_db directory of home.

The command ```composer update``` updates PHP and JavaScript libraries.

# Your Original Repository

This repository is public, and we can't push any sensitive information.
If you feel no problem in case of this is private, you can handle this as the Template repository which is GitHub's feature.
Your private repository can store any kind of private data if you don't mind.
You can back up the data, and also you can store your original pages.
But the demerit is your repository is separated from this, and any update of here can't apply to yours with simple way.

- To create your own repository, you have to click the 'Use this Template' button on the top page of this repository.
- You make the clone of yours.
- The commands ```composer db-backup``` and ```composer db-restore``` are possible to the data on your repository.
- Check the README.md file on 'private' directory of here.
- Remove the entry 'db-backup', 'private/*.sql' and 'private/*.php' of the .gitignore files to commit some files you added.

Is the repository is safe for any security issues? This is difficult questions, but anyway cloud service is safer than less managed on-premise servers.