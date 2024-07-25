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

# Download | sbt
# https://www.scala-sbt.org/download
printf \
    'Info: Installing the sbt APT software sources list...\n'
if ! echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" \
    | tee /etc/apt/sources.list.d/sbt.list; then
    printf \
        'Error: Unable to install the sbt APT software sources list.\n' \
        1>&2
    exit 2
fi

printf \
    'Info: Installing the sbt_old APT software sources list...\n'
if ! echo "deb https://repo.scala-sbt.org/scalasbt/debian /" \
    | tee /etc/apt/sources.list.d/sbt_old.list; then
    printf \
        'Error: Unable to install the sbt_old APT software sources list.\n' \
        1>&2
    exit 2
fi

printf \
    'Info: Installing the sbt software sources signing public key...\n'
if ! curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" \
    | apt-key add; then
    printf \
        'Error: Unable to install the sbt software sources signing public key.\n' \
        1>&2
    exit 2
fi

printf \
    'Info: Updating the APT software management system local cache...\n'
if ! apt-get update; then
    printf \
        'Error: Unable to update the APT software management system local cache.\n' \
        1>&2
    exit 2
fi

printf \
    'Info: Installing the sbt build tool...\n'
if ! apt-get install -y sbt; then
    printf \
        'Error: Unable to install the sbt build tool.\n' \
        1>&2
    exit 2
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
