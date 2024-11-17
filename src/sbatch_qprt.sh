#!/bin/bash
#SBATCH --job-name=CRISPRroots_qprt
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
cd /courses/BINF6430.202510/students/wlodychak.s/final_project/data/qprt_dataset

# Unlock directory
snakemake -s /courses/BINF6430.202510/students/wlodychak.s/final_project/CRISPRroots-1.3/run.smk --unlock

# Run CRISPRroots
snakemake -s /courses/BINF6430.202510/students/wlodychak.s/final_project/CRISPRroots-1.3/run.smk \
    --cores ${SLURM_CPUS_PER_TASK} \
    --use-singularity \
    --singularity-args "--bind $PWD:$PWD --bind /courses/BINF6430.202510/students/wlodychak.s/final_project:/courses/BINF6430.202510/students/wlodychak.s/final_project" \
    --latency-wait 60 \
    --rerun-incomplete \
    --keep-going \
    --verbose

# Deactivate environment
micromamba deactivate
echo "QPRT - CRISPRroots pipeline completed" | mail -s "Pipeline Status" wlodychak.s@northeastern.edu
