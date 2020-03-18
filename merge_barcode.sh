#!/bin/bash

infile=$1

if [[ -n "$infile" ]]; then
	echo "$1 is the barcode file."
else
	echo "Argument error.  Supply barcode file and sequencing run as parameters."
fi

mkdir 'MergedFiles'

cat $1 | while read well lane seqfile bc1 bc2; do
	echo $well
  	cat *$seqfile.1.fastq.gz > $PWD/MergedFiles/comb$well.1.fastq.gz
  	cat *$seqfile.2.fastq.gz > $PWD/MergedFiles/comb$well.2.fastq.gz
done

exit 0