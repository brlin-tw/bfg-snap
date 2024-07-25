#!/usr/bin/env bash
# Implement the Snapcraft build step with customized logic
#
# Copyright 2024 林博仁(Buo-ren Lin) <buo.ren.lin@gmail.com>
# SPDX-License-Identifier: CC-BY-SA-4.0

set_opts=(
    # Terminate script execution when an unhandled error occurs
    -o errexit
    -o errtrace

    # Terminate script execution when an unset parameter variable is
    # referenced
    -o nounset
)
if ! set "${set_opts[@]}"; then
    printf \
        'Error: Unable to configure the defensive interpreter behaviors.\n' \
        1>&2
    exit 1
fi

if ! trap 'printf "Error: The program has encountered an unhandled error and is prematurely aborted.\\n" 1>&2' ERR; then
    printf \
        'Error: Unable to set the ERR trap.\n' \
        1>&2
    exit 1
fi

if ! sbt compile; then
    printf \
        'Error: Unable to run the "sbt compile" build command.\n' \
        1>&2
    exit 2
fi

if ! sbt bfg/assembly; then
    printf \
        'Error: Unable to run the "sbt bfg/assembly" build command.\n' \
        1>&2
    exit 2
fi

if ! jarfile="$(
    find bfg/target \
        -name '*.jar' \
        | head \
            --lines=1
    )"; then
    printf \
        'Error: Unable to enumerate the built BFG Repo-Cleaner JAR archive.\n' \
        1>&2
    exit 2
fi

if ! install \
    --mode=0644 \
    "${jarfile}" \
    "${CRAFT_PART_INSTALL}/sbt.jar"; then
    printf \
        'Error: Unable to install the built BFG Repo-Cleaner JAR archive.\n' \
        1>&2
    exit 2
fi
