if status is-interactive
    set -g fish_greeting

    # ---------------------------
    # PATH
    # ---------------------------
    fzf --fish | source

    # ---------------------------
    # ALIASES & ABBREVIATIONS
    # ---------------------------
    alias ls="ls --color=auto"
    alias tty-clock='tty-clock -c -s -b -C 6'
    alias ff='fastfetch --config ~/.config/fastfetch/current.jsonc'
    alias v='nvim'
    alias s="sudo pacman -S"
    alias ss="pacman -Ss"
    alias r="sudo pacman -Rns"
    alias c="clear"
    alias h="helix"
    alias journal="zeditor ~/Sync/journal && exit"
    alias showkey="wshowkeys -a bottom -t 400 -m 0 -F 'monosapce bold 27'"
end

fish_add_path /home/venom/.cargo/bin
fish_add_path /home/venom/.spicetify

#Alias for backlight
alias on='/usr/local/bin//backlight.sh on'
alias off='/usr/local/bin//backlight.sh off'

#thefuck --alias | source
#ff
