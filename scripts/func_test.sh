#!/bin/bash

FOLDERS=("users")
LAMBDAS=("getallusers")
LAMBDAS_DIR="lambdas"

export GOOS="linux"
export GOARCH="amd64"
export CGO_ENABLED="0"

test_lambda() {
  for folder in "${FOLDERS[@]}"; do
    (
      for lambda in "${LAMBDAS[@]}"; do
        (
            aws lambda invoke --function-name SmayliAPI-${lambda} --payload ./events/${lambda}/request/event.json
            echo -e "\n"
            cat ./events/${lambda}/response/event.json
            echo -e "\n"
        )
      done
    )
  done
}

test_lambda
