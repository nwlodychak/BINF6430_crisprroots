#!/bin/bash

# Micromamba Env
wget -qO- https://micromamba.snakepit.net/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
micromamba create -n snakemake -c conda-forge -c bioconda snakemake
micromamba activate snakemake


# Singularity Container
module load singularity
#singularity pull docker://gcorsi1993/crisprroots:latest
#singularity exec crisprroots_latest.sif <command>
#singularity run crisprroots_latest.sif
#singularity shell crisprroots_latest.sif



# Grabbing the resources
wget https://rth.dk/resources/crispr/crisprroots/downloads/CRISPRroots-1.3.tar.gz
tar -xzvf CRISPRroots-1.3.tar.gz

wget https://rth.dk/resources/crispr/crisprroots/downloads/CRISPRroots_test_dataset-1.3.tar.gz
tar -xzvf CRISPRroots_test_dataset-1.3.tar.gz


# Resource Folders
TEST_DATA='data/CRISPRroots_test_dataset-1.3/QPRT_DEL268T_chr16_10M-40M'
RESOURCES='CRISPRroots-1.3/resources'
ROOTS='/courses/BINF6430.202510/students/wlodychak.s/final_project/CRISPRroots-1.3'


cd /data/CRISPRroots_test_dataset-1.3
python3 make_config.py --CRISPRroots /courses/BINF6430.202510/students/wlodychak.s/final_project/CRISPRroots-1.3 --singularity /courses/BINF6430.202510/students/wlodychak.s/final_project/crisprroots_latest.sif

snakemake -s /courses/BINF6430.202510/students/wlodychak.s/final_project/CRISPRroots-1.3/run.smk --cores 4 --use-singularity --singularity-args "--bind /courses/BINF6430.202510/students/wlodychak.s/final_project:/courses/BINF6430.202510/students/wlodychak.s/final_project"
