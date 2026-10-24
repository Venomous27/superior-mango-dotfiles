if status is-interactive

    # ---------------------------
    # PATH
    # ---------------------------
    fzf --fish | source

    # ---------------------------
    # ALIASES & ABBREVIATIONS
    # ---------------------------
    alias tty-clock='tty-clock -c -s -b -C 6'
    alias ff='fastfetch --config ~/.config/fastfetch/current.jsonc'
    alias v='nvim'
    alias s="sudo pacman -S"
    alias ss="pacman -Ss"
    alias r="sudo pacman -Rns"
    alias c="clear"
    alias h="helix"
    alias "sudo h" = sudo helix --config ~/.config/helix/config.toml

end

fish_add_path /home/venom/.cargo/bin
fish_add_path /home/venom/.spicetify

#Alias for backlight
alias on='/usr/local/bin//backlight.sh on'
alias off='/usr/local/bin//backlight.sh off'

thefuck --alias | source
#ff
