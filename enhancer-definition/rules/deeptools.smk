rule deeptools_bamcompare:
    input:
        # Required input.
        treatment_bam = RESULT_DIR / '02_bowtie' / '{target}.{timepoint}.sorted.bam',
        control_bam = RESULT_DIR / '02_bowtie' / 'control.sorted.bam',
    output:
        # Required output.
        # Output file format should be one of ['bw', 'bigwig', 'bigWig', 'bedgraph', 'bedGraph'].
        output = RESULT_DIR / '02_bowtie' / '{target}.{timepoint}.bw',
    params:
        # Optional parameters.
        extra = '',
        # Method to use to scale the samples. If a method is specified, then it will be used to
        # compensate for sequencing depth differences between the samples.
        # As an alternative, this can be set to None and an option from
        # -normalizeUsing <method> can be used.
        # Possible choices: readCount, SES, None
        scale_factors_method = 'SES',
        # The default is to output the log2 ratio of the two samples. The reciprocal
        # ratio returns the negative of the inverse of the ratio if the ratio is less
        # than 0. The resulting values are interpreted as negative fold changes.
        # Instead of performing a computation using both files, the scaled signal can
        # alternatively be output for the first or second file using the '--operation first'
        # or '--operation second'.
        # Possible choices: log2, ratio, subtract, add, mean, reciprocal_ratio, first, second
        operation = 'log2',
        # Bin size (default: 50).
        # The smaller the bin size, the bigger the output file will be.
        bin_size = 1,
        # Region of the genome to limit the operation to.
        # e.g. region = 'chr2:10000000-10100000'
        region = '',
        # The effective genome size is the portion of the genome that is mappable.
        # A table of values is available:
        # GRCh37 	2864785220
        # GRCh38 	2913022398
        # GRCm37 	2620345972
        # GRCm38 	2652783500
        # dm3 	162367812
        # dm6 	142573017
        # GRCz10 	1369631918
        # WBcel235 	100286401
        effective_genome_size = 2652783500,
        # Use one of the entered methods to normalize the number
        # of reads per bin. By default, no normalization is perfomred.
        # Available options are:
        # RPKM: Reads Per Kilobase per Million mapped reads.
        # CPM: Counts Per Million mapped reads.
        # BPM: Bins Per Million mapped reads.
        # RPGC: Reads Per Genomic Context (1x normalization).
        # normalize_using = 'BPM',
        # This parameter determines if non-covered regions
        # (regions without overlapping reads) in a BAM file
        # should be skipped.
        skip_non_covered_regions = False,
        # The smooth length defines a window, larger than the binSize,
        # to average the number of reads. For example, if the --binSize is set to 20
        # and the --smoothLength is set to 60, then for each bin, the average of the bin
        # and its left and right neighbors is considered.
        # Any value smaller than --binSize will be ignored and no smoothing will be applied.
        # smooth_length = 5,
        extend_reads = 200,
    threads: 8
    log: 'logs/deeptools_bamcompare/{target}.{timepoint}.log'
    benchmark: 'benchmark/deeptools_bamcompare/{target}.{timepoint}.txt'
    wrapper: 'http://dohlee-bio.info:9193/deeptools/bamcompare'
