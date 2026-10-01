#!/bin/bash

# Directory of currently executed file.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Create the local user. Same IDs as host user.
echo "Username: cuser, UID: ${UID}, GID: ${GID}"
groupadd -g ${GID} cuser
adduser cuser -u ${UID} -g ${GID} -m -s /bin/bash
usermod -a -G wheel cuser

# Container is rootless, but still, don't directly log in into root user
passwd -l root
