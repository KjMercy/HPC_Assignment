#!/bin/bash
#SBATCH --nodes=1                   # 1 node
#SBATCH --ntasks=6                  # total MPI tasks across nodes
#SBATCH --ntasks-per-node=6
#SBATCH --cpus-per-task=8          # OpenMP threads per MPI task
#SBATCH --mem=0                     # use all available memory
#SBATCH --partition=EPYC
#SBATCH -t 00:00:20                 # 5 minutes for profiling and test runs
#SBATCH --job-name=testing

# Set OpenMP variables
export OMP_NUM_THREADS=8
export OMP_PLACES=cores
export OMP_PROC_BIND=close
export OMP_DISPLAY_AFFINITY=TRUE

# Load MPI module if needed
module load openMPI/5.0.5

# Qui ci va mpicc, mpirun etc
mpicc -o main_omp_plot -march=native -O3 -std=c17 -fopenmp -Iinclude src/stencil_template_parallel.c
mpirun -np 6 --map-by core --bind-to core main_omp_plot -x 384 -y 256 -n 400 -e 50 -p 1 -v 1 > output.log
