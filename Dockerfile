# ------------------------------------------------------------------------------
# Set image prefix and Alpine version for base image.
# ------------------------------------------------------------------------------
ARG IMG_PFX
ARG ALP_VER

# ------------------------------------------------------------------------------
# Base image and metadata.
# ------------------------------------------------------------------------------
FROM alpine:$ALP_VER

LABEL maintainer="Papa Lozarou"
LABEL description="A base Alpine Linux docker image for use in projects."
LABEL website="https://github.com/papalozarou/alpine-base"

# ------------------------------------------------------------------------------
# Variables for build are set either in the included ".env" for stand alone 
# usage, or via a project's ".env".
#
# "C_UID", "C_GID", "C_USR" and "C_GRP" must be set to correspond to your host 
# environment to avoid permission errors.
# ------------------------------------------------------------------------------
ARG C_UID
ARG C_GID
ARG C_USR
ARG C_GRP
ARG C_USR_DIR
ARG C_RUN_DIR
ARG C_RUN_USR
ARG C_RUN_UID

# ------------------------------------------------------------------------------
# Update and upgrade Alpine, then create group "$C_GRP", with "$C_GID", and user
# "$C_USR", with "$C_UID".
# ------------------------------------------------------------------------------
RUN apk update && \
    apk -i upgrade && \
    addgroup -g $C_GID $C_GRP && \
    adduser -S -u $C_UID -G $C_GRP $C_USR && \
    chown -R $C_USR:$C_GRP $C_USR_DIR && \
# ------------------------------------------------------------------------------
# Create, chown, and chmod "/run/user/$C_UID" directory.
# ------------------------------------------------------------------------------
    mkdir -p $C_RUN_UID_DIR && \
    chown -R $C_USR:$C_GRP $C_RUN_UID_DIR && \
		chmod 755 $C_RUN_DIR && \
		chmod 755 $C_RUN_USR_DIR && \
    chmod 700 $C_RUN_UID_DIR