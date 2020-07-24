#!/bin/bash
while read line
  do export ACCESSION=$line
  bash fq-dump.sh --export=ALL
done < srr.txt
