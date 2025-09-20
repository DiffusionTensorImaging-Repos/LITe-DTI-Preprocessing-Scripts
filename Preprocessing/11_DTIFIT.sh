#!/bin/bash

######################## DTIFIT ##########################################

# Source FSL configuration file
source /Users/tur50045/fsl/etc/fslconf/fsl.sh

# Set FSLOUTPUTTYPE environment variable
export FSLOUTPUTTYPE=NIFTI_GZ

# Set the path to the subjects file
subjects_file="/Volumes/DTI/9sublist.txt"

# Loop through each subject in the subjects file
while IFS= read -r subject; do

    # Extract the last 4 digits from the subject name
    subject_number=$(echo "$subject" | grep -oE 'P[0-9]{4}$' | grep -oE '[0-9]{4}')

    # Define directories
    bedpostx_input_dir="/Volumes/DTI/DTI/Wave1/derivatives/bedpostx_input/$subject"
    mrtrix3_1000_dir="/Volumes/DTI/DTI/Wave1/derivatives/mrtrix3_1000/$subject"
    dtifit_output_dir="/Volumes/DTI/DTI/Wave1/derivatives/dtifit_output_no_b250/$subject"

    # Create directories if they don't exist
    mkdir -p "$dtifit_output_dir"

    # Run dtifit and fslmaths in the background
    (
        # dtifit
        dtifit -k "$mrtrix3_1000_dir/data_1000.nii.gz" \
               -o "$dtifit_output_dir/DTI" \
               -m "/Volumes/DTI/DTI/Wave1/NIFTI/$subject/dti/topup_output/${subject_number}_my_hifi_b0_Tcollapsed_brain_mask.nii.gz" \
               -r "$mrtrix3_1000_dir/bvecs_1000" \
               -b "$mrtrix3_1000_dir/bvals_1000"

        # fslmaths
        fslmaths "$dtifit_output_dir/DTI_L2.nii.gz" \
                  -add "$dtifit_output_dir/DTI_L3.nii.gz" \
                  -div 2 "$dtifit_output_dir/DTI_RD"
    ) &

done < "$subjects_file"

# Wait for all background jobs to finish
wait
