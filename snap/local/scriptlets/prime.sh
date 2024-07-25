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

printf \
    'Info: Checking the existence of the required commands...\n'
required_commands=(
    snapcraftctl
    install
    ln
    readlink
)
flag_required_command_check_failed=false
for command in "${required_commands[@]}"; do
    if ! command -v "${command}" >/dev/null; then
        flag_required_command_check_failed=true
        printf \
            'Error: This program requires the "%s" command to be available in your command search PATHs.\n' \
            "${command}" \
            1>&2
    fi
done
if test "${flag_required_command_check_failed}" == true; then
    printf \
        'Error: Required command check failed, please check your installation.\n' \
        1>&2
    exit 1
fi

printf \
    'Info: Running the default logic of the prime step...\n'
if ! snapcraftctl prime; then
    printf \
        'Error: Unable to run the default logic of the prime step.\n' \
        1>&2
    exit 2
fi

printf \
    'Info: Configuring the Java interpreter command link...\n'
if ! test -e bin; then
    install_opts=(
        --directory
        --owner root
        --group root
        --mode 0755
        --verbose
    )
    if ! install "${install_opts[@]}" bin; then
        printf \
            'Error: Unable to create the executable directory.\n' \
            1>&2
        exit 2
    fi
fi
ln_opts=(
    --symbolic
    --force
)
if ! ln "${ln_opts[@]}" \
    ../usr/lib/jvm/default-java/bin/java \
    bin/java; then
    printf \
        'Error: Unable to configure the Java interpreter command link.\n' \
        1>&2
    exit 2
fi

printf \
    'Info: Fixing invalid OpenJDK blacklisted.cert links...\n'
if ! shopt -s nullglob; then
    printf \
        'Error: Unable to set the nullglob shell option.\n' \
        1>&2
    exit 2
fi

blacklisted_certs_links=(usr/lib/jvm/java-*-openjdk-*/lib/security/blacklisted.certs)
for link in "${blacklisted_certs_links[@]}"; do
    if ! test -L "${link}"; then
        continue
    fi

    if ! link_target="$(readlink "${link}")"; then
        printf \
            'Error: Unable to determine the link target of "%s" symbolic link.\n' \
            "${link}" \
            1>&2
        exit 2
    fi

    if test "${link_target:0:3}" == ../; then
        # Link is relative path or is already patched
        continue
    fi

    fixed_link_target="${link_target//\/etc/../../../../../../etc}"
    ln_opts=(
        --force
        --symbolic
        --no-target-directory
        --verbose
    )
    if ! ln "${ln_opts[@]}" "${fixed_link_target}" "${link}"; then
        printf \
            'Error: Unable to recreate the "%s" symbolic link.\n' \
            "${link}" \
            1>&2
        exit 2
    fi
done

