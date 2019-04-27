#!/usr/bin/env bash

hugo

cp public/404.html public/error.html

function compress_file {
    local path=$1
    gzip -9 $path
    mv ${path}.gz $path
}

# compress_file public/css/bootstrap.min.css
# compress_file public/css/syntax.css
# compress_file public/css/den.css
# compress_file public/css/custom.css
