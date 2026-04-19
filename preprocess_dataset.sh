#!/bin/bash

# Following nn-unet like structure
in_data=/home/jaume/Desktop/Code/BrainFM4Challenges/nnUNet_raw/Dataset002_MPRAGE
out_data=/home/jaume/Desktop/Code/BrainFM4Challenges/fomo25_preprocessed/Dataset002_MPRAGE

# For pre-training data
code_path='/home/jaume/Desktop/Code/fomo25/src'
python ${code_path}/data/preprocess/preprocess_nnunet_structure.py \
--in_path=${in_data} \
--out_path=${out_data}
