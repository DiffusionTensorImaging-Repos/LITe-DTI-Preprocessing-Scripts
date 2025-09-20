#!/bin/bash 

# Set the path to the subjects file 
subjects_file="/Volumes/DTI/9sublist.txt"

# Loop through each subject in the subjects file 
while IFS= read -r subject; do 
    # Extract the last 4 digits from the subject name 
    subject_number=$(echo "$subject" | grep -oE 'P[0-9]{4}$' | grep -oE '[0-9]{4}') 

    # Eddy output dir 
    eddy_output_dir="/Volumes/DTI/DTI/Wave1/derivatives/eddyoutput/$subject/eddy_output_no_b250" 

    # Output dirs 
    pyafq_dwi_dir="/Volumes/DTI/DTI/Wave1/pyAFQ/derivatives/sub-${subject_number}/dwi" 

    # Create output directory if it doesn't exist 
    mkdir -p "$pyafq_dwi_dir" 

    # Copy the DTI file to the appropriate location 
    if [ -f "$eddy_output_dir/${subject_number}_eddy_corrected_data.nii.gz" ]; then 
        cp "$eddy_output_dir/${subject_number}_eddy_corrected_data.nii.gz" "$pyafq_dwi_dir/sub-${subject_number}_dwi.nii.gz" 
        echo "File copied to $pyafq_dwi_dir/sub-${subject_number}_dwi.nii.gz" 
    else 
        echo "File not found: $eddy_output_dir/${subject_number}_eddy_corrected_data.nii.gz" 
    fi 
done < "$subjects_file"
