---
description: Generate an image with local ComfyUI Qwen-Image 2512 workflow
---

Generate an image with the local ComfyUI Qwen-Image 2512 workflow using $ARGUMENTS.

Parse $ARGUMENTS as: `<prompt> [--width N] [--height N] [--seed N] [--turbo true|false] [--out filename.png]`.
Default width=1328 height=1328 turbo=true (4-step Lightning LoRA). If no prompt is given, ask for one.

Rules:
1. Endpoint: inside devcont use `http://host.containers.internal:8188`, on host use `http://localhost:8188`. Allow override via `COMFYUI_URL` env. Check health first:
   `curl -s $COMFYUI_URL/system_stats | head -c 500`
   If unreachable, tell the user to start it with `comfyui/run_comfy.sh` (publishes 8188) and stop.
2. Workflow source (UI format, not directly POSTable):
   `comfyui/user/default/workflows/image_qwen_Image_2512.json`
   It is a subgraph workflow "Text to Image (Qwen-Image 2512)". Inputs: text, width, height, seed, enable_turbo_mode, unet_name, clip_name, vae_name, lora_name.
3. For the API you need API-format JSON: open the workflow in ComfyUI at `http://localhost:8188`, then Menu > Export (API Format). Save alongside as `image_qwen_Image_2512_api.json` if present and prefer it. Never hand-edit node IDs; only patch widget values / inputs.
4. Required models (already mounted in the ComfyUI container from host `/run/media/user1/data2/ai_models/comfyui/models/`):
   - diffusion_models/qwen_image_2512_fp8_e4m3fn.safetensors
   - text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors
   - vae/qwen_image_vae.safetensors
   - loras/Qwen-Image-2512-Lightning-4steps-V1.0-fp32.safetensors
   If the API returns "model not found", report which file is missing instead of guessing.
5. Queue via API:
   `curl -s -X POST $COMFYUI_URL/prompt -H 'Content-Type: application/json' -d @/tmp/qwen_prompt.json`
   with `{"prompt": <api-json with patched prompt/size/seed/turbo>, "client_id": "opencode"}`.
   Then poll `GET $COMFYUI_URL/history/<prompt_id>` until done, then fetch output via `GET $COMFYUI_URL/view?filename=...&subfolder=...&type=output` or copy from the ComfyUI output dir.
6. Save results into the current project (e.g. `./outputs/`) and report prompt_id, seed, size, and file path. Do not commit large PNGs unless asked.
