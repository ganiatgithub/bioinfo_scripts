#!/bin/bash
while read accession
  do mv /home/Staff/uqgni1/tools/gtdbtk/release89/fastani/database/$accession* ./
done < nitrospira_gtdbr89_accession.txt.txt
