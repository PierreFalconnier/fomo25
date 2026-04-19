#!/bin/bash

# Following nn-unet like structure
in_data=/home/jaume/Desktop/Code/BrainFM4Challenges/nnUNet_raw/Dataset002_MPRAGE
out_data=/home/jaume/Desktop/Code/BrainFM4Challenges/fomo25_preprocessed/Dataset002_MPRAGE
out_data=/home/jaume/Desktop/Code/BrainFM4Challenges/fomo25_results/Dataset002_MPRAGE

# For pre-training data
code_path='/home/jaume/Desktop/Code/fomo25/src'

# Parameters - model
model_name="mmunetvae"
data_path='/media/jaume/T71'
# data_path='/data/bdip2/jbanusco/fomo25'
src_data=${data_path}/FOMO-MRI
save_dir_test=${src_data}/model_test_jaume_6  # Directory to save pretraining outputs  model_test_jaume_6/model_test_jaume_upload
pretrained_model=${save_dir_test}/models/FOMO60k/${model_name}/versions/version_0/epoch=99.ckpt
# pretrained_model=${save_dir_test}/models/FOMO60k/${model_name}/versions/version_0/last.ckpt

# Hyperparameters
epochs=100
patch_size=64
batch_size=4
learning_rate=1e-4
num_devices=1
num_workers=1
split_method="kfold"
split_param=5 # Number of folds
epochs=100
augmentation_preset="none"
experiment="test_segmentation"  # Weights & Biases experiment name    
path_splits=${data_path}/data/splits_final/task1/splits_final_no_test.json

echo "----------------------------------------------------------------"
echo "Starting: Task ${task_id} | Fold ${fold_idx}/${split_param} | Epochs ${task_epochs}"
echo "Experiment: ${task_experiment}"
echo "----------------------------------------------------------------"

python "${src_path}/finetune.py" \
    --save_dir "${save_dir_test}" \
    --data_dir "${fine_tune_data}" \
    --model_name "${model_name}" \
    --epochs "${task_epochs}" \
    --patch_size "${patch_size}" \
    --batch_size "${batch_size}" \
    --learning_rate "${learning_rate}" \
    --num_devices "${num_devices}" \
    --num_workers "${num_workers}" \
    --augmentation_preset "${augmentation}" \
    --experiment "${task_experiment}" \
    --pretrained_weights_path "${pretrained_model}" \
    --split_idx "${fold_idx}" \
    --split_param "${split_param}" \
    --split_method "${split_method}" \
    --path_splits "${path_splits}" \
    --taskid "${task_id}"

echo "Segmentation task completed."