#!/bin/bash

if ! [ -x "$(command -v hugo)" ]; then
    echo Installing hugo snap
    snap install hugo
fi

read -p "WARNING, THIS WILL DELETE ALL FILES HOSTED ON YOUR STANFORD WWW. DO YOU WISH TO CONTINUE? (Y/n) " continue

if [ "${continue}" != "Y" ] && [ "${continue}" != "y" ]; then
    exit
fi

read -p "What is your SUNet ID? " SunetID
sed -i -e "s|baseurl = \".\+\"|baseurl = \"https\://web.stanford\.edu/\~${SunetID}/\"|" config.toml

if [ -d ./public ]; then
    rm -r public
fi
echo "Generating Website: "
hugo

ssh "${SunetID}"@cardinal.stanford.edu << EOF
    rm -r ./WWW/*
    exit
EOF

scp -r ./public/. "${SunetID}"@cardinal.stanford.edu:WWW
