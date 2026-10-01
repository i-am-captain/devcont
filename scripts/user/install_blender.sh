#!/bin/bash
set -euo pipefail

# Installs the pre-unpacked Blender + official Blender Lab MCP server.
# The blender-unpacker stage in the Containerfile puts the files in place:
#   /opt/blender                          extracted Blender 5.x from blender.org
#   /opt/root_setup/blender-mcp-sources   extracted blender_mcp sources
# Everything is installed system-wide, no user HOME is touched here.
# The per-user MCP add-on is installed by scripts/user/install_blender_addon.sh.

# Blender binary on the PATH.
mkdir -p /home/cuser/.local/bin/
ln -sfn "/home/cuser/user_setup/blender/blender" "/home/cuser/.local/bin/blender"
ls /home/cuser/user_setup
ls /home/cuser/user_setup/blender
ls /home/cuser/user_setup/blender/blender
/home/cuser/user_setup/blender/blender --background --python-expr "import bpy; print('Blender', bpy.app.version_string)"

mkdir -p /home/cuser/.config/blender/5.2/

# export BLENDERMCP_ADDONS_DIR=/path/to/scripts/addons 
uvx mcp-for-blender install-addon

# blender --background --command extension install-file -r user_default -e "${ADDON_ZIP}"
