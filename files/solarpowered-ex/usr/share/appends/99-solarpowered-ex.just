# AMDPC setup in one go
solarpowered-ex-setup:
     sudo systemctl enable --now  b550-suspend-fix.service
     rpm-ostree kargs \
       --append-if-missing=amd_pstate=active \
       --append-if-missing=$(printf 'amdgpu.ppfeaturemask=0x%x\n' "$(($(cat /sys/module/amdgpu/parameters/ppfeaturemask) | 0x4000))") \
       --append-if-missing="sysrq_always_enabled=1" \
       --append-if-missing="page_alloc.shuffle=1" \
       --append-if-missing="hid_apple.fnmode=0"
     echo 'Remember to reboot!' 
