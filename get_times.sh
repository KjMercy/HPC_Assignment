#!/bin/bash

# Output file to save results
output_file="times_overlap_periodic"

# Clear previous output file content
> "$output_file"

np_values=(1 2 3 4)

args="-n 300 -p 1 -v 0 -o 0 -e 300 -x 1000 -y 1000"

for np in "${np_values[@]}"; do
    echo "mpirun -np $np ./main_noplot_overlapping $args" | tee -a "$output_file"
    for i in {1..4}; do
        mpirun -np "$np" ./main_noplot_overlapping $args >> "$output_file" 2>&1
        #echo -e "\n" | tee -a "$output_file"
    done
    echo -e "\n" | tee -a "$output_file"
done

echo "Finished all runs. Output stored in $output_file."
