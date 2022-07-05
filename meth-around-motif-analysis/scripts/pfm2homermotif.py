import numpy as np
import argparse

def parse_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input', required=True)
    parser.add_argument('-o', '--output', required=True)
    parser.add_argument('-t', '--threshold', type=int, default=8)
    return parser.parse_args()

if __name__ == '__main__':
    args = parse_arguments()
    
    header = open(args.input).readline().strip()
    name = header.split()[1] 

    tmp = np.loadtxt(args.input, skiprows=1)
    tmp = (tmp / tmp.sum(axis=0)).T

    with open(args.output, 'w') as outFile:
        print('%s\t%s\t%d' % (header, name, args.threshold), file=outFile)

        for values in tmp:
            print('\t'.join(map(lambda x: '%.3f' % x, values)), file=outFile)

