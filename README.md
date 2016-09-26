# splunk-firehose-nozzle-release

## Dev

Local development

* Install & boot [bosh-lite](https://github.com/cloudfoundry/bosh-lite) 
* Add a [recent stemcell](http://bosh.io/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent) to bosh-lite
```
bosh upload stemcell ~/Desktop/bosh/bosh-stemcell-XXXX.X-warden-boshlite-ubuntu-trusty-go_agent.tgz
```
* Get the [Splunk](https://www.splunk.com/download.html) bits
```
wget http://download.splunk.com/products/splunk/releases/6.4.2/linux/splunk-6.4.2-00f5bb3fa822-Linux-x86_64.tgz \
    -O ~/Downloads/splunk-6.4.2-00f5bb3fa822-linux-x86_64.tgz
bosh add blob ~/Downloads/splunk-6.4.2-00f5bb3fa822-linux-x86_64.tgz splunk_6.4.2
```
* Get the [Golang](https://golang.org/dl/) bits
```
wget https://storage.googleapis.com/golang/go1.6.3.linux-amd64.tar.gz \
    -O ~/Downloads/go1.6.3.linux-amd64.tar.gz
bosh add blob ~/Downloads/go1.6.3.linux-amd64.tar.gz golang
```

* Pull latest submodules, namely `src/splunk-firehose-nozzle`
```
git submodule update --init --recursive
```

* Generate a deployment manifest
    * Copy `./manifest-generator/examples/properties` to `./properties.yml`
    * Customize `./properties.yml` to your environment
    * Generate the manifest ``./scripts/generate-bosh-lite-manifest.sh `bosh status --uuid` properties.yml``

* Iterating
```
git submodule update src/splunk-firehose-nozzle        # If submodule changed upstream
(cd src/splunk-firehose-nozzle; git pull origin HEAD)  # To get new splunk-firehose-nozzle changes
bosh create release --force
bosh upload release dev_releases/cf-splunk/`ls -rt dev_releases/cf-splunk/ | grep "cf" | tail -n1`
bosh deploy --recreate
```

## Creating a Tile
Checkout [tile-generator](https://github.com/cf-platform-eng/tile-generator)
and make sure `tile-generator/bin` is in `$PATH`

```
bosh create release --force --with-tarball
mv dev_releases/cf-splunk/*.tgz tile/resources/
(cd tile; tile build)
```

## jobs

* `splunk-forwarder`: bosh managed Splunk heavy forwarder with HTTP event collector enabled
* `spunk-nozzle`: Nozzle that drains firehose logs & forwards to HEC. Should be co-located with `splunk-forwarder` 
* `client-registrar`: A job that uses a uaa admin to register firehose nozzle credentials, skippable if creating
proper credentials outside of this deployment
* `splunk-full`: bosh managed Splunk search head and indexer. Intended for internal testing only (not 
HA, doesn't persist past rebuilds, etc)

## CI

https://ci.run-01.haas-26.pez.pivotal.io/pipelines/splunk-firehose-tile
