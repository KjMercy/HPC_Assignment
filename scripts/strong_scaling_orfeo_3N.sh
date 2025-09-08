#!/bin/bash
#SBATCH --nodes=3                   # 1 node
#SBATCH --ntasks=24                  # total MPI tasks across nodes
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=16          # OpenMP threads per MPI task
#SBATCH --mem=0                     # use all available memory
#SBATCH --partition=EPYC
#SBATCH -t 00:01:00                 # 5 minutes for profiling and test runs
#SBATCH --job-name=Strong_scaling

# Set OpenMP variables
export OMP_PLACES=cores
export OMP_PROC_BIND=close
export OMP_DISPLAY_AFFINITY=TRUE

# Load MPI module if needed
module load openMPI/5.0.5

mpicc -D_XOPEN_SOURCE=700 -o main -march=native -O3 -std=c17 -fopenmp -Iinclude src/stencil_template_parallel.c
srun --ntasks=24 --cpus-per-task=16  --cpu-bind=cores  ./main -x 15000 -y 15000 -p 0 -o 0 -e 300 -v 1 > ../outputs/output_strong_4_node_8taskpernode_16cpupertask.log