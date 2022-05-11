from os.path import join

RAW_DIR = config['raw_data_dir']

rule trim_galore_pe:
    input:
        join(RAW_DIR, '{sample}.read1.fastq.gz'),
        join(RAW_DIR, '{sample}.read2.fastq.gz'),
    output:
        join(RAW_DIR, '{sample}.read1.trimmed.fastq.gz'),
        join(RAW_DIR, '{sample}.read2.trimmed.fastq.gz'),
    threads: config['threads']['trim_galore']
    params:
        extra = ''
    log:
        'logs/trim_galore/{sample}.log'
    wrapper:
        'http://dohlee-bio.info:9193/trim-galore'

