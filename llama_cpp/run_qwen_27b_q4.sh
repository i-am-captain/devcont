#!/bin/bash

podman run -v /run/media/user1/data2/ai_models/qwen3.8q4ac/:/models/:z \
    --rm \
    --device=nvidia.com/gpu=all \
    --device=/dev/dri \
    --env=NVIDIA_VISIBLE_DEVICES=all \
    --env=NVIDIA_DRIVER_CAPABILITIES=all \
    --security-opt=label=type:nvidia_container_t \
    --security-opt=label=type:container_runtime_t \
    -p 11434:11434 \
    ghcr.io/ggml-org/llama.cpp:server-cuda \
    -m /models/Qwen3.8-27B-AD-Q4_K_M.gguf \
    --alias "Qwen3.8-27B"\
    --ctx-size 120000 \
    --flash-attn on \
    --cache-type-k q4_0 --cache-type-v q4_0 \
    --spec-type draft-mtp --spec-draft-n-max 3 \
    --temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.0 --presence-penalty 0.0 \
    --jinja \
    --fit on \
    --reasoning-budget 4000 \
    --reasoning-preserve \
    --chat-template-kwargs '{"reasoning_effort": "medium"}' \
    -b 6144 -ub 6144 \
    -np 1 \
    --cont-batching \
    --host 0.0.0.0 --port 11434


    # --mmproj /models/mmproj-Qwen3.8-27B-BF16.gguf \