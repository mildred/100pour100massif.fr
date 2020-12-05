#!/bin/bash

echo -e "\033[0;32mBuild...\033[0m"

HUGO_VERSION=0.79.0

if ! [[ -e hugo_${HUGO_VERSION}_Linux-64bit.tar.gz ]]; then
  wget https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz
fi
tar zxf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz hugo

./hugo
