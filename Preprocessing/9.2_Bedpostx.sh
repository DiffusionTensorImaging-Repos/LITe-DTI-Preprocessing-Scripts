#!/bin/bash

######################## BEDPOSTX ####################################### 

#BedpostX is a tool that uses Markov Chain Monte Carlo sampling to create distri#butions of diffusion parameters at each voxel. It's used to build up the files #needed to run probabilistic tractography. Here's some more information about Be#dpostX

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

    if [ -n "$subject_number" ]; then 

        # Make directory for bedpostx input 
        dest_dir="/Volumes/DTI/DTI/Wave1/derivatives/bedpostx_input/$subject"
         mkdir -p "$dest_dir" 

        # Copy and rename files with error handling
        for file in \
            "${subject_number}_eddy_corrected_data.nii.gz" \
            "${subject_number}_eddy_corrected_data.eddy_rotated_bvecs" \
            "${subject_number}_my_hifi_b0_Tcollapsed_brain_mask.nii.gz" \
            "${subject_number}_modified_bval.bval"; do
            
            source_path=""
            case "$file" in
                "${subject_number}_eddy_corrected_data.nii.gz")
                    source_path="/Volumes/DTI/DTI/Wave1/derivatives/eddyoutput/$subject/eddy_output_no_b250/$file"
                    ;;
                "${subject_number}_eddy_corrected_data.eddy_rotated_bvecs")
                    source_path="/Volumes/DTI/DTI/Wave1/derivatives/eddyoutput/$subject/eddy_output_no_b250/$file"
                    ;;
                "${subject_number}_my_hifi_b0_Tcollapsed_brain_mask.nii.gz")
                    source_path="/Volumes/DTI/DTI/Wave1/NIFTI/$subject/dti/topup_output/$file"
                    ;;
                "${subject_number}_modified_bval.bval")
                    source_path="/Volumes/DTI/DTI/Wave1/derivatives/denoise/${subject_number}/mrdegibbs_no_b250/$file"
                    ;;
            esac
            
            if [[ -f "$source_path" ]]; then
                 cp "$source_path" "$dest_dir/" || echo "Failed to copy $file for subject $subject"
            else
                echo "File not found: $source_path"
            fi

        done

    else
        echo "No valid subject number found for: $subject"
    fi 

done < "$subjects_file" 

echo "Processing completed."
