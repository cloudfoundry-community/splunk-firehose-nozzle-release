#!/usr/bin/env bash

set -ex

echo "Jumping through hoops for Go"
export GOPATH=`pwd`
export PATH=$GOPATH/bin:$PATH

cp -r release-repo/src/splunk-firehose-nozzle splunk-firehose-nozzle
mkdir -p src/github.com/cloudfoundry-community
mv splunk-firehose-nozzle src/github.com/cloudfoundry-community

cd src/github.com/cloudfoundry-community/splunk-firehose-nozzle


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
