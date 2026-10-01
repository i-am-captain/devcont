#!/bin/bash

# Directory of currently executed file.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

"${SCRIPT_DIR}"/install_rust.sh
"${SCRIPT_DIR}"/install_vscodium_extensions.sh
"${SCRIPT_DIR}"/install_opencode.sh
