#!/usr/bin/env bash
# Implement the Snapcraft pull step with customized logic
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
    'Info: Running the default logic of the pull step...\n'
if ! craftctl default; then
    printf \
        'Error: Unable to run the default logic of the pull step.\n' \
        1>&2
    exit 2
fi

printf \
    'Info: Running the selective-checkout scriptlet...\n'
if ! "${CRAFT_PROJECT_DIR}/snap/local/scriptlets/selective-checkout" \
    --stable-tag-pattern='^[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+$'; then
    printf \
        'Error: Unable to run the selective-checkout scriptlet.\n' \
        1>&2
    exit 2
fi
