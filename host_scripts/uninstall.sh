#!/bin/bash

# Directory of currently executed file.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

rm -f "${HOME}/.local/bin/devcont"
rm -f "${HOME}/.local/share/bash-completion/completions/devcont"
