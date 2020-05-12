#!/bin/bash

rsync -av --progress  --rsync-path 'sudo -u pihole rsync' -avP /etc/pihole/gravity.db pi@sph:/etc/pihole/
ssh pi@sph ./reload-list.sh
