#!/usr/bin/env bash

set -e

if [ "$0" != "./scripts/build-tile.sh" ]; then
    echo "'build-tile.sh' should be run from repository root"
    exit 1
fi

function usage(){
  >&2 echo "
 Usage:
    $0 version

 Ex:
    $0 42
"
  exit 1
}

if [ "$#" -lt 1 ]; then
    usage
fi

if [ -e "$1" ]; then
    export version=`cat $1`
else
    export version=$1
fi
echo "Building tile for release ${version}"
echo ""

pushd tile

python -c "
import jinja2

with open('tile.yml.jinja2', 'r') as template_file:
    template = template_file.read()
    rendered = jinja2.Template(template).render(version='${version}')
    with open('tile.yml', 'w') as rendered_file:
        rendered_file.write(rendered)

"

popd
