#!/bin/sh

set -eu

REPONAME=$1
PERSONAL_ACCESS_TOKEN=$2
APPS="./APPS"

download() {
  url=$(curl -s https://api.github.com/repos/${1}/releases/latest | jq -r .assets[0].browser_download_url)
  chart=$(echo ${url} | tr "/" " " | awk '{print $NF}')

  # Check if release exists and not already present
  if [ ! "${url}" == "null" ] && [ ! -e "${chart}" ];then
    wget -q ${url}
    echo "${chart}"
  fi
}

publish() {
  echo "Publishing ${1} to https://giantswarm.github.com/${REPONAME}"

  # NOTE: Creation time of all charts updated, since local existing charts take priority
  # Fix this, by deleting (old) checked out charts first
  helm repo index ./ --merge ./index.yaml --url https://giantswarm.github.com/${REPONAME}
  git add ./${1} ./index.yaml
  git commit -m "Auto-commit ${1}"
  git push -q https://${PERSONAL_ACCESS_TOKEN}@github.com/giantswarm/${REPONAME}.git master
  echo "Successfully pushed ${1} to giantswarm/${REPONAME}"
}

# Set up git
git config credential.helper 'cache --timeout=120'
git config user.email "dev@giantswarm.io"
git config user.name "Taylor Bot"
git checkout -f master

IFS=$'\n'       # make newlines the only separator
set -f          # disable globbing
for i in $(cat < "${APPS}"); do
  chart=$(download $i)
  if [ ! -z "${chart}" ]; then
    publish ${chart}
  fi
done
