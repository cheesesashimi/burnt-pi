#!/bin/bash

BUTANE_CONFIG="${PWD}/pihole-butane.yaml"
STREAM="stable"

render_butane() {
  ign_config_out="$1"
  butane -d "${PWD}" --pretty --strict "${BUTANE_CONFIG}" > "${ign_config_out}";
}
