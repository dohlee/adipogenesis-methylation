# Targeted erasing of DNA methylation drives adipogenic reprogramming

This repository provides analysis codes and bioinformatic pipelines for article entitled "Targeted erasing of DNA methylation drives adipogenic reprogramming" (Park et al., *Nature Metabolism*, *in press*).

This repository is organized into several directories:

**wgbs-data-processing**

*Related to Fig. 1j-l and Extended Data Fig. 2a,b*

This directory contains the processing pipeline for whole genome bisulfite sequencing (WGBS) data processing pipeline. Given WGBS data, sequencing reads were trimmed using `trim-galore`, aligned to reference genome and deduplicated by `bismark`. Aligned reads were sorted and indexed using `sambamba` and CpG-wise methylation levels were quantified by `MethylDackel`.

**wgbs-dmr-analysis**

*Related to Fig. 1k-l and Fig. 2*

This directory contains the DMR-calling pipeline using [`CpG_MPs`](https://github.com/Kinspact/CpG_MPs).

**gse80961-rrbs-data-processing**

*Related to Fig. 5c.*

This directory contains the processing pipeline for public RRBS data published under GSE80961. (GEO accession GSE80959, SRA study accession SRP074206)
Fetches SRA runs using `prefetch`, dumps them into fastq files using `parallel-fastq-dump`.
Sequencing reads were trimmed using `trim-galore` with `--rrbs` option and aligned to mm10 reference genome by `bismark`.
Aligned reads were sorted and indexed using `sambamba` and CpG-wise methylation levels were quantified by `MethylDackel`.

**gse80961-rnaseq-data-processing**

*Related to Fig. 5d.*

This directory contains the processing pipeline for public RNA-seq data published unser GSE80961 (same project as above, GEO accession GSE80960, SRA study accession SRP074207).
Fetches SRA runs using `prefetch`, dumps them into fastq files using `parallel-fastq-dump`.
Sequencing reads were aligned to mm10 reference genome by `STAR` with GENCODE vM20 mouse gene annotation.
Finally, gene expressions were quantified by `RSEM` based on aligned reads.

**motif-analysis**

*Related to Fig. 2a-c,k-o, Fig. 5c and Extended Data Fig. 2a,b*

This directory contains the processing pipeline for motif enrichment analysis using `HOMER`.

**pc-hic-data-processing**

*Related to Extended Data Fig. 2c*

This directory contains the processing pipeline for 24 PC-HiC runs (SRR5297630 ~ 53) from SRA study SRP100871 (or GSE95533, Siersbæk et al. 2017). Pipeline is written in `snakemake` so that fetching SRA runs (by `prefetch`), dumping them to fastq files (by `parallel-fastq-dump`), alignment and di-tag post-processing (by `HiCUP`), and identification of significant interactions (by `CHiCAGO`) can be done automatically using single command.

## Citation

