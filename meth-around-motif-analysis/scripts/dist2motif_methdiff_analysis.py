import argparse
import os

import cleanlog
import homermotif2bed
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import pybedtools as pb

import dohlee.plot as plot
plot.set_style()

logger = cleanlog.ColoredLogger()

def try_mkdir(dir):
    """Try to make directory. If already exists, do nothing."""
    if not os.path.exists(dir):
        os.makedirs(dir)

def get_closest_interval_in_b_for_each_a(a_fp, b_fp, constraint_bed_fp=None):
    logger.debug('Getting closest interval in %s for each %s...' % (b_fp, a_fp))
    a = pb.BedTool(a_fp).sort()
    if constraint_bed_fp is None:
        b = pb.BedTool(b_fp).sort()
    else:
        c = pb.BedTool(constraint_bed_fp).sort()
        b = pb.BedTool(b_fp).sort().intersect(c, u=True)
    
    closest = a.closest(b.fn, io=True, d=True)
                                   
    closest_df = pd.read_csv(
        closest.fn,
        names=['chrom', 'start', 'end', 'beta', 'motif_chrom', 'motif_start', 'motif_end', 'distance'],
        sep='\t',
    )

    pb.cleanup()
    return closest_df

def plot_scatter(sample1_motif_distance_data, sample2_motif_distance_data, max_dist, file):
    a, b = sample1_motif_distance_data, sample2_motif_distance_data
    a_subset = a[a.distance <= max_dist]
    b_subset = b[b.distance <= max_dist]

    x = a_subset.distance
    y = a_subset.beta - b_subset.beta

    fig = plt.figure(figsize=(7, 7))
    ax = fig.add_subplot(111)

    ax.scatter(x, y, s=5, alpha=.33)
    ax.axhline(0, ls='--', color='k')

    plt.tight_layout()
    plt.savefig(file, dpi=300)

def plot_binned_boxplot(sample1_motif_distance_data, sample2_motif_distance_data, max_dist):
    pass

def parse_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument('-m', '--motif', required=True, help='Motif information in BED format.')
    parser.add_argument('-1', '--sample1', required=True, help='Per-sample CpG methylation levels in BedGraph.')
    parser.add_argument('-2', '--sample2', required=True, help='Per-sample CpG methylation levels in BedGraph.')
    parser.add_argument('-c', '--constraint', default=None, help='Intervals to constraint occurences of motifs. For example, ChIP-seq peaks of a TF can be used.')
    parser.add_argument('-d', '--max-dist', default=1000, help='Maximum distance from CpG to motif to be visualized.')
    parser.add_argument('-o', '--output-dir', required=True, help='Output directory to write analysis result.')
    parser.add_argument('-v', '--verbose', action='store_true', help='Increase verbosity.')
    return parser.parse_args()

if __name__ == '__main__':
    args = parse_arguments()
    if args.verbose:
        logger.setLevel(cleanlog.DEBUG)

    try_mkdir(args.output_dir)
    sample1_motif_distance_data = get_closest_interval_in_b_for_each_a(args.sample1, args.motif, args.constraint)
    sample2_motif_distance_data = get_closest_interval_in_b_for_each_a(args.sample2, args.motif, args.constraint)

    sample1_motif_distance_data.to_csv(os.path.join(args.output_dir, 's1.tsv'), sep='\t', index=False) 
    sample2_motif_distance_data.to_csv(os.path.join(args.output_dir, 's2.tsv'), sep='\t', index=False) 
    scatter_png = os.path.join(args.output_dir, 'scatter.png')
    plot_scatter(sample1_motif_distance_data, sample2_motif_distance_data, args.max_dist, file=scatter_png)
    # plot_scatter(sample1_motif_distance_data, sample2_motif_distance_data, args.max_dist)
