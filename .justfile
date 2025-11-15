RCPDIR := "./recipes/images"
VERSION := "local"

build *ARGS:
    #!/usr/bin/env bash
    bluebuild build --skip-validation -s -c zstd -a "{{ RCPDIR }}"/"{{ ARGS }}".yml

make-tar *ARGS:
    #!/usr/bin/env bash
    bluebuild build --skip-validation -s -c zstd -a ./ "{{ RCPDIR }}"/"{{ ARGS }}".yml
    rm -f ./tmp.tar.gz
    rm -rf ./.bluebuild-scripts_*    

qcow2 *ARGS:
    #!/usr/bin/env bash
    set -euo pipefail
    bluebuild generate -o Containerfile."{{ ARGS }}" "{{ RCPDIR }}"/"{{ ARGS }}".yml
    sudo podman build -t "{{ ARGS }}":"{{ VERSION }}" --file Containerfile."{{ ARGS }}" --squash
    sudo podman run --rm -it --privileged \
        --security-opt label=type:unconfined_t \
        -v /var/lib/containers/storage:/var/lib/containers/storage \
        -v .:/output \
        -v ./config.toml:/config.toml:ro \
        quay.io/centos-bootc/bootc-image-builder:latest \
        --rootfs btrfs \
        --use-librepo=True \
        --chown 1000:1000 \
        localhost/"{{ ARGS }}":"{{ VERSION }}"
    sudo rm ./manifest*
    sudo rm -rf ./.bluebuild*
    rm Containerfile."{{ VERSION }}"

scrub:
    #!/usr/bin/env bash
    podman rmi -f $(podman images -f "dangling=true" -q)
    sudo podman rmi -f $(sudo podman images -f "dangling=true" -q)
    rm -rf qcow2