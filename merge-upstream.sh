#!/bin/bash

set -o errexit -o nounset

if [ "$TRAVIS_BRANCH" != "master" ]
then
  echo "This build is started for branch $TRAVIS_BRANCH and not the master! No merge!"
  exit 0
fi

export GIT_COMMITTER_NAME='Travis CI'
export GIT_COMMITTER_EMAIL="travis@liot.io"

remote="https://$GITHUB_SECRET_TOKEN@github.com/$TRAVIS_REPO_SLUG"

git remote add upstream "https://github.com/pfalcon/esp-open-sdk.git"
git fetch upstream

git checkout master
git merge upstream/master

git push "$remote" master
