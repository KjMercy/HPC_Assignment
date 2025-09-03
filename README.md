# Parallel Stencil Heat Diffusion Simulation

This project implements a heat diffusion stencil computation using MPI (Message Passing Interface) for distributed-memory parallelism and OpenMP. The domain is decomposed across MPI processes, each managing a subgrid of the global grid, and exchanging boundary data with its neighbors (halo communication).

The program simulates the diffusion of energy over a rectangular plate with configurable size, sources, and periodic boundary conditions.

## Build

Example of build command being in the root of the directory

```bash
mpicc -O3 -fopenmp -o main -Iinclude src/stencil_template_parallel.c -lm
```

## Usage

Run the program using `mpirun`, for example:

```bash
mpirun -np [number of processes] ./main [options]
```

where the available options are:

| Flag | Argument | Default | Description                                |
| ---- | -------- | ------- | ------------------------------------------ |
| `-x` | int      | 10000   | Global grid size in X direction            |
| `-y` | int      | 10000   | Global grid size in Y direction            |
| `-e` | int      | 4       | Number of energy sources                   |
| `-E` | float    | 1.0     | Energy injected per source per iteration   |
| `-n` | int      | 1000    | Number of iterations                       |
| `-p` | 0/1      | 0       | Periodic boundary conditions (1 = enabled) |
| `-o` | 0/1      | 0       | Output energy statistics per step          |
| `-v` | int      | 0       | Verbose level                              |
| `-h` | –        | –       | Print help                                 |

## Debugging

For debugging I used `gdb` (available on linux). 

Example debugging workflow:

```bash
mpicc -o maindebug -Iinclude src/stencil_template_parallel.c -g
mpiexec -np 2 gnome-terminal --wait -- gdb -x ./gdb_commands ./maindebug
```

Note that `gdb_commands` can be as simple as:

```bash
run -n 100 -p 0 -v 1 -e 8 -x 128 -y 256
```

# Credits

- Initial framework and template provided by the professor [Luca Tornatore](https://github.com/lucatornatore)
- All the code used for plotting and animating provided by my colleague Davide Zorzetto