function fish_greeting
    fastfetch -c ~/.config/fastfetch/startup.jsonc
    ## atuin
    if grep -q "Arch Linux" /etc/os-release
        atuin init fish | source
    end
end
