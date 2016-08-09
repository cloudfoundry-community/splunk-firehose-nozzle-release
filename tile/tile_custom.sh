#!/usr/bin/env bash

set -xe

tile build
python tile_fix.py

pushd product
mv metadata/custom.yml metadata/splunk.yml
rm releases/splunk-*.tgz

export filename=`ls *.pivotal`
zip -r custom-${filename} metadata/ migrations/ releases/ content_migrations/
popd
