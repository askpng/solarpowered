@default:
    just --list

set shell := ["bash", "-c"]
RCPDIR := "./recipes/images"
CTFS := "./containerfiles"
VERSION := "localbuild"
USRN := "local"
PSWD := "local"

# Build image-name as named in ./recipes/images
build *ARGS:
    #!/usr/bin/env bash
    if [[ -e Containerfile."{{ ARGS }}" ]]; then
        rm Containerfile."{{ ARGS }}"
    fi
    bluebuild generate -o Containerfile."{{ ARGS }}" "{{ RCPDIR }}"/"{{ ARGS }}".yml --skip-validation
    podman build -t "{{ ARGS }}":"{{ VERSION }}" --file Containerfile."{{ ARGS }}" --squash . 2>&1 | tee "{{ RCPDIR }}"/"{{ ARGS }}".log
    rm Containerfile."{{ ARGS }}"
    rm -rf ./.bluebuild-*

# Build a Containerfile stored within ./containerfiles/argument/ with logs
ctf *ARGS:
    podman build -f "{{ CTFS }}"/"{{ ARGS }}"/Containerfile -t "{{ ARGS }}":{{VERSION}} . 2>&1 | tee "{{ CTFS }}"/"{{ ARGS }}"/"{{ ARGS }}".log

# Build, create, and purge archive of image-name as named in ./recipes/images. Slower, but useful for testing recipes cleanly
targz *ARGS:
    bluebuild build --skip-validation -s -c zstd -a ./ "{{ RCPDIR }}"/"{{ ARGS }}".yml
    rm -f ./tmp.tar.gz
    rm -rf ./.bluebuild-scripts_*    

# Save Podman container to a .gz file for inspection
save *ARGS:
    podman save {{ ARGS }}:{{ VERSION }} | gzip > {{ ARGS }}.gz

# Build image-name as named in ./recipes/images and export a VM-ready QCOW2 file in ./qcow2
qcow2 *ARGS: config
    #!/usr/bin/env bash
    set -euo pipefail
    if [[ ! -e {{ RCPDIR }}/{{ ARGS }}.yml ]]; then
        sudo podman build -t "{{ ARGS }}":"{{ VERSION }}" --file {{ CTFS }}/{{ ARGS }}/Containerfile . 2>&1 | tee {{ CTFS }}/{{ ARGS }}/{{ ARGS }}.log
        sudo chown 1000:1000 {{ CTFS }}/{{ ARGS }}/{{ ARGS }}.log
    else
        bluebuild generate -o Containerfile."{{ ARGS }}" "{{ RCPDIR }}"/"{{ ARGS }}".yml
        sudo podman build -t "{{ ARGS }}":"{{ VERSION }}" --file Containerfile."{{ ARGS }}"
    fi
    sudo podman run --rm -it --privileged \
        --pull=newer \
        --security-opt label=type:unconfined_t \
        -v /var/lib/containers/storage:/var/lib/containers/storage \
        -v .:/output \
        -v ./config.toml:/config.toml:ro \
        quay.io/centos-bootc/bootc-image-builder:latest \
        --rootfs btrfs \
        --use-librepo=True \
        --chown 1000:1000 \
        localhost/"{{ ARGS }}":"{{ VERSION }}"
    if [[ ! -e {{ RCPDIR }}/{{ ARGS }}.yml ]]; then
        sudo rm -rf ./.bluebuild*
        rm Containerfile."{{ ARGS }}"
    fi
    sudo rm ./manifest*

# Completely clean user & system-level Podman image registry & ./
scrub:
    #!/usr/bin/env bash
    set -uo pipefail
    rm -rf ./qcow2 ./.bluebuild-scripts_* 
    rm -f ./tmp.tar.gz ./config.toml
    podman rmi -f $(podman images -f "dangling=true" -q)
    sudo rm -f manifest-qcow2.json
    sudo podman rmi -f $(sudo podman images -f "dangling=true" -q)

# Generate bootc-image-builder config
config:
    #!/usr/bin/env bash
    if [[ ! -e ./config.toml ]]; then
        echo "Generating config.toml..."
        cat <<EOF >> ./config.toml
    [[customizations.user]]
    name = "{{ USRN }}"
    password = "{{ PSWD }}"
    groups = ["wheel"]
    EOF
    echo "config.toml generated."
    else
        echo "config.toml already exists."
    fi

# Restore SELinux context to /var/lib/containers in case rootful Podman perms get messed up
restorecon:
    sudo restorecon -R -F /var/lib/containers