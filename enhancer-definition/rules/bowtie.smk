rule bowtie:
    input:
        index_dir = config['reference']['genome']['bowtie-index'],
        # For single reads,
        #reads = [
        #    '{sample}.fastq.gz',
        #],
        # For paired-end reads,
        reads = [
            RESULT_DIR / '01_concat_fastq' / '{target}.{timepoint}.fastq.gz'
        ]
    output:
        # It automatically sorts the output bam file if its file name ends with '.sorted.bam',
        # e.g.
        # '{sample}.sorted.bam'
        # bam = temp(RESULT_DIR / '02_bowtie' / '{target}.{timepoint}.bam')
        bam = temp(RESULT_DIR / '02_bowtie' / '{target}.{timepoint}.bam')
    params:
        # Additional parameters go here.
        extra = '',
        # Discard mapped reads having mapping quality (MAPQ) below this value.
        mapq_cutoff = 10,
    threads: config['threads']['bowtie']
    benchmark:
        repeat("benchmarks/bowtie/{target}.{timepoint}.tsv", 1)
    log: 'logs/bowtie/{target}.{timepoint}.log'
    wrapper:
        'http://dohlee-bio.info:9193/bowtie'

rule bowtie_control:
    input:
        index_dir = config['reference']['genome']['bowtie-index'],
        # For single reads,
        #reads = [
        #    '{sample}.fastq.gz',
        #],
        # For paired-end reads,
        reads = [
            RESULT_DIR / '01_concat_fastq' / 'control.fastq.gz'
        ]
    output:
        # It automatically sorts the output bam file if its file name ends with '.sorted.bam',
        # e.g.
        # '{sample}.sorted.bam'
        bam = temp(RESULT_DIR / '02_bowtie' / 'control.bam')
    params:
        # Additional parameters go here.
        extra = '',
        # Discard mapped reads having mapping quality (MAPQ) below this value.
        mapq_cutoff = 10,
    threads: config['threads']['bowtie']
    benchmark:
        repeat("benchmarks/bowtie/control.tsv", 1)
    log: 'logs/bowtie/control.log'
    wrapper:
        'http://dohlee-bio.info:9193/bowtie'

from os.path import join

rule bowtie_build:
    input:
        # Required input.
        # Reference genome fasta.
        # e.g.
        # reference = config['reference']['genome']['fasta']
        reference = config['reference']['genome']['fasta']
    output:
        # e.g.
        reference_indices = config['reference']['genome']['bowtie-index']
    params:
        # Additional parameters go here.
        extra = ''
    threads: config['threads']['bowtie_build']
    benchmark:
        repeat("benchmarks/bowtie_build/mm10.tsv", 1)
    log: 'logs/bowtie_build/mm10.log'
    wrapper:
        'http://dohlee-bio.info:9193/bowtie/build'
