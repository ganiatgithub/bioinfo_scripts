#!/bin/bash
HOST="220.233.220.69"
USER="GNWC"
PASS="Ye7i973WK"
LDIR="/home/Staff/uqgni1/80-covid19/MPS_BGI/raw-seq"    # can be empty
RDIR=""   # can be empty

cd $LDIR && \                # only start if the cd was successful
wget \
  --continue \               # resume on files that have already been partially transmitted
  --recursive \               # --recursive --level=inf --timestamping --no-remove-listing --mirror
  --no-host-directories \    # don't create 'ftp://src/' folder structure for synced files
  --ftp-user=$USER \
  --ftp-password=$PASS \
    ftp://$HOST/$RDIR
