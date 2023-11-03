#!/bin/bash
i3_scripts_dir=$HOME/.local/share/i3/scripts
for script in $(ls $i3_scripts_dir); do
    bash -c $script &
done
