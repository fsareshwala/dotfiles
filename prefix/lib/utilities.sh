#!/usr/bin/env bash

# This file contains various utility functions that are used in other shell scripts

function log_warn() {
  echo "warn: $1"
}

function log_error() {
  echo "error: $1"
  exit
}

function ensure_exists() {
  local program=$1
  command -v "$program" > /dev/null 2>&1 || log_error "$program not available on path"
}

function is_in_git_repo() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    return 0 # true
  fi

  return 1 # false
}

function dirname() {
  local path=$1
  echo "${path%/*}"
}

function basename() {
  local path=$1
  echo "${path##*/}"
}

function get_extension() {
  local filename=$1
  echo "${filename##*.}"
}

function remove_extension() {
  local filename=$1
  echo "${filename%.*}"
}

function at_work() {
  hostname=$(hostname)
  if [[ $hostname == 'fsareshwala-laptop'* ]]; then
    return 0
  elif [[ $hostname == 'fsareshwala-office'* ]]; then
    return 0
  elif [[ $hostname == 'fsareshwala-cloudtop'* ]]; then
    return 0
  else
    return 1
  fi
}

function min() {
  local a=$1
  local b=$2

  if [[ $a -lt $b ]]; then
    echo $a
  elif [[ $b -lt $a ]]; then
    echo $b
  else
    echo $a
  fi
}

function max() {
  local a=$1
  local b=$2

  if [[ $a -gt $b ]]; then
    echo $a
  elif [[ $b -gt $a ]]; then
    echo $b
  else
    echo $a
  fi
}

function trim() {
  echo "$@" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

function pad() {
  local string=$1
  local expected_length=$2
  local padchar=$3

  local actual_length=${#string}
  local num_padchars=$(($expected_length - $actual_length))

  if [[ $num_padchars -le 0 ]]; then
    echo -n "$string"
  else
    for i in $(seq 1 $num_padchars); do
      echo -n "$padchar"
    done

    echo -n "$string"
  fi
}
