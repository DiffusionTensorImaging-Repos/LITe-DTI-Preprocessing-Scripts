############################## DWI EXTRACT ###########################

##The dwiextract command extracts all volumes for which the b-value is (approximately) zero; the resulting 4D image can then be provided to the mrmath command to calculate the mean intensity across volumes for each voxel.

subjects_file="/Volumes/DTI/9sublist.txt"

# Loop through each subject in the subjects file for dwiextract
while IFS= read -r subject; do
    # Extract the last 4 digits from the subject name
    subject_number=$(echo "$subject" | grep -oE 'P[0-9]{4}$' | grep -oE '[0-9]{4}')

    # Define directories
    bedpostx_input_dir="/Volumes/DTI/DTI/Wave1/derivatives/bedpostx_input/$subject"
    mrtrix3_1000_dir="/Volumes/DTI/DTI/Wave1/derivatives/mrtrix3_1000/$subject"

    # Create the MRtrix3 1000 directory if it doesn't exist
    mkdir -p "$mrtrix3_1000_dir"

    # Run dwiextract for b=<1000 in the background
    (
        dwiextract -fslgrad "$bedpostx_input_dir/bvecs" "$bedpostx_input_dir/bvals" -shells 0,1000 "$bedpostx_input_dir/data.nii.gz" "$mrtrix3_1000_dir/data_1000.nii.gz" -export_grad_fsl "$mrtrix3_1000_dir/bvecs_1000" "$mrtrix3_1000_dir/bvals_1000" -force
    ) &

done < "$subjects_file"

# Wait for all background jobs to finish
wait

#!/bin/bash

# Set the path to the subjects file
subjects_file="/Volumes/DTI/9sublist.txt"

# Loop through each subject in the subjects file
while IFS= read -r subject; do

    # Extract the last 4 digits from the subject name
    subject_number=$(echo "$subject" | grep -oE 'P[0-9]{4}$' | grep -oE '[0-9]{4}')

    # Define directories
    bedpostx_input_dir="/Volumes/DTI/DTI/Wave1/derivatives/bedpostx_input/$subject"
    mrtrix3_2000_dir="/Volumes/DTI/DTI/Wave1/derivatives/mrtrix3_2000/$subject"

    # Create the MRtrix3 2000 directory if it doesn't exist
    mkdir -p "$mrtrix3_2000_dir"

    # Run dwiextract in the background
    (
        dwiextract -fslgrad "$bedpostx_input_dir/bvecs" "$bedpostx_input_dir/bvals" -shells 0,1000,2000 "$bedpostx_input_dir/data.nii.gz" "$mrtrix3_2000_dir/data_1000_2000.nii.gz" -export_grad_fsl "$mrtrix3_2000_dir/bvecs_1000_2000" "$mrtrix3_2000_dir/bvals_1000_2000" -force
    ) &

done < "$subjects_file"

# Wait for all background jobs to finish
wait
