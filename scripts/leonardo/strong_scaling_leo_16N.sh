#!/bin/bash
#SBATCH --nodes=16
#SBATCH --cpus-per-task=14
#SBATCH --ntasks-per-node=8
#SBATCH --mem=0
#SBATCH --partition dcgp_usr_prod
#SBATCH -A uTS25_Tornator_0
#SBATCH -t 00:03:00
#SBATCH --job-name=HPC_Exam
#SBATCH --exclusive
# =======================================================

module load openmpi/4.1.6--gcc--12.2.0

export OMP_PLACES=cores
export OMP_PROC_BIND=close
export OMP_DISPLAY_AFFINITY=TRUE

mpicc -D_XOPEN_SOURCE=700 -o main -march=native -O3 -std=c17 -fopenmp -Iinclude src/stencil_template_parallel.c
srun --ntasks=128 --cpus-per-task=14 --cpu-bind=cores  ./main -x 30000 -y 30000 -p 0 -o 0 -e 300 -v 1 > ../outputs/output_strong_16_node_8taskpernode_14cpupertask.log