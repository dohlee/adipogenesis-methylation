ASCP_BIN = '/data/home/dohoon/aspera/connect/bin/ascp'
ASCP_KEY = '/data/home/dohoon/aspera/connect/etc/asperaweb_id_dsa.openssh'

rule prefetch_accession:
    output:
        temp('{sample}.sra')
    resources:
        network = 1
    shell:
        f'prefetch --ascp-path "{ASCP_BIN}|{ASCP_KEY}" -v {{wildcards.sample}} --max-size 1000000000 && mv {{wildcards.sample}}/{{wildcards.sample}}.sra . && rm -r {{wildcards.sample}}'

rule parallel_fastq_dump_single:
    input:
        # Required input. Recommend using wildcards for sample names,
        # e.g. {sample,SRR[0-9]+}
        '{sample}.sra'
    output:
        # Required output.
        temp(DATA_DIR / '{sample}.fastq.gz')
    params:
        extra = '--tmpdir .'
    threads: config['threads']['parallel_fastq_dump']
    wrapper:
        'http://dohlee-bio.info:9193/parallel-fastq-dump'
