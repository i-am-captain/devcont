#!/bin/bash

# Directory of currently executed file.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd "${SCRIPT_DIR}"

check_build_image() {
    if podman image exists devenv_comfyui
    then
        echo "devenv_comfyui exists, To create a new one, delete it first."
        return 0
    fi
    echo "Image devenv_comfyui not found, building it."
    # local indexed array
    command=(podman build)

    command+=(-t devenv_comfyui)
    command+=(-f ./Containerfile)
    # use host uid and gid, to make mapped volumes owned by both container and host user
    command+=(--build-arg UID="$(id -u)")
    command+=(--build-arg GID="$(id -g)")
    # context
    command+=(./)

    printf "Command:\n"
    # * expands array into single string, @ expands into separate elements
    printf "${command[*]}\n\n"

    # expand the array and run the whole command
    "${command[@]}"
}

run_container() {

    podman container rm devenv_comfyui

    command=(podman run)

    #command+=("-d")
    command+=("--name=devenv_comfyui")
    command+=("--hostname=devenv_comfyui")
    command+=("--init")
    command+=("--userns=keep-id")
    command+=("--user=cuser")
    command+=("--device=nvidia.com/gpu=all")
    command+=("--security-opt=label=type:container_runtime_t")
    command+=("--env=NVIDIA_VISIBLE_DEVICES=all")
    command+=("--env=NVIDIA_DRIVER_CAPABILITIES=all")

    command+=(-v /run/media/user1/data2/ai_models/comfyui/models/:/home/cuser/comfyui/models/:z )
    # mount the whole user dir, to persist settings
    command+=(-v "${SCRIPT_DIR}/user/:/home/cuser/comfyui/user/:z")
    command+=(-p 8188:8188)
    command+=(devenv_comfyui)
    # optionally add --disable-pinned-memory when vram is low
    command+=(bash -c "/home/cuser/.local/bin/comfyui --lowvram --disable-pinned-memory")


    printf "Command:\n"
    # * expands array into single string, @ expands into separate elements
    printf "${command[*]}\n\n"

    "${command[@]}"
 
}

main() {
    check_build_image
    run_container
}

main
