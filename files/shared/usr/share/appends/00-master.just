set allow-duplicate-recipes := true
set ignore-comments := true

import "/usr/share/appends/01-system.just"
import "/usr/share/appends/10-apps.just"
import? "/usr/share/appends/99-solarpowered-ex.just"
import? "/usr/share/appends/99-solarpowered.just"
import? "$HOME/.justfile"
import? "$HOME/Justfile"
