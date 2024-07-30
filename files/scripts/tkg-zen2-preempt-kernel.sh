#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

echo 'Replace default kernel with tkg-zen2-preempt kernel'
rpm-ostree override replace --experimental --freeze --from repo='copr:copr.fedorainfracloud.org:whitehara:kernel-tkg-zen2-preempt' kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra
