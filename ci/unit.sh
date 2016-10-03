#!/usr/bin/env bash

set -ex

echo "Jumping through hoops for Go"
export GOPATH=`pwd`
export PATH=$GOPATH/bin:$PATH

cp -r release-repo/src/splunk-firehose-nozzle splunk-firehose-nozzle
mkdir -p src/github.com/cf-platform-eng
mv splunk-firehose-nozzle src/github.com/cf-platform-eng

cd src/github.com/cf-platform-eng/splunk-firehose-nozzle


echo "Installing Go test tools"
echo ""
go get github.com/onsi/ginkgo/ginkgo
go get github.com/onsi/gomega


echo "Building"
echo ""
go build main.go


echo "Testing"
echo ""
ginkgo -r
