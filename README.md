This repository is **deprecated**. The nozzle is now packaged to run as an app rather than a BOSH release. See https://github.com/cloudfoundry-community/splunk-firehose-nozzle

# splunk-firehose-nozzle-release

Bosh-managed deployment of Splunk nozzle for Cloud Foundry firehose along with pre-configured Splunk Forwarder

## Dev

Local development

* Install & boot [bosh-lite](https://github.com/cloudfoundry/bosh-lite) 
* Add a [recent stemcell](http://bosh.io/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent) to bosh-lite
```
bosh upload stemcell ~/Desktop/bosh/bosh-stemcell-XXXX.X-warden-boshlite-ubuntu-trusty-go_agent.tgz
```

* Pull latest submodules, namely `src/splunk-firehose-nozzle`
```
git submodule update --init --recursive
```

* Generate a deployment manifest
    * Copy `./manifest-generation/examples/properties.yml` to `./properties.yml`
    * Customize `./properties.yml` to your environment
    * Generate the manifest ``./scripts/generate-bosh-lite-manifest.sh `bosh status --uuid` properties.yml``

* Create a release

    This will download [Splunk](https://www.splunk.com/download.html) and [Golang](https://golang.org/dl/) binaries (if not available already), add necessary blobs, and create the release:
```
./scripts/build-release.sh
```

* Upload & deploy release
```
bosh upload release
bosh deploy --recreate
```

* Iterating

    If `splunk-firehose-nozzle` submodule changed upstream, pull latest before creating the release with `./scripts/build-release.sh`:
```
git submodule update src/splunk-firehose-nozzle
(cd src/splunk-firehose-nozzle; git pull origin HEAD)
```

## Creating a Tile
Install [tile-generator](https://github.com/cf-platform-eng/tile-generator):
```bash
pip install tile-generator
```

And create the tile:
```bash
bosh create release --force --with-tarball
mv dev_releases/cf-splunk/*.tgz tile/resources/
(cd tile; tile build)
```

## Jobs

* `splunk-forwarder`: bosh managed Splunk heavy forwarder with HTTP event collector enabled
* `spunk-nozzle`: Nozzle that drains firehose logs & forwards to HEC. Should be co-located with `splunk-forwarder` 
* `splunk-full`: bosh managed Splunk search head and indexer. Intended for internal testing only (not 
HA, doesn't persist past rebuilds, etc)

## CI

https://concourse.cfplatformeng.com/teams/splunk/pipelines/splunk-firehose-tile-build

```
fly -t pez2-splunk l -c https://concourse.run-03.haas-71.pez.pivotal.io/ -k -n splunk -u <user> -p <password>
fly -t pez2-splunk sp -c ci/pipeline-build.yml  -p splunk-firehose-tile-build  -l ~/.splunk-private.yml
fly -t pez2-splunk sp -c ci/pipeline-deploy.yml -p splunk-firehose-tile-deploy -l ~/.splunk-private.yml
```
