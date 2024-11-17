#!/usr/bin/env python3
"""
## get_sra.py
## Date: 2024-11-16
## Author: Nick Wlodychak
## This script takes a sample manifest containing SRA ascension numbers and grabs them using parallel-fastq-dump
## We require a column named 'SRA_ID' and 'SRA_NAME' in a csv file
## Upon completion of the download the script will rename the SRA file to the relevent sample ID names
"""


import os
import subprocess
import multiprocessing
import argparse
import pandas as pd


def get_args():
    """
    Parse command line arguments
    :return: parsed args
    """
    parser = argparse.ArgumentParser()
    parser.add_argument('-i',
                        '--input',
                        required = True,
                        help = 'SRA IDs input file with column for SRA ascension number and name to name file')
    parser.add_argument('-o',
                        '--outdir',
                        required = True,
                        help = 'Directory to save FASTQ files')
    return parser.parse_args()


def rename_files(outdir, manifest):
    """
    Rename SRA files according to the project
    :param outdir: Directory to save renamed files
    :param manifest: Dictionary containing the sample names
    """
    for srr, sample_name in manifest.items():
        for suffix in ["_1", "_2"]:
            old_name = f"{srr}{suffix}.fastq.gz"
            new_name = f"{sample_name}_R{suffix[1]}.fastq.gz"
            try:
                os.rename(
                        os.path.join(outdir, old_name),
                        os.path.join(outdir, new_name)
                )
            except FileNotFoundError:
                print(f"No such file {old_name}")


def main():
    """"
    Main function - parses infile for ids and fetches them with fastq-dump
    """
    # Set the CPUS for threads
    cpus = int(os.environ.get('SLURM_CPUS_PER_TASK',
                              multiprocessing.cpu_count()))
    
    # Get SRA text files and process
    args = get_args()
    outdir = os.path.join(args.outdir, 'fastq')
    os.makedirs(outdir, exist_ok = True)
    df = pd.read_csv(args.input)
    sra_dict = dict(zip(df['SRA_ID'], df['SRA_NAME']))
    print(sra_dict)

    # Parse SRA ID numbers
    for sra_id in sra_dict.keys():
        # Download SRA
        #subprocess.call(f"prefetch {sra_id}", shell = True)
        # Convert to FASTQ
        subprocess.call(f"parallel-fastq-dump --sra-id {sra_id} "
                        f"--outdir {outdir} --threads {cpus} --gzip "
                        f"--split-files ", shell = True)

    rename_files(outdir, sra_dict)


if __name__ == "__main__":
    main()
