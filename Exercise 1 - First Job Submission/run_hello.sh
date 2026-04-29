#!/bin/bash
#SBATCH --job-name=py_hello
#SBATCH --output=py_hello_%j.out
#SBATCH --time=00:01:00
#SBATCH --cpus-per-task=1

python3 hello_slurm.py