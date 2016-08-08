# splunk-firehose-nozzle-release

```
wget http://download.splunk.com/products/splunk/releases/6.4.2/linux/splunk-6.4.2-00f5bb3fa822-Linux-x86_64.tgz -O ~/Downloads/splunk-6.4.2-00f5bb3fa822-linux-x86_64.tgz
bosh add blob ~/Downloads/splunk-6.4.2-00f5bb3fa822-linux-x86_64.tgz splunk_6.4.2
```

```
bosh create release --force --with-tarball
mv dev_releases/cf-splunk/*.tgz tile/resources/
```

bosh create release --force; bosh upload release dev_releases/cf-splunk/`ls -rt dev_releases/cf-splunk/ | grep "cf" | tail -n1`
bosh deploy --recreate

## jobs

* splunk-forwarder: bosh managed HTTP event collector co-located with a universal forwarder
* splunk-full: bosh managed search head and indexer. Intended for internal testing only (not 
HA and doesn't persist past rebuilds)
