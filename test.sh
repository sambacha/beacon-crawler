#!/bin/bash

CRAWL_GIT_REPO="${CRAWL_GIT_REPO:-https://github.com/skylenet/discv4-dns-lists.git}"
CRAWL_GIT_BRANCH="${CRAWL_GIT_BRANCH:-master}"
CRAWL_GIT_PUSH="${CRAWL_GIT_PUSH:-false}"
CRAWL_GIT_USER="${CRAWL_GIT_USER:-crawler}"
CRAWL_GIT_EMAIL="${CRAWL_GIT_EMAIL:-crawler@localhost}"


set -xe

geth_src="$PWD/go-ethereum"

# Function definitions

git_update_repo() {
  upstream=$1
  repodir=$2
  branch=${3:-master}

  if [[ -d $repodir/.git ]]; then
    ( cd "$repodir"; git pull "$upstream"; git checkout "$branch" )
  else
    git clone --depth 1 --branch "$branch" "$upstream" "$repodir"
  fi
}

update_devp2p_tool() {
  git_update_repo https://github.com/ethereum/go-ethereum "$geth_src"
  ( cd "$geth_src" && go build ./cmd/devp2p )
}

# Main execution

git config --global user.email "$CRAWL_GIT_EMAIL"
git config --global user.name "$CRAWL_GIT_USER"
git_update_repo "$CRAWL_GIT_REPO" output "$CRAWL_GIT_BRANCH"

PATH="$geth_src:$PATH"
cd output

# Pull changes from go-ethereum.
update_devp2p_tool && echo "Build ok"