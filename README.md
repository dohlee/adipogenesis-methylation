# Targeted erasing of DNA methylation drives adipogenic reprogramming

This repository provides analysis codes and bioinformatic pipelines for article entitled "Targeted erasing of DNA methylation drives adipogenic reprogramming" (Park et al., *Nature Metabolism*, *in press*).

This repository is organized into several directories:

**wgbs-data-processing**

This directory contains the processing pipeline for whole genome bisulfite sequencing (WGBS) data processing pipeline. Given WGBS data, sequencing reads were trimmed using `trim-galore`, aligned to reference genome and deduplicated by `bismark`. Aligned reads were sorted and indexed using `sambamba` and CpG-wise methylation levels were quantified by `MethylDackel`.

**wgbs-dmr-analysis**

This directory contains the DMR-calling pipeline using [`CpG_MPs`](https://github.com/Kinspact/CpG_MPs).

**rrbs-data-processing**

**gse95533-rnaseq-data-processing**

This directory contains the processing pipeline for RNA-seq processing pipeline.

**motif-enrichment-analysis**

This directory contains the processing pipeline for motif enrichment analysis using `HOMER`.

**pc-hic-data-processing**

This directory contains the processing pipeline for 24 PC-HiC runs (SRR5297630 ~ 53) from SRA study SRP100871 (or GSE95533, Siersbæk et al. 2017). Pipeline is written in `snakemake` so that fetching SRA runs (by `prefetch`), dumping them to fastq files (by `parallel-fastq-dump`), alignment and di-tag post-processing (by `HiCUP`), and identification of significant interactions (by `CHiCAGO`) can be done automatically using single command.

## Citation

