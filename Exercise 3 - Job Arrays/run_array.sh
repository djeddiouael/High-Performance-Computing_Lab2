#!/bin/bash
#SBATCH --job-name=sq_array
#SBATCH --output=sq_%A_%a.out
#SBATCH --time=00:01:00
#SBATCH --cpus-per-task=1
#SBATCH --array=1-10

python3 square_array.py