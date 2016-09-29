#!/usr/bin/env bash

echo "Installing essential tools" #todo: make custom docker image

apk add --update wget
apk add --update curl
apk add --update ca-certificates
apk add --update util-linux
