#!/usr/bin/env bash
# Implement the Snapcraft prime step with customized logic
#
# Copyright 2024 林博仁(Buo-ren Lin) <buo.ren.lin@gmail.com>
# SPDX-License-Identifier: CC-BY-SA-4.0

printf \
    'Info: Configuring the defensive interpreter behaviors...\n'
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

printf \
    'Info: Setting the ERR trap...\n'
if ! trap 'printf "Error: The program has encountered an unhandled error and is prematurely aborted.\\n" 1>&2' ERR; then
    printf \
        'Error: Unable to set the ERR trap.\n' \
        1>&2
    exit 1
fi

if ! snapcraftctl prime; then
    printf \
        'Error: Unable to run the default logic of the prime step.\n' \
        1>&2
    exit 2
fi

if ! ln \
    --symbolic \
    --force \
    ../usr/lib/jvm/default-java/bin/java \
    bin/java; then
    printf \
        'Error: Unable to configure the Java interpreter command link.\n' \
        1>&2
    exit 2
fi
