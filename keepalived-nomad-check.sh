#!/usr/bin/env bash

# changelog
#
# 20230610.0
# - initial work
#

set -euo pipefail

_nomad_bin="$(which nomad)"
_jq_bin="$(which jq)"

if ! [ -f "${_nomad_bin}" ]; then
  echo "cannot find nomad"
  exit 1
fi
if ! [ -f "${_jq_bin}" ]; then
  echo "cannot find jq"
  exit 1
fi

_eligibility="$("${_nomad_bin}" node status -self -json | jq -rcM ".SchedulingEligibility")"

if [[ "${_eligibility}" == 'eligible' ]]; then
  exit 0
else
  exit 1
fi
