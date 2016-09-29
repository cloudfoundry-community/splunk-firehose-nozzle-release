#!/usr/bin/env bash

set -e

function usage(){
  >&2 echo "
 Usage:
    $0 version

 Ex:
    $0 0+dev.1
"
  exit 1
}

if [ "$#" -lt 1 ]; then
    usage
fi

export version=$1

echo "Building splunk-firhose-nozzle-relese ${version}"
echo ""

if [ "$0" != "./scripts/build-release.sh" ]; then
    echo "'build-release.sh' should be run from repository root"
    exit 1
fi

echo "Cleaning up blobs"
rm -rf .blobs/* blobs/*
echo "--- {} " > config/blobs.yml

echo "Downloading binaries"

mkdir -p tmp

export go_pkg_path=./tmp/go-linux-amd64.tar.gz
export go_version_path=./tmp/go-version.txt
export go_pkg_remote=https://storage.googleapis.com/golang/go1.6.3.linux-amd64.tar.gz

export splunk_pkg_path=./tmp/splunk-linux-x86_64.tgz
export splunk_version_path=./tmp/splunk-version.txt
export splunk_pkg_remote=http://download.splunk.com/products/splunk/releases/6.4.2/linux/splunk-6.4.2-00f5bb3fa822-Linux-x86_64.tgz

if [ -a "${go_pkg_path}" ]; then
    echo "Go package already exist, skipping download"
else
    echo "Go package doesn't exist, downloading"
    wget "${go_pkg_remote}" -O "${go_pkg_path}"
fi
echo "${go_pkg_remote}" > "${go_version_path}"

if [ -a "${splunk_pkg_path}" ]; then
    echo "Splunk package already exist, skipping download"
else
    echo "Splunk pagage doesn't exist, downloading"
    wget "${splunk_pkg_remote}" -O "${splunk_version_path}"
fi
echo "${splunk_pkg_remote}" > "./tmp/splunk-version.txt"

echo "Adding blobs"
bosh add blob "${go_pkg_path}" golang
bosh add blob "${go_version_path}" golang
bosh add blob "${splunk_pkg_path}" splunk
bosh add blob "${splunk_version_path}" splunk

echo "Creating release"
bosh create release --with-tarball --version "${version}" --force
