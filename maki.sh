#!/bin/sh
# Minetest Game repo breakup script by tacotexmex
# Requires hub
# LGPL 2.1

git clone git@github.com:minetest/minetest_game.git
ls -1 minetest_game/mods/ > mods
mkdir minetest_mods
while read -r mod; do
        cp -R minetest_game temp_minetest_game
        cd temp_minetest_game
        git-filter-repo --path mods/mod/ --subdirectory-filter mods/$mod/
        cd ..
        mv temp_minetest_game minetest_mods/$mod
done < mods

while read -r mod; do
        echo "\033[0;32m $mod \033[0m"
        cd minetest_mods/$mod
        hub create minetest-game-mods/$mod --remote-name fork -d "$mod mod from Minetest Game" -h "https://github.com/minetest/minete>
        git remote rm fork
        git remote add fork git@github.com:minetest-game-mods/$mod.git
        git push fork --all --force
        cd ../..
done < mods

rm -rf minetest_game
rm -rf minetest_mods 
rm mods
