# splunk-firehose-nozzle-release

```
bosh add blob ~/Downloads/splunk-6.4.2-00f5bb3fa822-linux-x86_64.tgz splunk_6.4.2
```

```
bosh create release --force --with-tarball
mv dev_releases/splunk/*.tgz tile/resources/splunk-bosh-release.tgz
```
