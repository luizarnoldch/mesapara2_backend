#!/bin/bash

FOLDERS=("users")
LAMBDAS=("getallusers")
LAMBDAS_DIR="lambdas"
BIN_DIR="../../../bin"

export GOOS="linux"
export GOARCH="amd64"
export CGO_ENABLED="0"

if [ ! -d "$BIN_DIR" ]; then
  mkdir "$BIN_DIR"
fi

build_lambda() {
  for folder in "${FOLDERS[@]}"; do
    (
      for lambda in "${LAMBDAS[@]}"; do
        (
          cd "$LAMBDAS_DIR/$folder/$lambda" || exit
          go build -o bootstrap -tags lambda.norpc
          zip "../../../bin/${lambda}.zip" bootstrap
          rm -rf bootstrap
        )
      done
    )
  done
}

build_lambda
