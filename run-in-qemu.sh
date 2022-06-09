#!/bin/bash

set -xeuo

source "$PWD/lib.sh";

qcow2_img="$1"
tmpdir="$(mktemp -d)"
ignconfig="$tmpdir/config.ign"
persistent_storage="${tmpdir}/my-fcos-vm.qcow2"
ram_mb="2048"

render_butane "${ignconfig}"

# Create the persistent storage image from the downloaded qcow2 image.
qemu-img create -F qcow2 -f qcow2 -b "${qcow2_img}" "${persistent_storage}";

# Start a new QEMU virtual machine with the downloaded qcow2 image.
qemu-kvm \
  -m "${ram_mb}" \
  -cpu host \
  -nographic \
  -drive if=virtio,file="${persistent_storage}" \
  -fw_cfg name=opt/com.coreos/config,file="${ignconfig}" \
  -nic user,model=virtio,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:80,

rm -rf "${tmpdir}"
