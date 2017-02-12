#!/bin/bash

printf "\n ** Starting up **\n\n"

printf "Setting ethernet ip to 192.168.0.1\n"
ifconfig eth0 192.168.0.1 netmask 255.255.255.0 up

printf "Setting up tftp share at /data/tftp and samba at /data/public\n"
mkdir -p /data/tftp
mkdir -p /data/public

printf "\n ** Following journalctl logs: **\n\n"
journalctl -f