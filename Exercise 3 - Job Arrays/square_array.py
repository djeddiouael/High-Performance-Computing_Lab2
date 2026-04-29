import os

n = int(os.environ.get("SLURM_ARRAY_TASK_ID", 0))
print(f"Task {n}: {n}^2 = {n ** 2}")