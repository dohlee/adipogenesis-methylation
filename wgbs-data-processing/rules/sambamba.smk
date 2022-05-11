from os.path import join

RESULT_DIR = config['result_dir']['sample']

rule sambamba_sort:
    input:
        join(RESULT_DIR, '{sample}.bismark.deduplicated.bam')
    output:
        join(RESULT_DIR, '{sample}.bismark.deduplicated.sorted.bam'),
    threads: config['threads']['sambamba']['sort']
    params:
        extra = '' \
        # Approximate total memory limit for all threads [2GB].
        # '-m INT ' \
        # Directory for storing intermediate files.
        '--tmpdir=tmp' \
        # Sort by read name.
        # '-n ' \
        # Compression level for sorted BAM, from 0 to 9.
        # '--compression-leve=COMPRESSION_LEVEL ' \
        # Keep only reads that satisfy FILTER.
        # '--filter=FILTER '
    log: 'logs/sambamba-sort/{sample}.log'
    wrapper:
        'http://dohlee-bio.info:9193/sambamba/sort'

rule sambamba_index:
    input:
        join(RESULT_DIR, '{sample}.bismark.deduplicated.sorted.bam')
    output:
        join(RESULT_DIR, '{sample}.bismark.deduplicated.sorted.bam.bai')
    threads: config['threads']['sambamba']['index']
    log: 'logs/sambamba-index/{sample}.log'
    wrapper:
        'http://dohlee-bio.info:9193/sambamba/index'

