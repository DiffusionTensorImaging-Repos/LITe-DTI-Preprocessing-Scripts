#!/bin/bash

############################ TOPUP ######################################
## corrects for susceptibility-induced geometric distortions in diffusion-weighted and functional MRI data. By utilizing pairs of images acquired with opposite phase encoding directions, TOPUP estimates and applies distortion corrections to improve the alignment and accuracy of the images for subsequent analysis.

# Load FSL configuration
source /Users/tut34411/fsl/etc/fslconf/fsl.sh

# Input directory containing NIFTI files
input_dir="/Volumes/DTI/DTI/Wave1/NIFTI"

# Create output directories for each subject
for dir in "$input_dir"/*/; do  
    number=$(basename "$dir" | grep -oE "[0-9]{4}")  
    output_dir="${dir}dti/topup_output2/"  
    mkdir -p "$output_dir"  
done 

# File containing acquisition parameters
datain_file="/Volumes/DTI/DTI/Wave1/acqp.txt" 

# Run TOPUP for each subject
for dir in "$input_dir"/*/; do  
    number=$(basename "$dir" | grep -oE "[0-9]{4}")  
    input_file="${dir}dti/${number}_merged.nii.gz"  
    output_prefix="${dir}dti/topup_output/${number}_topup_output"  
    
    # Run TOPUP command
    topup --imain="$input_file" --datain="$datain_file" \
          --config="/Users/tut34411/fsl/pkgs/fsl-topup-2203.5-h7c8b5fb_0/etc/flirtsch/b02b0_1.cnf" \
          --out="$output_prefix" --iout="${output_prefix}_my_hifi_b0" \
          --fout="${output_prefix}_displacement" --verbose  
done


