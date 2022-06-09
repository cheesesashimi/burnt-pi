#!/bin/bash

set -x

source "$PWD/lib.sh"
fcos_iso="$1"
tmpdir="$(mktemp -d)"
ignconfig="$tmpdir/config.ign"

render_butane "${ignconfig}"

coreos-installer iso customize \
  --dest-device /dev/sda \
  --dest-ignition "${ignconfig}" \
  -o "$PWD/burnt-pi.iso" "$fcos_iso"

rm -rf "$tmpdir"
