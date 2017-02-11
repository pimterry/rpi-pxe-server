#!/bin/bash

printf "Starting up"

printf "Setting ethernet ip to 192.168.0.1"
ifconfig eth0 192.168.0.1 netmask 255.255.255.0 up

printf "Setting up tftp share at /data/tftp and samba at /data/public"
mkdir /data/tftp
mkdir /data/public

printf "\n ** Following journalctl logs: **\n\n"
journalctl -f