# burnt-pi

This repository contains a [Butane config](https://github.com/coreos/butane), which can be used to quickly and easily bring up a [Pi-Hole](https://pi-hole.net/) machine running on [Fedora CoreOS](https://getfedora.org/coreos).

## Dependencies

### Required

- [CoreOS Installer](https://coreos.github.io/coreos-installer/)
- [Butane](https://coreos.github.io/butane)

### Optional
- [QEMU](https://www.qemu.org/) for validating your config inside a VM.
- [Fedora Media Writer](https://developers.redhat.com/blog/2016/04/26/fedora-media-writer-the-fastest-way-to-create-live-usb-boot-media) for writing the final ISO to boot media.

## Getting Started

### Setup

1. Ensure you have the dependencies installed first.
2. Clone this repo: `git clone https://github.com/cheesesashimi/burnt-pi`.

### Testing / Development

1. Download the latest stable `.qcow2.xz` FCOS image: `$ coreos-installer download --stream stable --platform qemu -f qcow2.xz`.
1. Extract the qcow2 image from the `.xz` archive: `$ xz -d fcos.qcow2.xz`
1. Edit the `pihole-butane.yaml` file to your liking. In particular, you may want to add your public SSH key and change the timezone.
1. Run `run-in-qemu.sh ./fcos.qcow2`. Note: Assuming you've added your SSH key to your Butane config, you can SSH into your QEMU VM by running `$ ssh core@localhost -p 2222`. You can also bring up the Pi-Hole management page by opening `http://localhost:8080` in your web browser.
1. When you shut down your QEMU VM, all state inside will be deleted.

### Installing On A Host

Once the config is set up to your liking, the next step is to prepare a customized boot ISO:

1. Download the latest FCOS `.iso` image: `$ coreos-installer download --stream stable --platform metal -f iso`.
1. Run `prepare-iso.sh ./fcos.iso`.
1. This will create a file called `burnt-pi.iso` which has the rendered Ignition config baked into it.
1. Use your favorite disk image utility to write this ISO to a USB flash drive or memory card (i.e., `$ dd if=burnt-pi.iso of=</dev/sd*> bs=1024k status=progress`, or [Fedora Media Writer](https://developers.redhat.com/blog/2016/04/26/fedora-media-writer-the-fastest-way-to-create-live-usb-boot-media)).
1. Boot your host using the USB flash drive or memory card. The Fedora CoreOS installer will run Ignition against the configuration you've baked into the ISO and then "pivot" into the booted system with Pi-Hole running.

## Notes

- I've only tested this using the FCOS AMD64 image. That said, FCOS has an [officially supported RPi4 image](https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-raspberry-pi4/) that should work as well, modulo a few RPi4-specific configuration tweaks I'm unaware of at the moment.
- Pi-Hole is managed using a systemd service, which runs the official [Docker Pi-Hole](https://github.com/pi-hole/docker-pi-hole) container image in the [Podman container runtime](https://podman.io/).
- The configuration leverages [Podman's ability](https://developers.redhat.com/blog/2019/01/15/podman-managing-containers-pods) to run a [Kubernetes Pod](https://kubernetes.io/docs/concepts/workloads/pods/) locally. This replaces the `docker-compose.yml` file that Docker Pi-Hole uses.
- All of the environment config knobs that Docker Pi-Hole understands can be leveraged by the aforementioned Kubernetes Pod spec, which is inlined into the `pihole-butane.yaml` config.
