#!/bin/sh
notify-send Work!
for i in {25..1}; do echo Work: $i min; sleep 60; done;

notify-send Break!
for i in {5..1}; do echo Break: $i min; sleep 60; done;

echo "Done!"
while true; do sleep 3600
done
