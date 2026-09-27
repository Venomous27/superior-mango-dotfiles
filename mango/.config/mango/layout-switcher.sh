#!/bin/bash

#mmsg dispatch togglefloating

SELECTED=$(cat ~/.config/mango/layout.list | cut -d '|' -f 1 | fzf --layout=reverse)

CMD=$(cat ~/.config/mango/layout.list | grep -e "$SELECTED" | cut -d '|' -f 2)

eval $CMD
