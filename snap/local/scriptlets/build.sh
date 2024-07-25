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

printf \
    'Info: Compiling bfg sources...\n'
if ! sbt bfg/compile; then
    printf \
        'Error: Unable to compile the bfg sources.\n' \
        1>&2
    exit 2
fi

printf \
    'Info: Building the bfg JAR archive...\n'
if ! sbt bfg/packageBin; then
    printf \
        'Error: Unable to build the bfg JAR archive.\n' \
        1>&2
    exit 2
fi

printf \
    'Info: Enumerating the built BFG Repo-Cleaner JAR archive...\n'
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
printf \
    'Info: The built BFG Repo-Cleaner JAR archive is determined to be %s.\n' \
    "${jarfile}"

printf \
    'Info: Installing the built BFG Repo-Cleaner JAR archive...\n'
if ! install \
    --mode=0644 \
    "${jarfile}" \
    "${CRAFT_PART_INSTALL}/sbt.jar"; then
    printf \
        'Error: Unable to install the built BFG Repo-Cleaner JAR archive.\n' \
        1>&2
    exit 2
fi
