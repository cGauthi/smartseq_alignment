#!/bin/bash
# Testing for YOGA
fastqc MergedFiles/*

echo "Creating MergedFiles/QC folder."
mkdir "MergedFiles/QC"

echo "Moving Fastqc files to QC folder."
mv MergedFiles/*_fastqc* MergedFiles/QC

echo "Initializing Multiqc"
multiqc -o MergedFiles/QC MergedFiles/QC 

echo "Initializing Salmon alignment"

#for well in A1 A2 A3
#	do salmon quant -i mus_index -l A -1 MergedFiles/comb$well.1.fastq.gz -2 MergedFiles/comb$well.2.fastq.gz --validateMappings -o MergedFiles/transcripts_quant/$well
cat barcode_map.txt | while read well lane seqfile bc1 bc2; do
	salmon quant -i mus_index -l A -1 MergedFiles/comb$well.1.fastq.gz -2 MergedFiles/comb$well.2.fastq.gz --validateMappings --gcBias -o MergedFiles/transcripts_quant/$well
done

echo "Initializing MultiQC on generated alignments."
multiqc MergedFiles/transcripts_quant -o MergedFiles/transcripts_quant

#echo "Generating normalized tpm and fpkm counts."
#mv tpm_fpkm.R MergedFiles/transcripts_quant
#cd MergedFiles/transcripts_quant
#Rscript tpm_fpkm.R $PWD

# Move generated count files to folder tx_counts.
#mkdir 'tx_counts'
#mv annotatedgenes_FPKM.xlsx tx_counts/
#mv annotatedgenes_TPM.xlsx tx_counts/