#!/usr/bin/env bash

aws s3 --profile mwesterdahl76 cp ./public/ s3://www.sizeofvoid.com/ --recursive --metadata-directive REPLACE --cache-control max-age=2592000,public
aws s3 --profile mwesterdahl76 cp ./site/.htaccess s3://www.sizeofvoid.com/
