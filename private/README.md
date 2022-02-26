# about private directory

You can store additional files with following fixed names for just your repository.

## my_initial_data.sql

If the file 'my_initial_data.sql' exists, these sql command is going to install when you execute ```composer install```.

## aws_settings.php

If the file 'aws_settings.php' exists, the php code is going to include in params.php. Typically, you will set the S3 setup as like.


```angular2html
<?php
$accessRegion = "ap-northeast-1"; // This means the Tokyo region.
$rootBucket = "inter-mediator-account";
$s3AccessKey = "AKIAXXXXXXXXXXXXXXXX";
$s3AccessSecret = "XXXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXXXXXXXX";
```