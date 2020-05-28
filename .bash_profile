#!/usr/bin/env bash

source /etc/profile

if [[ -f ~/.profile ]]; then
  source ~/.profile
fi

# dottools: add distribution binary directories to PATH
if [ -r "$HOME/.tools-cache/setup-dottools-path.sh" ]; then
  . "$HOME/.tools-cache/setup-dottools-path.sh"
fi
