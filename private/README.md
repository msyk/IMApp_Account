# about private directory

You can store additional files with following fixed names for just your repository.

## my_initial_data.sql

If the file 'my_initial_data.sql' exists, these sql command is going to install when you execute ```composer install```.

## aws_settings.php

If the file 'aws_settings.php' exists, the php code is going to include in params.php. Typically, you will set the S3 setup as like.


```
<?php
$accessRegion = "ap-northeast-1"; // This means the Tokyo region.
$rootBucket = "inter-mediator-account";
$s3AccessKey = "AKIAXXXXXXXXXXXXXXXX";
$s3AccessSecret = "XXXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXXXXXXXX";
```

## com.github.msyk.IMApp_Account.plist

For macos, you can copy this file to the user's LaunchAgents directory (~/Library/LaunchAgents).
This file executes the php server for IMApp_Account on loging in.
Before copying, you have to match the path of the WorkingDirectory's value to the root of your repository.
After copying, you have to execute below:

```launchctl load -w ~/Library/LaunchAgents/com.github.msyk.IMApp_Account.plist```

This file supposed to use the 19000 port, and php is going to install with the homebrew.