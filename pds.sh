#!/bin/bash

#replace pi@sph in both locations with your username and hostname for the machine you are pushing to

rsync -av --progress  --rsync-path 'sudo -u pihole rsync' -avP /etc/pihole/gravity.db pi@sph:/etc/pihole/
ssh pi@sph ./reload-list.sh
