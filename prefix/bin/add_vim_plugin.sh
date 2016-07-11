#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "usage: $0 <name> <url>"
    exit 1
fi

name=$1
url=$2

git remote add -f $name $url
git merge -s ours --no-commit $name/master
git read-tree --prefix=.vim/bundle/$name -u $name/master
git commit -m "vim: subtree merge $name"
git remote remove $name
