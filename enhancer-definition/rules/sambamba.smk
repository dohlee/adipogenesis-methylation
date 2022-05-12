rule sambamba_sort:
    input:
        RESULT_DIR / '02_bowtie' / '{sample}.bam'
    output:
        RESULT_DIR / '02_bowtie' / '{sample}.sorted.bam'
    threads: config['threads']['sambamba']['sort']
    log: 'logs/sambamba_sort/{sample}.log'
    params:
        extra = '' \
        # Approximate total memory limit for all threads [2GB].
        # '-m INT ' \
        # Directory for storing intermediate files.
        # '--tmpdir=TMPDIR ' \
        # Sort by read name.
        # '-n ' \
        # Compression level for sorted BAM, from 0 to 9.
        # '--compression-leve=COMPRESSION_LEVEL ' \
        # Keep only reads that satisfy FILTER.
        # '--filter=FILTER '
    wrapper:
        'http://dohlee-bio.info:9193/sambamba/sort'

rule sambamba_index:
    input:
        RESULT_DIR / '02_bowtie' / '{sample}.sorted.bam'
    output:
        RESULT_DIR / '02_bowtie' / '{sample}.sorted.bam.bai'
    threads: config['threads']['sambamba']['index']
    log: 'logs/sambamba_index/{sample}.log'
    wrapper:
        'http://dohlee-bio.info:9193/sambamba/index'
