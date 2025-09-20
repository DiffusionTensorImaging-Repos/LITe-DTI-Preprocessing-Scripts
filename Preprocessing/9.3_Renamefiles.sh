
#!/bin/bash

# Set the path to the subjects file
subjects_file="/Volumes/DTI/9sublist.txt"

# Loop through each subject in the subjects file
while IFS= read -r subject; do
    # Extract the last 4 digits from the subject name
    subject_number=$(echo "$subject" | grep -oE 'P[0-9]{4}$' | grep -oE '[0-9]{4}')

    # Define source and destination paths for clarity
    source_dir="/Volumes/DTI/DTI/Wave1/derivatives/bedpostx_input/$subject"
    dest_dir="/Volumes/DTI/DTI/Wave1/derivatives/bedpostx_input/$subject"

    # Rename files
    mv "$source_dir/${subject_number}_eddy_corrected_data.nii.gz" "$dest_dir/data.nii.gz"
    mv "$source_dir/${subject_number}_eddy_corrected_data.eddy_rotated_bvecs" "$dest_dir/bvecs"
    mv "$source_dir/${subject_number}_my_hifi_b0_Tcollapsed_brain_mask.nii.gz" "$dest_dir/nodif_brain_mask.nii.gz"
    mv "$source_dir/${subject_number}_modified_bval.bval" "$dest_dir/bvals"

done < "$subjects_file"
