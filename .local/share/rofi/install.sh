#!/usr/bin/env bash

if [[ -d "$HOME/.local/share/rofi/themes/rofi-themes-collection" ]]
then
    echo "Updating themes repo"
    git -C $HOME/.local/share/rofi/themes/rofi-themes-collection pull
else
    echo "Cloning themes repo"
    mkdir -p "$HOME/.local/share/rofi/themes/rofi-themes-collection"
    git clone https://github.com/lr-tech/rofi-themes-collection.git $HOME/.local/share/rofi/themes/rofi-themes-collection
fi

cp $HOME/.local/share/rofi/themes/rofi-themes-collection/themes/* $HOME/gFolder/RaZ0rr/dotfiles/.local/share/rofi/themes/ &&
echo "Themes updated"
