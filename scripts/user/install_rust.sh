#!/bin/bash

# Directory of currently executed file.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# install rust unattended with defaults
curl --proto '=https' --tlsv1.3 -sSf https://sh.rustup.rs | sh -s -- -y

# update current session shell, to get cargo command into path
. ~/.profile

# attempt one more rust update
rustup update
rustup component add rust-analyzer
