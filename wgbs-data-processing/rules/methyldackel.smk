from os.path import join

RESULT_DIR = config['result_dir']['sample']
REF_FASTA = config['reference']['fasta']

rule methyldackel_mbias:
    input:
        bam = join(RESULT_DIR, '{sample}.bismark.deduplicated.sorted.bam'),
        bam_index = join(RESULT_DIR, '{sample}.bismark.deduplicated.sorted.bam.bai'),
        reference = REF_FASTA,
    output: join(RESULT_DIR, '{sample}.bismark.deduplicated.sorted.mbias.tsv')
    threads: config['threads']['methyldackel']['mbias']
    params:
        # Optional parameters. Omit if unneeded.
        extra = '',
        mapping_quality_threshold = 10,
        sequencing_quality_threshold = 5,
    log: 'logs/methyldackel_mbias/{sample}.log'
    wrapper:
        'http://dohlee-bio.info:9193/methyldackel/mbias'

rule methyldackel_extract_fraction:
    input:
        bam = join(RESULT_DIR, '{sample}.bismark.deduplicated.sorted.bam'),
        bam_index = join(RESULT_DIR, '{sample}.bismark.deduplicated.sorted.bam.bai'),
        reference = REF_FASTA,
    output:
        # NOTE: {sample}_CpG.meth.bedGraph will use --fraction option,
        # {sample}_CpG.counts.bedGraph will use --counts option, and
        # {sample}_CpG.logit.bedGraph will use --logit option.
        join(RESULT_DIR, '{sample}.bismark.deduplicated.sorted_CpG.meth.bedGraph')
    threads: config['threads']['methyldackel']['extract']
    params:
        # Optional parameters. Omit if unneeded.
        extra = '',
        min_depth = 10,
        mapping_quality_threshold = 10,
        sequencing_quality_threshold = 5,
    log: 'logs/methyldackel_extract/{sample}.log'
    wrapper:
        'http://dohlee-bio.info:9193/methyldackel/extract'

rule methyldackel_extract_counts:
    input:
        bam = join(RESULT_DIR, '{sample}.bismark.deduplicated.sorted.bam'),
        bam_index = join(RESULT_DIR, '{sample}.bismark.deduplicated.sorted.bam.bai'),
        reference = REF_FASTA,
    output:
        # NOTE: {sample}_CpG.meth.bedGraph will use --fraction option,
        # {sample}_CpG.counts.bedGraph will use --counts option, and
        # {sample}_CpG.logit.bedGraph will use --logit option.
        join(RESULT_DIR, '{sample}.bismark.deduplicated.sorted_CpG.counts.bedGraph')
    threads: config['threads']['methyldackel']['extract']
    params:
        # Optional parameters. Omit if unneeded.
        extra = '',
        min_depth = 10,
        mapping_quality_threshold = 10,
        sequencing_quality_threshold = 5,
    log: 'logs/methyldackel_extract/{sample}.log'
    wrapper:
        'http://dohlee-bio.info:9193/methyldackel/extract'

rule methyldackel_extract:
    input:
        bam = join(RESULT_DIR, '{sample}.bismark.deduplicated.sorted.bam'),
        bam_index = join(RESULT_DIR, '{sample}.bismark.deduplicated.sorted.bam.bai'),
        reference = REF_FASTA,
    output:
        # NOTE: {sample}_CpG.meth.bedGraph will use --fraction option,
        # {sample}_CpG.counts.bedGraph will use --counts option, and
        # {sample}_CpG.logit.bedGraph will use --logit option.
        join(RESULT_DIR, '{sample}.bismark.deduplicated.sorted_CpG.bedGraph')
    threads: config['threads']['methyldackel']['extract']
    params:
        # Optional parameters. Omit if unneeded.
        extra = '',
        min_depth = 10,
        mapping_quality_threshold = 10,
        sequencing_quality_threshold = 5,
    log: 'logs/methyldackel_extract/{sample}.log'
    wrapper:
        'http://dohlee-bio.info:9193/methyldackel/extract'

