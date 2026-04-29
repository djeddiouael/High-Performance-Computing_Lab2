import os

job_id = os.environ.get("SLURM_JOB_ID", "N/A")
nodename = os.environ.get("SLURMD_NODENAME", "N/A")

print("Hello from the cluster!")
print(f"Job ID : {job_id}")
print(f"Node : {nodename}")