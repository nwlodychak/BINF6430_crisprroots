#!/bin/bash
#SBATCH --job-name=CRISPRroots_pik3ca    # Job name
#SBATCH --nodes=1                         # Run on one node
#SBATCH --ntasks=1                        # Run a single task
#SBATCH --cpus-per-task=12               # Number of CPU cores
#SBATCH --mem=64G                         # Memory limit
#SBATCH --time=24:00:00                  # Time limit hrs:min:sec
#SBATCH --output=/courses/BINF6430.202510/students/wlodychak.s/final_project/logs/crisprroots_%j.out      # Standard output log
#SBATCH --error=/courses/BINF6430.202510/students/wlodychak.s/final_project/logs/crisprroots_%j.err       # Standard error log
#SBATCH --mail-type=ALL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=wlodychak.s@northeastern.edu # Where to send mail


DATASET='pik3ca_het'

export MAMBA_ROOT_PREFIX=/courses/BINF6430.202510/students/wlodychak.s/final_project/bin/.micromamba
eval "$(/courses/BINF6430.202510/students/wlodychak.s/final_project/bin/.micromamba shell hook --shell bash)"
micromamba activate snakemake
module load singularity


# working directory - change for different datasets
cd /courses/BINF6430.202510/students/wlodychak.s/final_project/data/pik3ca_dataset

# make a cluster config file
cat > cluster_config.yaml << EOF
__default__:
    partition: general
    time: "24:00:00"
    mem: "32G"
    cpus: 4

STAR_align:
    mem: "64G"
    cpus: 12

Mutect2:
    mem: "32G"
    cpus: 4
EOF


snakemake -s /courses/BINF6430.202510/students/wlodychak.s/final_project/CRISPRroots-1.3/run.smk \
    --cores all \
    --use-singularity \
    --singularity-args "--bind $PWD:$PWD --bind /courses/BINF6430.202510/students/wlodychak.s/final_project:/courses/BINF6430.202510/students/wlodychak.s/final_project" \
    --latency-wait 60 \
    --rerun-incomplete \
    --keep-going

# Deactivate environment
micromamba deactivate


# Optional: Send notification when job completes
echo "${DATASET} - CRISPRroots pipeline completed" | mail -s "Pipeline Status" wlodychak.s@northeastern.edu
