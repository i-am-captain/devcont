#!/bin/bash

podman run -v /run/media/user1/data2/ai_models/Qwen3.8-Flash-Next-GGUF/Qwen3.8-Flash-Next-AD-3.84bpw-IQ4_XS-M64/:/models/:z \
    --rm \
    --device=nvidia.com/gpu=all \
    --device=/dev/dri \
    --env=NVIDIA_VISIBLE_DEVICES=all \
    --env=NVIDIA_DRIVER_CAPABILITIES=all \
    --security-opt=label=type:nvidia_container_t \
    --security-opt=label=type:container_runtime_t \
    -p 11434:11434 \
    ghcr.io/ggml-org/llama.cpp:server-cuda \
    -m /models/Qwen3.8-Flash-Next-AD-3.84bpw-IQ4_XS-M64-00001-of-00028.gguf \
    --alias "Qwen3.8-Flash-Next"\
    --ctx-size 120000 \
    --flash-attn on \
    --cache-type-k q8_0 --cache-type-v q8_0 \
    --temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.0 --presence-penalty 0.0 \
    --jinja \
    --fit on \
    --reasoning-budget 4000 \
    --reasoning-preserve \
    --chat-template-kwargs '{"reasoning_effort": "medium"}' \
    -b 512 -ub 512 \
    -np 1 \
    --cont-batching \
    --host 0.0.0.0 --port 11434


    # --mmproj /models/mmproj-Qwen3.8-Flash-Next-BF16.gguf \
    # -ngl 20 \