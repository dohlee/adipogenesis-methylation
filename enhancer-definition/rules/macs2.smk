rule macs2_filterdup:
    input:
        RESULT_DIR / '02_bowtie' / '{sample}.sorted.bam'
    output:
        temp(RESULT_DIR / '03_filterdup' / '{sample}.sorted.filterdup.bed')
    params:
        # MACS2 filterdup's behavior towards duplicate tags/pairs at the exact
        # same location.
        # 'auto': Calculate the maximum tags at the exact same location based on
        # binomial distribution.
        # integer value: Keep at most that much reads.
        # 'all': Keep all duplicates.
        keep_duplicate = 1,

        # Mappable genome size. (Available preset: hs, mm, ce, dm)
        genome_size = 'mm',

        # Extra options.
        extra = ''
    threads: 1  # Multithreading not supported.
    benchmark:
        repeat('benchmarks/macs2_filterdup/{sample}.tsv', 1)
    log: 'logs/macs2_filterdup/{sample}.log'
    wrapper:
        'http://dohlee-bio.info:9193/macs2/filterdup'


from pathlib import Path
from os.path import splitext

rule macs2_callpeak_narrow:
    input:
        # Required input.
        treatment = RESULT_DIR / '03_filterdup' / '{target}.{timepoint}.sorted.filterdup.bed',
        # Optional input.
        control = RESULT_DIR / '03_filterdup' / 'control.sorted.filterdup.bed',
    output:
        peak = RESULT_DIR / '04_callpeak' / '{target}.{timepoint}_peaks.narrowPeak',
        excel = RESULT_DIR / '04_callpeak' /  '{target}.{timepoint}_peaks.xls',
        summits = RESULT_DIR / '04_callpeak' /  '{target}.{timepoint}_summits.bed',
        model_script = RESULT_DIR / '04_callpeak' / '{target}.{timepoint}_model.r',
    params:
        # Mappable genome size. (Available preset: hs, mm, ce, dm)
        genome_size = 'mm',

        # Call broad peaks?
        broad = False,

        # Optional parameters. Omit if unneeded.

        # Random seed for data downsampling.
        seed = 0,

        # Output as bedGraph format? (-B/--bdg)
        bedGraph_out = True,

        # Cutoff for minimum FDR.
        q_value_cutoff = 0.01,

        # Use cutoff for minimum p-value.
        # p_value_cutoff = 1e-5
        
        # Extra options.
        extra = '',
    threads: 1  # Multithreading not supported.
    benchmark:
        repeat("benchmarks/macs2_callpeak/{target}.{timepoint}.tsv", 1)
    log: 'logs/macs2_callpeak/{target}.{timepoint}.log'
    wrapper:
        'http://dohlee-bio.info:9193/macs2/callpeak'

rule macs2_callpeak_broad:
    input:
        # Required input.
        treatment = RESULT_DIR / '03_filterdup' / '{target}.{timepoint}.sorted.filterdup.bed',
        # Optional input.
        control = RESULT_DIR / '03_filterdup' / 'control.sorted.filterdup.bed',
    output:
        peak = RESULT_DIR / '04_callpeak' / '{target}.{timepoint}_peaks.broadPeak',
        #excel = RESULT_DIR / '04_callpeak' /  '{target}.{timepoint}_peaks.xls',
        #summits = RESULT_DIR / '04_callpeak' /  '{target}.{timepoint}_summits.bed',
        model_script = RESULT_DIR / '04_callpeak' / '{target}.{timepoint}_model.r',
    params:
        # Mappable genome size. (Available preset: hs, mm, ce, dm)
        genome_size = 'mm',

        # Call broad peaks?
        broad = True,

        # Optional parameters. Omit if unneeded.

        # Random seed for data downsampling.
        seed = 0,

        # Output as bedGraph format? (-B/--bdg)
        bedGraph_out = True,

        # Cutoff for minimum FDR.
        q_value_cutoff = 0.01,

        # Use cutoff for minimum p-value.
        # p_value_cutoff = 1e-5
        
        # Extra options.
        extra = '',
    threads: 1  # Multithreading not supported.
    benchmark:
        repeat("benchmarks/macs2_callpeak/{target}.{timepoint}.tsv", 1)
    log: 'logs/macs2_callpeak/{target}.{timepoint}.log'
    wrapper:
        'http://dohlee-bio.info:9193/macs2/callpeak'
