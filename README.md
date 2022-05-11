# Targeted erasing of DNA methylation drives adipogenic reprogramming

This repository provides analyses codes and bioinformatic pipelines for article entitled "Targeted erasing of DNA methylation drives adipogenic reprogramming" (Park et al., *Nature Metabolism*, *in press*).

This repository is organized into several directories:

**wgbs-data-processing**

**wgbs-dmr-analysis**

**rrbs-data-processing**

**gse95533-rnaseq-data-processing**

This directory contains the processing pipeline for RNA-seq processing pipeline.

**motif-analysis**

**pc-hic-data-processing**

This directory contains the processing pipeline for 24 PC-HiC runs (SRR5297630 ~ 53) from SRA study SRP100871 (or GSE95533, Siersbæk et al. 2017). Pipeline is written in `snakemake` so that fetching SRA runs (by `prefetch`), dumping them to fastq files (by `parallel-fastq-dump`), alignment and di-tag post-processing (by `HiCUP`), and identification of significant interactions (by `CHiCAGO`) can be done automatically using single command.

## Citation

