from os.path import join

RESULT_DIR = config['result_dir']['sample']
REF_DIR = config['reference']['bismark_dir']
RAW_DIR = config['raw_data_dir']

# FILLME: IMPLEMENT LOGIC TO DETERMINE IF A SAMPLE IS PAIRED-ENDED.
# IF ALL SAMPLE IN YOUR ANALYSIS IS PAIRED-END, JUST RETURN TRUE.
# IF ALL SAMPLE IN YOUR ANALYSIS IS SINGLE-READ, JUST RETURN FALSE.
# **DON'T FORGET TO REMOVE OR COMMENT OUT 'raise ...' AT LAST.**
def is_paired(sample):
    # raise NotImplementedError('function is_paired is not implemented.')
    return True

# FILLME: DEFINE YOUR FUNCTION TO TELL WHETHER THE SAMPLE IS SINGLE-READ OR PAIRED-END.
def get_bismark_inputs(wildcards):
    # raise NotImplementedError('function get_bismark_inputs is not implemented.')
    # EXAMPLE IMPLEMENTATION: IN MOST CASE YOU CAN USE PRE-IMPLEMENTED FUNCTION BELOW.
    sample = wildcards.sample
    if is_paired(sample):
        return dict(
            fastq = [
                join(RAW_DIR, f'{sample}.read1.trimmed.fastq.gz'),
                join(RAW_DIR, f'{sample}.read2.trimmed.fastq.gz'),
            ],
            reference_dir = directory(REF_DIR),
            bisulfite_genome_dir = directory(join(REF_DIR, 'Bisulfite_Genome')),
        )
    else:
       return dict(
            fastq = join(RAW_DIR, 'f{sample}.trimmed.fastq.gz'),
            reference_dir = directory(REF_DIR),
            bisulfite_genome_dir = directory(join(REF_DIR, 'Bisulfite_Genome')),
       )

rule bismark:
    input: unpack(get_bismark_inputs)
    output:
        join(RESULT_DIR, '{sample}.bismark.bam'),
        join(RESULT_DIR, '{sample}.bismark_report.txt'),
    threads: config['threads']['bismark']
    log: 'logs/bismark/{sample}.log'
    wrapper:
       'http://dohlee-bio.info:9193/bismark'

rule bismark_genome_preparation:
    input:
        directory(REF_DIR),
    output:
        directory(join(REF_DIR, 'Bisulfite_Genome')),
    threads: 1  # Multithreading not supported.
    log: 'logs/bismark_genome_preparation.log'
    wrapper:
        'http://dohlee-bio.info:9193/bismark/genome-preparation'

rule deduplicate_bismark:
    input:
        join(RESULT_DIR, '{sample}.bismark.bam'),
    output:
        join(RESULT_DIR, '{sample}.bismark.deduplicated.bam'),
    threads: 1
    params: output_dir = RESULT_DIR
    log: 'logs/deduplicate_bismark/{sample}.log'
    shell:
        'deduplicate_bismark --paired --bam {input} --output_dir {params.output_dir} > {log}'

