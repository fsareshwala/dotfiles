#!/usr/bin/env bash

# This file contains various utility functions that are used in other shell scripts

function log_warn() {
    echo "warn: $1"
}

function log_error() {
    echo "error: $1"
    exit
}

function trim() {
  echo "$@" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

function pad() {
  local string=$1
  local expected_length=$2
  local padchar=$3

  local actual_length=${#string}
  local num_padchars=$[$expected_length - $actual_length]

  if [[ $num_padchars -le 0 ]]; then
    echo -n $string
  else
    for i in $(seq 1 $num_padchars); do
      echo -n $padchar
    done

    echo -n $string
  fi
}
