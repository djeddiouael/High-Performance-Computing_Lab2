# HPC Lab 2 – Slurm Job Scheduling

This repository contains the practical work for **Lab 2: High Performance Computing**, Semester 2 (2025–2026), at the University of Boumerdes.

The lab introduces High Performance Computing (HPC) job scheduling, the Slurm workload manager, and the execution of batch jobs in a local multi-node cluster using Docker.

## 🎯 Learning Objectives

- Understand the role of job schedulers in HPC clusters.
- Identify the main concepts and components of Slurm.
- Set up a local Slurm cluster using Docker.
- Write, submit, monitor, and cancel Slurm jobs.
- Pass parameters to Python scripts through job scripts.
- Use Slurm job arrays to execute multiple tasks.
- Inspect job output files and understand Slurm environment variables.

## 🛠️ Technologies

- **Slurm** – Workload and job scheduling
- **Docker** – Containerization
- **Python 3** – Computational scripts
- **Bash** – Job submission scripts
- **GCC / Linux tools** – Development environment
- **Git and GitHub** – Version control

## 📚 Main Concepts

| Concept | Description |
|---|---|
| Cluster | A group of interconnected machines managed together |
| Node | An individual machine in the cluster |
| Job | A script submitted to the scheduler |
| Partition | A group of nodes available for scheduling |
| Resource Allocation | CPUs, memory, and execution time assigned to a job |
| Job Array | A collection of related tasks submitted together |

## 📂 Project Structure

```text
HPC-Lab2/
├── hello_slurm.py       # Basic Slurm environment variables
├── run_hello.sh         # Submit the first Python job
├── square.py            # Parameterized square calculation
├── run_square.sh        # Submit a parameterized job
├── square_array.py      # Square calculation using array task IDs
├── run_array.sh         # Submit a Slurm job array
└── README.md
```

*Note: Adjust the file structure to match the actual contents of your repository.*

## 🐳 Part I – Local Slurm Cluster with Docker

The lab uses the [slurm-docker-cluster](https://github.com/giovtorres/slurm-docker-cluster) project to run a local Slurm environment containing a controller and two compute nodes.

### 1. Install Docker

On Ubuntu or Debian, install the required tools and Docker using the appropriate installation method for your system.

Verify Docker:

```bash
docker --version
```

### 2. Clone the Slurm cluster repository

```bash
git clone https://github.com/giovtorres/slurm-docker-cluster.git
cd slurm-docker-cluster
```

### 3. Build and start the cluster

```bash
make build
make up
```

### 4. Access the Slurm controller

```bash
make shell
```

Check the cluster status:

```bash
sinfo
```

List jobs in the queue:

```bash
squeue -u $USER
```

Stop the cluster when finished:

```bash
make down
```

## ⚙️ Part II – Essential Slurm Commands

### Submit a job

```bash
sbatch run_hello.sh
```

### View your jobs

```bash
squeue -u $USER
```

### Inspect cluster nodes

```bash
sinfo
```

### Cancel a job

```bash
scancel JOB_ID
```

Replace `JOB_ID` with the actual job identifier returned by Slurm.

### Common Job States

| State | Meaning |
|---|---|
| `PD` | Pending – waiting for resources |
| `R` | Running – currently executing |
| `CD` | Completed |
| `CA` | Cancelled |

## 🐍 Part III – First Python Job

The first exercise submits a Python script to Slurm and reads the environment variables provided by the scheduler.

### `hello_slurm.py`

```python
import os

job_id = os.environ.get("SLURM_JOB_ID", "N/A")
nodename = os.environ.get("SLURMD_NODENAME", "N/A")

print("Hello from the cluster!")
print(f"Job ID: {job_id}")
print(f"Node: {nodename}")
```

### `run_hello.sh`

```bash
#!/bin/bash
#SBATCH --job-name=py_hello
#SBATCH --output=py_hello_%j.out
#SBATCH --time=00:01:00
#SBATCH --cpus-per-task=1

python3 hello_slurm.py
```

Submit the job:

```bash
sbatch run_hello.sh
```

Inspect the generated output file:

```bash
cat py_hello_*.out
```

The `%j` placeholder is replaced with the job ID, helping distinguish output files from different job submissions.

## 🔢 Part IV – Parameterized Jobs

Parameterized jobs allow the same Python script to run with different input values.

### `square.py`

```python
import sys

n = int(sys.argv[1])
print(f"{n}^2 = {n ** 2}")
```

### `run_square.sh`

```bash
#!/bin/bash
#SBATCH --job-name=square
#SBATCH --output=square_%j.out
#SBATCH --time=00:01:00
#SBATCH --cpus-per-task=1

python3 square.py 7
```

Submit the job:

```bash
sbatch run_square.sh
```

Example output:

```text
7^2 = 49
```

Change the input argument to test other values, such as `42`, `5`, `10`, and `20`.

Each submission receives its own job ID, and `%j` produces a distinct output filename.

## 🔁 Part V – Slurm Job Arrays

Job arrays allow multiple related tasks to be submitted with a single `sbatch` command.

### `square_array.py`

```python
import os

n = int(os.environ.get("SLURM_ARRAY_TASK_ID", 0))
print(f"Task {n}: {n}^2 = {n ** 2}")
```

### `run_array.sh`

```bash
#!/bin/bash
#SBATCH --job-name=sq_array
#SBATCH --output=sq_%A_%a.out
#SBATCH --time=00:01:00
#SBATCH --cpus-per-task=1
#SBATCH --array=1-10

python3 square_array.py
```

Submit the array:

```bash
sbatch run_array.sh
```

List the generated output files:

```bash
ls sq_*.out
```

Inspect a specific output file:

```bash
cat sq_<ARRAY_JOB_ID>_7.out
```

For task index `7`, the expected output line is:

```text
Task 7: 7^2 = 49
```

### Important Array Variables

| Variable | Description |
|---|---|
| `SLURM_ARRAY_TASK_ID` | Index of the current array task |
| `%A` | Array job ID in the output filename |
| `%a` | Array task index in the output filename |

Job arrays make it easier to run many independent calculations without manually editing and submitting a script for every input value.

## 📊 What This Lab Demonstrates

Through the exercises, this lab demonstrates how to:

- Submit and monitor batch jobs.
- Read job IDs and scheduler environment variables.
- Pass parameters to Python programs.
- Identify pending and running jobs.
- Generate separate output files for multiple submissions.
- Automate repeated calculations using job arrays.
- Manage jobs with Slurm commands.

## 🎓 Academic Information

- **University:** University of Boumerdes
- **Course:** High Performance Computing
- **Semester:** Semester 2 (2025–2026)
- **Lab:** Lab 2
- **Instructor:** Dr. Tayeb BENZENATI
- **Work Type:** Individual practical work

## 👤 Author

**Ouael DJEDDI**

- GitHub: [@djeddiouael](https://github.com/djeddiouael)

## 📄 License

No license has been specified. Add a `LICENSE` file if you intend to distribute this project publicly.
