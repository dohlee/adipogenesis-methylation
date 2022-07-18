# Targeted erasure of DNA methylation by TET3 drives adipogenic reprogramming and differentiation

This repository provides analysis codes and bioinformatic pipelines for article entitled "Targeted erasure of DNA methylation by TET3 drives adipogenic reprogramming and differentiation" (Park et al., *Nature Metabolism*, 2022).

This repository is organized into several directories:

**wgbs-data-processing**

*Related to Fig. 1j-l and Extended Data Fig. 2a,b*

This directory contains the processing pipeline for whole genome bisulfite sequencing (WGBS) data processing pipeline. Given WGBS data, sequencing reads were trimmed using `trim-galore`, aligned to reference genome and deduplicated by `bismark`. Aligned reads were sorted and indexed using `sambamba` and CpG-wise methylation levels were quantified by `MethylDackel`.

**wgbs-dmr-analysis**

*Related to Fig. 1k-l and Fig. 2, Extended Data Fig. 1*

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

**enhancer-definition**

*Related to Fig. 1l, Fig. 2k-o, and Extended Data Fig. 2b,c*

This directory contains the processing pipeline for 3T3-L1 preadiopcyte histone ChIP-seq data (GEO accession GSE21365; Mikkelsen et al., 2010) used for the definition of the enhancer in this study.

**pc-hic-data-processing**

*Related to Fig. 2n,o and Extended Data Fig. 2c*

This directory contains the processing pipeline for 24 PC-HiC runs (SRR5297630 ~ 53) from SRA study SRP100871 (or GSE95533, Siersbæk et al. 2017). Pipeline is written in `snakemake`.
It first fetches SRA runs (by `prefetch`), dumps them to fastq files (by `parallel-fastq-dump`).
Alignment and di-tag post-processing are done by `HiCUP` and identification of significant interactions is by `CHiCAGO`.

## Citation

Park, J., Lee, D. H., Ham, S., Oh, J., Noh, J. R., Lee, Y. K., ... & Kim, J. B. (2022). Targeted erasure of DNA methylation by TET3 drives adipogenic reprogramming and differentiation. Nature Metabolism, 1-14.

```bibtex
@article{park2022targeted,
  title={Targeted erasure of DNA methylation by TET3 drives adipogenic reprogramming and differentiation},
  author={Park, Jeu and Lee, Do Hoon and Ham, Seokjin and Oh, Jiyoung and Noh, Jung-Ran and Lee, Yun Kyung and Park, Yoon Jeong and Lee, Gung and Han, Sang Mun and Han, Ji Seul and others},
  journal={Nature Metabolism},
  pages={1--14},
  year={2022},
  publisher={Nature Publishing Group}
}
```
