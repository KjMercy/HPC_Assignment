#SBATCH --nodes=1
#SBATCH --cpus-per-task=128
#SBATCH --ntasks-per-node=1
#SBATCH --mem=0
#SBATCH --partition dcgp_usr_prod
#SBATCH -A uTS25_Tornator_0
#SBATCH -t [00:30:00]
#SBATCH --job-name=test
##SBATCH --exclusive
# =======================================================

module load openmpi/4.1.6--gcc--12.2.0

#TODO: devo vedere come è meglio configurare questi param per leonardo 
export OMP_PLACES=cores
export OMP_PROC_BIND=close
export OMP_DISPLAY_AFFINITY=TRUE

mpicc -D_XOPEN_SOURCE=700 -o main -march=native -O3 -std=c17 -fopenmp -Iinclude src/stencil_template_parallel.c
srun --ntasks=8 --cpus-per-task=16  --cpu-bind=cores  ./main -x 15000 -y 15000 -p 0 -o 0 -e 300 -v 1 > ../outputs/output_strong_1_node_8taskpernode_16cpupertask.log