#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
echo 'Replace default kernel with fsync kernel'
rpm-ostree override replace --experimental --freeze --from repo='copr:copr.fedorainfracloud.org:sentry:kernel-fsync' kernel kernel-core kernel-devel kernel-modules kernel-modules-core kernel-modules-extra