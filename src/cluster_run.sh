#!/bin/bash
#SBATCH --job-name=CRISPRroots_pik3ac
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --output=/courses/BINF6430.202510/students/wlodychak.s/final_project/logs/crisprroots_%j.out
#SBATCH --error=/courses/BINF6430.202510/students/wlodychak.s/final_project/logs/crisprroots_%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=wlodychak.s@northeastern.edu

source ~/.bashrc

# Initialize micromamba
export MAMBA_ROOT_PREFIX=/home/wlodychak.s/micromamba
eval "$(micromamba shell hook --shell bash)"
micromamba activate snakemake
module load singularity

# Set working directory
cd /courses/BINF6430.202510/students/wlodychak.s/final_project/data/pik3ca_dataset

# Unlock directory
snakemake -s /courses/BINF6430.202510/students/wlodychak.s/final_project/CRISPRroots-1.3/run.smk --unlock

snakemake -s /courses/BINF6430.202510/students/wlodychak.s/final_project/CRISPRroots-1.3/run.smk \
    --executor slurm \
    --default-resources runtime=1440 mem_mb=32000 threads=8 \
    --jobs 50 \
    --use-singularity \
    --configfile /courses/BINF6430.202510/students/wlodychak.s/final_project/data/pik3ca_dataset/config.homo.yaml \
    --singularity-args "--bind $PWD:$PWD --bind /courses/BINF6430.202510/students/wlodychak.s/final_project:/courses/BINF6430.202510/students/wlodychak.s/final_project" \
    --latency-wait 60 \
    --rerun-incomplete \
    --keep-going
