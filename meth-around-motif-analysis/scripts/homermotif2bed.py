import argparse
import cleanlog
import numpy as np
import pandas as pd
import tqdm

from Bio import SeqIO
logger = cleanlog.ColoredLogger(name='homermotif2bed')
logger.setLevel(cleanlog.DEBUG)

def read_bed6(fp):
    return pd.read_csv(fp, sep='\t', names=['chrom', 'start', 'end', 'PositionID', '', 'strand'])

def write_bed6(df, file):
    assert len(df.columns) == 6
    df.to_csv(file, sep='\t', index=False, header=False)

def load_roi(roi_fp):
    """Load BED file of 'Region of Interest'.
    """
    logger.debug('Loading regions of interest.')
    roi_bed = read_bed6(roi_fp)
    return roi_bed

def load_homer_result(homer_result_fp):
    """Homer result denoting motif-containing regions of interest.
    """
    logger.debug('Loading homer result.')
    homer_result_fp = pd.read_csv(homer_result_fp, sep='\t')
    return homer_result_fp

def join_homer_result_and_roi(homer_result_fp, roi_fp):
    logger.debug('Joining homer result and regions of interest.')
    homer_result = load_homer_result(homer_result_fp)
    roi = load_roi(roi_fp)

    # Assert all the position IDs in homer result appear in ROI info.
    for position_id in homer_result.PositionID.values:
        assert position_id in roi.PositionID.values, '%s not in position IDs of ROIs.' % position_id

    return homer_result.merge(roi, how='left', on='PositionID')

def load_genomes(genome_fp):
    logger.debug('Loading genomes...')
    genomes = dict()
    for record in SeqIO.parse(genome_fp, 'fasta'):
        genomes[record.id] = record.seq
    
    return genomes

def get_motif_bed(homer_result_fp, roi_fp, genome_fp):
    homer_result_joined = join_homer_result_and_roi(homer_result_fp, roi_fp)
    genomes = load_genomes(genome_fp)

    motif_intervals = {
        'chrom': [],
        'start': [],
        'end': [],
        'name': [],
        'score': [],
        'strand': [],
    }

    for i, row in tqdm.tqdm(homer_result_joined.iterrows()):
        # Check extracted motif is correct.
        if (row.start + row.end) % 2 == 0 and row.Strand == '+':
            motif_start = int((row.start + row.end) / 2) + row.Offset - 1
        elif (row.start + row.end) % 2 == 0:
            motif_start = int((row.start + row.end) / 2) + row.Offset
        elif (row.start + row.end) % 2 != 0 and row.Strand == '+':
            motif_start = int((row.start + row.end) / 2) + row.Offset
        else:
            motif_start = int((row.start + row.end) / 2) + row.Offset + 1

        if row.Strand == '+':
            motif_start, motif_end = motif_start, motif_start + len(row.Sequence)
            extracted = genomes[row.chrom][motif_start:motif_end].upper()
            assert extracted == row.Sequence, f'Extracted motif and given motif do not match: {extracted} vs {row.Sequence}'
            
        else:
            motif_start, motif_end = motif_start-len(row.Sequence), motif_start
            extracted = genomes[row.chrom][motif_start:motif_end].upper()
            assert extracted == row.Sequence, f'Extracted motif and given motif do not match: {extracted} vs {row.Sequence}'
            
        motif_intervals['chrom'].append(row.chrom)
        motif_intervals['start'].append(motif_start)
        motif_intervals['end'].append(motif_end)
        motif_intervals['name'].append(row['Motif Name'])
        motif_intervals['score'].append(row.MotifScore)
        motif_intervals['strand'].append(row.Strand)
        
    motif_intervals = pd.DataFrame(motif_intervals)
    return motif_intervals

def parse_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--roi', required=True, help='BED file containing information of your region of interest.')
    parser.add_argument('-o', '--output', required=True, help='Output BED file denoting motif intervals.')
    parser.add_argument('-r', '--homer', required=True, help='HOMER result containing motif-containing region.')
    parser.add_argument('-g', '--genome', required=True, help='Reference FASTA file.')
    return parser.parse_args()

if __name__ == '__main__':
    args = parse_arguments()

    motif_intervals = get_motif_bed(args.homer, args.roi, args.genome)
    write_bed6(motif_intervals, args.output)
