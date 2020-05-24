#!/bin/sh
notify-send Work!
for i in {25..1}; do echo $i min; sleep 60; done;

notify-send Break!
for i in {5..1}; do echo $i min; sleep 60; done;

echo "Done!"
