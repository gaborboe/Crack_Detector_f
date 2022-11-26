#!/usr/bin/bash

#SBATCH --partition=GPUQ
#SBATCH --gres=gpu:A100m40:1
#SBATCH --account=iv-mtp
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=40000
#SBATCH --job-name="yolov7 rdd"
#SBATCH --output=test.out
#SBATCH --mail-user=oleghu@stud.ntnu.no
#SBATCH --mail-type=ALL

WORKDIR=${SLURM_SUBMIT_DIR}

cd ${WORKDIR}
echo "we are running from this directory: $WORKDIR"
echo " the name of the job is: $SLURM_JOB_NAME"
echo "The job ID is $SLURM_JOB_ID"
echo "The job was run on these nodes: $SLURM_JOB_NODELIST"
echo "Number of nodes: $SLURM_JOB_NUM_NODES"
echo "We are using $SLURM_CPUS_ON_NODE cores"
echo "We are using $SLURM_CPUS_ON_NODE cores per node"
echo "Total of $SLURM_NTASKS cores"

# Purge modules
module purge
module load Anaconda3/2020.07


#Deactivate any spill-over environment from the login node
source deactivate &>/dev/null

conda info
source activate condaenv

now=$(date +"%T")
echo "Current time : $now"
echo "Starting script"

# Run training
cd yolov7 && python train.py --img-size 960 --cfg cfg/training/yolov7-tiny.yaml --hyp data/hyp.scratch.custom.yaml --batch 8 --epochs 20 --data data/crack_data.yaml --weights ' ' --workers 24 --name yolo_crack_scratch_det

echo "Script completed"
# Print all system information
uname -a