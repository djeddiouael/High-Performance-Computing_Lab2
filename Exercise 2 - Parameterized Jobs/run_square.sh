#!/bin/bash
#SBATCH --job-name=square
#SBATCH --output=square_%j.out
#SBATCH --time=00:01:00
#SBATCH --cpus-per-task=1

python3 square.py 7