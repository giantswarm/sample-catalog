#!/bin/sh

set -eu

REPONAME=$1
PERSONAL_ACCESS_TOKEN=$2

download() {
  url=$(curl -s https://api.github.com/repos/${1}/releases/latest | jq -r .assets[0].browser_download_url)
  if [[ "$url" == "null" ]];then
    echo "No Release of ${1} exists. Skipping.."
  else
    wget -q ${url}
    chart=$(echo ${url} | tr "/" " " | awk '{print $NF}')
    echo "Downloaded ${chart}"
  fi
}


publish() {
  echo "Publishing ${1} to https://giantswarm.github.com/${REPONAME}"


  # NOTE: Creation time of all charts updated, since local existing charts take priority
  # Fix this, by deleting (old) checked out charts first
  helm repo index ./ --merge ./index.yaml --url https://giantswarm.github.com/${REPONAME}
  git add ./${2} ./index.yaml
  git commit -m "Auto-commit ${1}"
  git push -q https://${PERSONAL_ACCESS_TOKEN}@github.com/giantswarm/${REPONAME}.git master
  echo "Successfully pushed ${1} to giantswarm/${REPONAME}"
}

# Set up git
git config credential.helper 'cache --timeout=120'
git config user.email "dev@giantswarm.io"
git config user.name "Taylor Bot"


git checkout -f master

download giantswarm/kubernetes-test-app
publish giantswarm/kubernetes-test-app
