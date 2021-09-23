#!/usr/bin/env bash

apt update && apt install -y python3 ansible wget unzip

pip3 install docker

wget https://releases.hashicorp.com/terraform/1.0.7/terraform_1.0.7_linux_amd64.zip

unzip terraform_1.0.7_linux_amd64.zip

cp ./terraform /usr/bin/
