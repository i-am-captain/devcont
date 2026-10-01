#!/bin/bash

# Directory of currently executed file.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

VSCODIUM_URL=$( curl -sSf https://api.github.com/repos/VSCodium/vscodium/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep "x86_64.rpm$" )

echo "${VSCODIUM_URL}"

mkdir -p /tmp

curl --proto '=https' --tlsv1.3 -sSfL -o /tmp/vscodium.rpm "${VSCODIUM_URL}"
curl --proto '=https' --tlsv1.3 -sSfL "${VSCODIUM_URL}.sha256" | cut -d " " -f 1 > /tmp/vscodium.rpm.sha256
echo "$(cat /tmp/vscodium.rpm.sha256) /tmp/vscodium.rpm" | sha256sum --check --status

dnf install -y /tmp/vscodium.rpm
rm /tmp/vscodium.rpm /tmp/vscodium.rpm.sha256
