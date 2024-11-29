mkdir -p ~/.config/snakemake/slurm
cat > ~/.config/snakemake/slurm/config.yaml << EOF
executor: slurm
jobs: 100
cluster:
  sbatch --partition={resources.partition} \
         --cpus-per-task={threads} \
         --mem={resources.mem_mb} \
         --time={resources.time} \
         --job-name=smk-{rule}-{wildcards} \
         --output=/courses/BINF6430.202510/students/wlodychak.s/final_project/logs/{rule}/{rule}-{wildcards}-%j.out
default-resources:
  - partition=courses
  - mem_mb=32000
  - time="24:00:00"
restart-times: 3
max-jobs-per-second: 1
max-status-checks-per-second: 10
latency-wait: 60
jobs: 100
keep-going: True
rerun-incomplete: True
EOF