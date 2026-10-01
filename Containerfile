# The image used should be the same as the host os
# Otherwise you can get problems with nvidia ctk (container toolkit), since it reuses the drivers
FROM docker.io/library/fedora:44 as fedora_updated

USER root
WORKDIR /opt/root_setup
COPY ./scripts/root /opt/root_setup
RUN ./install_software.sh && ./install_vscodium_rpm.sh

# Unpack the big staged archives up front, so the 366M Blender tarball
# does not end up as a layer in the final image.
FROM docker.io/library/fedora:44 AS blender-unpacker
WORKDIR /unpack
RUN dnf install -y tar gzip xz && dnf clean all
COPY --from=blender_dir blender-5.2.1-linux-x64.tar.xz ./
RUN set -eu; \
    BLENDER_TARBALL="$(ls blender-*-linux-x64.tar.xz | sort -V | tail -1)"; \
    tar -xf "${BLENDER_TARBALL}"; \
    mv "${BLENDER_TARBALL%.tar.xz}" /unpack/blender; \
    rm -f ./*.tar.xz ./*.tar.gz;

# The image used should be the same as the host os
# Otherwise you can get problems with nvidia ctk (container toolkit), since it reuses the drivers
FROM fedora_updated

# more colors in bash
ENV TERM xterm-256color

ARG UID=1000
ARG GID=1000

USER root
WORKDIR /opt/root_setup

# copy scripts one by one, for better layer caching on frequent changes.
COPY ./scripts/root /opt/root_setup
RUN dnf update
RUN ./create_user.sh

USER cuser
WORKDIR /home/cuser

COPY --chown=cuser:cuser ./scripts/user user_setup
RUN ./user_setup/init_user.sh

COPY --chown=cuser:cuser ./config/VSCodium/User /home/cuser/.config/VSCodium/User
COPY --chown=cuser:cuser ./config/opencode/opencode_config.jsonc /home/cuser/.config/opencode/opencode.jsonc
COPY --chown=cuser:cuser ./config/opencode/commands /home/cuser/.config/opencode/commands

COPY --chown=cuser:cuser --from=blender-unpacker /unpack/blender ./user_setup/blender
RUN ./user_setup/install_blender.sh

# At the very last, set the user password. Use dynamic ARG to force cache invalidation.
# The Arg has to be some kind of timestamp, that always changes, to activate the bust.
ARG CACHE_BUST=1
USER root
RUN --mount=type=secret,id=user_password \
    echo "cuser:$(cat /run/secrets/user_password)" | chpasswd \
    echo "Password loaded securely"
USER cuser