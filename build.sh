#!/bin/bash

echo -e "\033[0;32mBuild...\033[0m"

if ! [[ -e hugo_0.18_Linux-64bit.tar.gz ]]; then
  wget https://github.com/spf13/hugo/releases/download/v0.18/hugo_0.18_Linux-64bit.tar.gz
fi
tar zxf hugo_0.18_Linux-64bit.tar.gz
hugo_0.18_linux_amd64/hugo_0.18_linux_amd64
