#!/bin/bash
#SBATCH --job-name=wlodychaks_STAR                                             # Name of the job
#SBATCH --partition=courses                                                  # the account used for computational work
#SBATCH -N 1                                                                # number of nodes
#SBATCH -c 8                                                                # number of cpus-per-task (threads)
#SBATCH --mem 32G                                                           # memory pool for all cores
#SBATCH -t 4:00:00                                                          # time (HH:MM:SS)
#SBATCH --mail-type=END,FAIL                                                # Get an email when the program completes or fails
#SBATCH --mail-user=wlodychak.s@northeastern.edu                             # where to send the email
#SBATCH --out=/courses/BINF6430.202510/students/wlodychak.s/logs/%x_%j.log   # captured stdout
#SBATCH --error=/courses/BINF6430.202510/students/wlodychak.s/logs/%x_%j.err # captured stdin

micromamba activate snakemake

mkdir -p resources/star_index
STAR --runMode genomeGenerate \
     --genomeDir resources/star_index \
     --genomeFastaFiles resources/GRCh38.primary_assembly.genome.fa \
     --sjdbGTFfile resources/gencode.v43.primary_assembly.annotation.gtf \
     --runThreadN ${SLURM_CPUS_PER_TASK}
