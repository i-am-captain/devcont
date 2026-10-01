#!/bin/bash

# Installs the NVIDIA CUDA toolkit repo + toolkit. Runs as root at build time
# (no sudo: the image build and this script both run as root).

dnf config-manager addrepo --from-repofile https://developer.download.nvidia.com/compute/cuda/repos/fedora44/x86_64/cuda-fedora44.repo
dnf clean all
dnf -y install cuda-toolkit-13-3
dnf clean all