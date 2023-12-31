# ------------------------------------------------------------------------------
# Set image prefix and Alpine version for base image.
#
# N.B.
# For stand alone usage, this file assumes the server was set up using the
# "linux-setup" project to ensure the "$HOST_SUBDOMAIN" linux environment
# variable has been set. If not, replace with the desired image prefix.
# ------------------------------------------------------------------------------
ARG IMG_PFX=$HOST_SUBDOMAIN
ARG ALP_VER=3.19.0

# ------------------------------------------------------------------------------
# Base image and metadata.
# ------------------------------------------------------------------------------
FROM alpine:$ALP_VER

LABEL maintainer="Papa Lozarou"
LABEL description="A base Alpine Linux docker image for use in projects."
LABEL website="https://github.com/papalozarou/alpine-base"

# ------------------------------------------------------------------------------
# Variables for build are set either here or via ".env".
#
# "C_UID" and "C_GID" are set to correspond to your host environment to avoid
# permission errors.
# ------------------------------------------------------------------------------
ARG C_UID=$SUDO_UID
ARG C_GID=$SUDO_GID
ARG C_USR=$SUDO_USER
ARG C_GRP=$C_USR
ARG C_USR_DIR=/home/$SUDO_USER
ARG C_RUN_DIR=/run
ARG C_RUN_USR_DIR=$C_RUN_DIR/user
ARG C_RUN_UID_DIR=$C_RUN_USR_DIR/$C_UID

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