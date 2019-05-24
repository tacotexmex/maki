#!/bin/sh
# Minetest Game repo breakup script by tacotexmex
# Requires hub
# LGPL 2.1

git clone https://github.com/minetest/minetest_game
cp -R minetest_game minetest_game_copy
find minetest_game/. -mindepth 1 -maxdepth 1 -not -name mods -not -name .git \
	-exec rm -rf '{}' \;
mv minetest_game/mods/* minetest_game/.
rm -rf minetest_game/mods
find minetest_game -mindepth 1 -maxdepth 1 -not -name '.git*' | cut -c 15- > mods
rm -rf minetest_game

mkdir minetest_mods

while read -r mod; do
	echo "\033[0;32m $mod \033[0m"
	cp -R minetest_game_copy/ minetest_mods/$mod
	cd minetest_mods/$mod
	git filter-branch --tag-name-filter cat --subdirectory-filter mods/$mod/ -- --all
	cd ../..
done < mods

while read -r mod; do
	echo "\033[0;32m $mod \033[0m"
	cd minetest_mods/$mod
	hub create minetest-game-mods/$mod --remote-name fork -d "The $mod mod from Minetest Game" -h "https://github.com/minetest/minetest_game/tree/master/mods/$mod"
	git remote rm fork
	git remote add fork https://github.com/minetest-game-mods/$mod
	git push fork --all --force
	git push fork --tags --force
	cd ../..
done < mods

# rm -rf minetest_mods
# rm -rf minetest_game_copy
# rm mods
