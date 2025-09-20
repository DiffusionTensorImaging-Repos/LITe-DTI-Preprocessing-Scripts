

######################## FLIRT AND CONVERT #########################

#!/bin/bash

# Source FSL configuration file
source /Users/tur50045/fsl/etc/fslconf/fsl.sh

# Define the path to the ANTs binaries directory
ANTs_bin_dir="/Users/tur50045/ANTs/bin"

# Update the PATH environment variable to include ANTs binaries directory
export PATH="$ANTs_bin_dir:$PATH"

# Set the path to the subjects file
subjects_file="/Volumes/DTI/9sublist.txt"


# Loop through each subject in the subjects file
while IFS= read -r subject; do
    # Extract the last 4 digits from the subject name
    subject_number=$(echo "$subject" | grep -oE 'P[0-9]{4}$' | grep -oE '[0-9]{4}')
    
    # Ensure the subject number is not empty
    if [ -n "$subject_number" ]; then
        # Define paths
        t1_brain="/Volumes/DTI/DTI/Wave1/derivatives/ANTs/$subject/${subject_number}_BrainExtractionBrain.nii.gz"
        template="/Users/tur50045/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz"
        topup_output_dir="/Volumes/DTI/DTI/Wave1/NIFTI/$subject/dti/topup_output"
        transform_dir="/Volumes/DTI/DTI/Wave1/transforms/$subject/"

        # Ensure the directories exist
        mkdir -p "$transform_dir"

        # First flirt command
        flirt -in "$topup_output_dir/${subject_number}_my_hifi_b0_Tcollapsed_brain.nii.gz" -ref "$t1_brain" -omat "$transform_dir/diff2str_${subject_number}.mat" -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 -cost corratio
        
        # First convert_xfm command
        convert_xfm -omat "$transform_dir/str2diff_${subject_number}.mat" -inverse "$transform_dir/diff2str_${subject_number}.mat"
        
        # Second flirt command
        flirt -in "$t1_brain" -ref "$template" -omat "$transform_dir/str2standard_${subject_number}.mat" -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 -cost corratio
        
        # Second convert_xfm command
        convert_xfm -omat "$transform_dir/standard2str_${subject_number}.mat" -inverse "$transform_dir/str2standard_${subject_number}.mat"
        
        # Third convert_xfm command
        convert_xfm -omat "$transform_dir/diff2standard_${subject_number}.mat" -concat "$transform_dir/str2standard_${subject_number}.mat" "$transform_dir/diff2str_${subject_number}.mat"
        
        # Fourth convert_xfm command
        convert_xfm -omat "$transform_dir/standard2diff_${subject_number}.mat" -inverse "$transform_dir/diff2standard_${subject_number}.mat"
    fi
done < "$subjects_file"
