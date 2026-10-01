#!/bin/bash
set -euo pipefail
 
# Latest stable release tag (api.github "latest" excludes prereleases).
COMFY_TAG="$(curl -sSf https://api.github.com/repos/Comfy-Org/ComfyUI/releases/latest | grep '"tag_name"' | cut -d '"' -f 4)"
echo "Installing ComfyUI ${COMFY_TAG} into /home/cuser/comfyui"
git clone --depth 1 --branch "${COMFY_TAG}" https://github.com/Comfy-Org/ComfyUI.git "/home/cuser/comfyui"

# Slow/flaky CDNs stall uv's parallel downloads, one at a time is slower
# but completes. generous per-request timeout for the big nvidia wheels.
export UV_HTTP_TIMEOUT=600
export UV_CONCURRENT_DOWNLOADS=1
uv venv "/home/cuser/comfyui/venv"
# Current ComfyUI wants cu130 torch on 20-series and newer NVIDIA GPUs.
# Needs a recent host driver; if torch reports no CUDA at runtime,
# update the host NVIDIA driver (the container reuses it via nvidia-ctk).
uv pip install --python "/home/cuser/comfyui/venv/bin/python" torch torchvision --extra-index-url https://download.pytorch.org/whl/cu130
uv pip install --python "/home/cuser/comfyui/venv/bin/python" -r "/home/cuser/comfyui/requirements.txt"

# Launcher on the PATH. Defaults serve the web UI on all interfaces :8188
# (needed so the host browser reaches the container, use devcont's --publish);
# extra args are appended, and argparse lets later args override these defaults.
mkdir -p "/home/cuser/.local/bin"
cat > "/home/cuser/.local/bin/comfyui" <<EOF
#!/bin/bash
exec "/home/cuser/comfyui/venv/bin/python" "/home/cuser/comfyui/main.py" --listen 0.0.0.0 --port 8188 "\$@"
EOF
chmod +x "/home/cuser/.local/bin/comfyui"

# Smoke test (no GPU needed for --help).
"/home/cuser/comfyui/venv/bin/python" "/home/cuser/comfyui/main.py" --help > /dev/null
"/home/cuser/comfyui/venv/bin/python" -c "import torch; print('torch', torch.__version__)"
echo "ComfyUI ${COMFY_TAG} installed."
