#!/usr/bin/env bash

set -eo pipefail

# find $1 -type d
ls $1

# SHA=$(git rev-parse HEAD)

echo "docker file path is ${1}"
cd $1
#
# Build the  image
#

docker build \
  -t "${REPOSITORY_NAME}:${TAG_NAME}" \
  --label "built_at=$(date)" \
  --label "build_actor=${GITHUB_ACTOR}" \
  .

if [ -z "${DOCKERHUB_TOKEN}" ]; then
  # Skip if secrets aren't populated -- they're only visible for actions running in the repo (not on forks)
  echo "Skipping Docker push"
else
  # Login and push
  docker logout
  # docker login --username "${DOCKERHUB_USER}" --password "${DOCKERHUB_TOKEN}"
  echo "${DOCKERHUB_USER}"
  echo "${DOCKERHUB_TOKEN}" | docker login --username "${DOCKERHUB_USER}" --password-stdin
  docker push "${REPOSITORY_NAME}:${TAG_NAME}"
fi
