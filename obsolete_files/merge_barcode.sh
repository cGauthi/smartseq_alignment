#!/bin/bash

infile=$1
seqrun=$2

if [[ -n "$infile" ]]; then
	echo "$1 is the barcode file."
else
	echo "Argument error.  Supply barcode file and sequencing run as parameters."
fi

if [[ -n "$seqrun" ]]; then
	echo "Sequencing run = $2"
else
	echo "Argument error.  Supply barcode file and sequencing run as parameters."
fi

mkdir 'MergedFiles'

cat $1 | while read plate barcode; do
	echo $plate
  	cat ?_$2.?.$barcode.unmapped.1.fastq.gz > $PWD/MergedFiles/comb$plate.1.fastq.gz
  	cat ?_$2.?.$barcode.unmapped.2.fastq.gz > $PWD/MergedFiles/comb$plate.2.fastq.gz
done

exit 0