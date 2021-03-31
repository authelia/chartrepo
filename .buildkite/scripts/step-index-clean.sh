#!/usr/bin/env bash

echo "Cleaning Repository (Index Step)"

rm -rf .cr-release-packages .cr-index
mkdir .cr-release-packages .cr-index

# If gh-pages branch exists, remove it locally.
if [[ ! -z $(git branch --list gh-pages) ]]; then
  git branch --delete --force gh-pages
fi
