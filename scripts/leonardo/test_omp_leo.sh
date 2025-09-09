#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=112
#SBATCH --ntasks-per-node=1
#SBATCH --mem=0
#SBATCH --partition dcgp_usr_prod
#SBATCH -A uTS25_Tornator_0
#SBATCH -t 00:30:00
#SBATCH --job-name=HPC_Exam
#SBATCH --exclusive
# =======================================================

module load openmpi/4.1.6--gcc--12.2.0


export OMP_PLACES=threads
export OMP_PROC_BIND=close
export OMP_DISPLAY_AFFINITY=TRUE


mpicc -D_XOPEN_SOURCE=700 -march=native -O3 -std=c17 -fopenmp -Iinclude src/stencil_template_parallel.c -o main
mkdir -p ~/outputs

for nt in 1 2 4 8 16 32 64 112
do
    export OMP_NUM_THREADS=$nt
    echo "Running wih $nt threads"
    datetime=$(date +"%Y%m%d_%H%M")
    srun --ntasks=1 --cpus-per-task=$nt ./main -p 1 -o 0 -e 300 -v 1 > ~/outputs/output_${datetime}_1Task_${nt}Threads_.log
done
