#!/bin/bash

# Set the path to the subjects file
subjects_file="/Volumes/DTI/9sublist.txt"

# Check if the subjects file exists
if [[ ! -f "$subjects_file" ]]; then
    echo "Subjects file not found: $subjects_file"
    exit 1
fi

# Loop through each subject in the subjects file
while IFS= read -r subject; do
    # Extract the last 4 digits from the subject name
    subject_number=$(echo "$subject" | grep -oE 'P[0-9]{4}$' | grep -oE '[0-9]{4}')

    # Check if subject_number was extracted successfully
    if [[ -z "$subject_number" ]]; then
        echo "No valid subject number found for: $subject"
        continue
    fi

    # Define source and destination paths for clarity
    source_dir="/Volumes/DTI/DTI/Wave1/derivatives/denoise/$subject"
    dest_dir="/Volumes/DTI/DTI/Wave1/derivatives/eddyoutput/$subject"

    # Create destination directory if it doesn't exist
    mkdir -p "$dest_dir"

    # Rename files and check for successful moves
    mv "$source_dir/${subject_number}_eddy_corrected_data.nii.gz" "$dest_dir/data.nii.gz" || echo "Failed to move data.nii.gz for subject $subject"
    mv "$source_dir/${subject_number}_eddy_corrected_data.eddy_rotated_bvecs" "$dest_dir/bvecs" || echo "Failed to move bvecs for subject $subject"
    mv "$source_dir/${subject_number}_my_hifi_b0_Tcollapsed_brain_mask.nii.gz" "$dest_dir/nodif_brain_mask.nii.gz" || echo "Failed to move nodif_brain_mask.nii.gz for subject $subject"
    mv "$source_dir/${subject_number}_modified_bval.bval" "$dest_dir/bvals" || echo "Failed to move bvals for subject $subject"

done < "$subjects_file"

echo "Processing completed."
