#!/bin/bash
#SBATCH --nodes=2
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

nt0=8
nt=16

x0=15000
y0=15000

scale=$(echo "scale=10; sqrt($nt/$nt0)" | bc -l)
x=$(echo "$x0 * $scale" | bc -l | awk '{printf "%d\n", $1}')
y=$(echo "$y0 * $scale" | bc -l | awk '{printf "%d\n", $1}')

start_time=$(date +%s.%N)
srun --ntasks=$nt --cpus-per-task=14 --cpu-bind=cores  ./main -x $x -y $y -p 0 -o 0 -e 300 -v 1 > ../outputs/output_strong_2_node_8taskpernode_14cpupertask.log
end_time=$(date +%s.%N)
tot_time=$(echo "$end_time - $start_time" | bc)
echo "Total_time: ${tot_time}" >> ../outputs/output_strong_2_node_8taskpernode_14cpupertask.log