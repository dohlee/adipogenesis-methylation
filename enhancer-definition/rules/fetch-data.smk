rule prefetch_accession:
    output:
        temp('{run}.sra')
    resources: network = 1
    wrapper:
        'http://dohlee-bio.info:9193/sra-tools/prefetch/accession'

rule parallel_fastq_dump_single:
    input:
        # Required input. Recommend using wildcards for sample names,
        # e.g. {sample,SRR[0-9]+}
        '{run}.sra'
    output:
        # Required output.
        temp(DATA_DIR / '{run}.fastq.gz')
    params:
        extra = ''
    threads: 4
    log: 'logs/parallel_fastq_dump_single/{run}.log'
    wrapper:
        'http://dohlee-bio.info:9193/parallel-fastq-dump'
