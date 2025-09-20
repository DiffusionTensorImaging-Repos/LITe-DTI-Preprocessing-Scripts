#!/bin/bash

# Set FSLDIR and add FSL bin directory to PATH
export FSLDIR="/Users/tut34411/fsl"
export PATH="$FSLDIR/bin:$PATH"

# Denoise directory
denoise_dir="/Volumes/DTI/DTI/Wave1/derivatives/denoise/"

# Acqparams and index files
acq_params_file="/Volumes/DTI/DTI/Wave1/acqp.txt"
index_file="/Volumes/DTI/DTI/Wave1/index_no_b250.txt"

# List of subjects
subjects_file="/Volumes/DTI/sublist3004.txt"
 
while IFS= read -r subject; do
    # Extract four digits from subject name
    subject_number=$(echo "$subject" | grep -oE '[0-9]{4}')

    # Define output directories
    eddy_output_dir="/Volumes/DTI/DTI/Wave1/derivatives/eddyC3/$subject/eddy_output_no_b250"
    mrdegibbs_output_dir="$denoise_dir/$subject_number/mrdegibbs_no_b250"

    # Running EDDY correction
    topup_output_dir="/Volumes/DTI/DTI/Wave1/NIFTI/$subject/dti/topup_output"
    cmrr_dir="/Volumes/DTI/DTI/Wave1/NIFTI/$subject/dti/cmrr_mb3hydi_ipat2_64ch"

    echo "Running EDDY for $subject"
    mkdir -p "$eddy_output_dir"

    # Use the full path to eddy
    eddy_command="$FSLDIR/bin/eddy"

    "$eddy_command" --imain="$mrdegibbs_output_dir/${subject_number}_denoised_degibbs_hifi_vol_no_b250.nii" \
        --mask="$topup_output_dir/${subject_number}_my_hifi_b0_Tcollapsed_brain_mask.nii.gz" \
        --acqp="$acq_params_file" \
        --index="$index_file" \
        --bvecs="$mrdegibbs_output_dir/${subject_number}_modified_bvec.bvec" \
        --bvals="$mrdegibbs_output_dir/${subject_number}_modified_bval.bval" \
        --topup="$topup_output_dir/${subject_number}_topup_output" \
        --cnr_maps="$eddy_output_dir/cnr_maps.nii.gz" \
        --repol \
        --data_is_shelled \
        --out="$eddy_output_dir/${subject_number}_eddy_corrected_data" -v

done < "$subjects_file"
