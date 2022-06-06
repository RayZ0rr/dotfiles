#!/usr/bin/env sh

if [ -d "$HOME/.local/share/rofi/themes/rofi-themes-collection" ] 
then
	echo "Updating themes repo"
	git -C $HOME/.local/share/rofi/themes/rofi-themes-collection pull
else
	echo "Cloning themes repo"
	git clone https://github.com/lr-tech/rofi-themes-collection.git $HOME/.local/share/rofi/themes
fi

cp $HOME/.local/share/rofi/themes/rofi-themes-collection/themes/* $HOME/gFolder/RaZ0rr/dotfiles/.local/share/rofi/themes/ &&

echo "Themes updated"
