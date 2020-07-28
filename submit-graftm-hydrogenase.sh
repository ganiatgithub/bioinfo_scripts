#!/bin/bash
while read line
  do export GENE=$line
  for FILE in /home/Staff/uqgni1/98_hydrogen/MAGs/*.fna.gz
   do export GENOME=${FILE}
   FILENAME=`basename $FILE`
   export NAME=${FILENAME%%.*}
   sbatch graftm-hydrogenase.sh --export=ALL
  done 
done < genes.txt
