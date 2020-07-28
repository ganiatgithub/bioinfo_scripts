#!/bin/bash
while read line
  do export SAMPLE=$line
  sbatch test01.sh --export=ALL # export all of the env var #
done < barcodes.txt
