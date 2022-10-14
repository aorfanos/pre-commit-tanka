#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

if [ -z "$(command -v tk)" ]; then
  echo "Package tanka (tk) is required"
  exit 1
fi

error=0

# tk diff will hang otherwise
export KUBECTL_INTERACTIVE_DIFF=0

for file in "$@"; do
  if ! tk diff --diff-strategy=validate "$file"; then
    error=1
    echo
    echo "Validation failed: $file"
    echo "================================"
  fi
done

unset KUBECTL_INTERACTIVE_DIFF

if [[ $error -ne 0 ]]; then
  exit 1
fi
