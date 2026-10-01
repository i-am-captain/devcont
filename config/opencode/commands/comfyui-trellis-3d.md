---
description: Convert an input image to 3D with local ComfyUI Trellis2 + PixAl3D workflow
---

Convert an input image to 3D with the local ComfyUI Trellis2 workflow using $ARGUMENTS.

Parse $ARGUMENTS as: `<input-image.png> [--no-bg-remove] [--out model.glb]`.
The input image is required. If it is missing, ask for it.

Rules:
1. Endpoint: inside devcont use `http://host.containers.internal:8188`, on host use `http://localhost:8188`. Allow override via `COMFYUI_URL` env. Check health first:
   `curl -s $COMFYUI_URL/system_stats | head -c 500`
   If unreachable, tell the user to start it with `comfyui/run_comfy.sh` and stop.
2. Workflow source (UI format):
   `comfyui/user/default/workflows/3d_pixal3d_trellis2_image_to_model.json`
   66 nodes. Key nodes: LoadImage 122 (currently `w (1).png`), RemoveBackground 192 + Switch 248, Trellis2ShapeStage 91, KSamplers 12/18, BakeTextureFromVoxel 147, RenderUVAtlas 261, PaintMesh 252, PreviewImage nodes (Base Color 164, Metallic 207, Roughness 208, Normal 226).
3. For the API you need API-format JSON: open the workflow at `http://localhost:8188`, then Menu > Export (API Format). Save alongside as `3d_pixal3d_trellis2_image_to_model_api.json` if present and prefer it. Patch only the image filename / switch values, never rewrite node IDs.
4. Upload the input first:
   `curl -s -X POST $COMFYUI_URL/upload/image -F "image=@<input-image.png>" -F overwrite=true`
   then set LoadImage node 122 `image` to the returned filename. Set Switch 248 to skip background removal only if `--no-bg-remove` was passed.
5. Required models (mounted in ComfyUI container):
   - unet/pixal3d_int8_convrot.safetensors, unet/trellis_2_bf16.safetensors
   - vae/trellis_2_shape_vae_bf16.safetensors, vae/trellis_2_texture_vae_bf16.safetensors
   - clip_vision/dino_v3_L_naf_fp32.safetensors
   - background_removal/birefnet.safetensors
   - geometry_estimation/moge_2_vitl_normal_fp16.safetensors
   If the API returns "model not found", report the missing file.
6. Queue with `POST $COMFYUI_URL/prompt`, poll `GET $COMFYUI_URL/history/<prompt_id>`, then download the mesh/GLB and texture previews via `GET $COMFYUI_URL/view?...&type=output`. Save into `./outputs/` and report prompt_id plus all saved file paths.
