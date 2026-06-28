#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

rm -rf package
rm -f package.zip

mkdir package

python -m pip install -r requirements.txt -t package

cp handler.py package/
cp -r ../common package/common

cd package
zip -r ../package.zip .

cd ..