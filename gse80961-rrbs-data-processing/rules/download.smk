rule prefetch_accession:
    output:
        temp('{sample}.sra')
    resources: network = 1
    # wrapper:
        # 'http://dohlee-bio.info:9193/sra-tools/prefetch/accession'
    shell:
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-1/{wildcards.sample}/{wildcards.sample}.1 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-2/{wildcards.sample}/{wildcards.sample}.1 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-3/{wildcards.sample}/{wildcards.sample}.1 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-4/{wildcards.sample}/{wildcards.sample}.1 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-5/{wildcards.sample}/{wildcards.sample}.1 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-6/{wildcards.sample}/{wildcards.sample}.1 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-7/{wildcards.sample}/{wildcards.sample}.1 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-8/{wildcards.sample}/{wildcards.sample}.1 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-9/{wildcards.sample}/{wildcards.sample}.1 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-10/{wildcards.sample}/{wildcards.sample}.1 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-1/{wildcards.sample}/{wildcards.sample}.2 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-2/{wildcards.sample}/{wildcards.sample}.2 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-3/{wildcards.sample}/{wildcards.sample}.2 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-4/{wildcards.sample}/{wildcards.sample}.2 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-5/{wildcards.sample}/{wildcards.sample}.2 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-6/{wildcards.sample}/{wildcards.sample}.2 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-7/{wildcards.sample}/{wildcards.sample}.2 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-8/{wildcards.sample}/{wildcards.sample}.2 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-9/{wildcards.sample}/{wildcards.sample}.2 -qO {output} || '
     'wget https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos1/sra-pub-run-10/{wildcards.sample}/{wildcards.sample}.2 -qO {output}'


rule parallel_fastq_dump_single:
    input:
        # Required input. Recommend using wildcards for sample names,
        # e.g. {sample,SRR[0-9]+}
        '{sample}.sra'
    output:
        # Required output.
        temp(DATA_DIR / '{sample}.fastq.gz')
    params:
        extra = ''
    threads: 4
    wrapper:
        'http://dohlee-bio.info:9193/parallel-fastq-dump'

rule parallel_fastq_dump_paired:
    input:
        # Required input. Recommend using wildcards for sample names,
        # e.g. {sample,SRR[0-9]+}
        '{sample}.sra'
    output:
        # Required output.
        temp(DATA_DIR / '{sample}.read1.fastq.gz'),
        temp(DATA_DIR / '{sample}.read2.fastq.gz'),
    params:
        # Optional parameters. Omit if unused.
        extra = '--tmpdir . ',
    threads: 4
    wrapper:
        'http://dohlee-bio.info:9193/parallel-fastq-dump'

