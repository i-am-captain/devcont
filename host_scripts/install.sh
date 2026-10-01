#!/bin/bash

# Directory of currently executed file.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Delete old installs first (plain copies from previous versions, symlinks, ...).
"${SCRIPT_DIR}/uninstall.sh"


mkdir -p "${HOME}/.local/bin/"
ln -s "${SCRIPT_DIR}/devcont" "${HOME}/.local/bin/devcont"

mkdir -p "${HOME}/.local/share/bash-completion/completions/"
ln -s "${SCRIPT_DIR}/autocompletion" "${HOME}/.local/share/bash-completion/completions/devcont"

echo "Symlinked devcont into ~/.local/bin. Restart your shell or run:"
echo "  source \"${HOME}/.local/share/bash-completion/completions/devcont\""