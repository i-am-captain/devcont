#!/bin/bash

# Directory of currently executed file.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

codium --install-extension rust-lang.rust-analyzer
codium --install-extension llvm-vs-code-extensions.lldb-dap
codium --install-extension tombi-toml.tombi