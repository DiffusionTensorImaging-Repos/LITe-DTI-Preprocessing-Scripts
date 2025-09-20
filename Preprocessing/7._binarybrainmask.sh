### the binary brain mask is essential for accurately isolating brain tissue in neuroimaging data, improving the quality of subsequent analyses, and enabling effective comparisons across studies and subjects. It enhances the focus on relevant brain regions while minimizing the impact of extraneous tissue.


#!/bin/bash

# Set the path to the main directory
main_dir="/Volumes/DTI/DTI/Wave1/NIFTI"

# Read the list of subjects from the provided file
subjects_file="/Volumes/DTI/sublist3004.txt"

# Loop through each subject
while IFS= read -r subject; do 
    # Extract four digits from subject name
    subject_number=$(echo "$subject" | grep -oE '[0-9]{4}')

        # Construct the input file path 
        input_file="$dir/dti/topup_output2/${subject_number}_topup_output_my_hifi_b0_Tcollapsed.nii.gz" 

        # Construct the output file path 
        output_file="$dir/dti/topup_output2/${subject_number}_my_hifi_b0_Tcollapsed_brain.nii.gz" 

        # Run the bet command for the current input file 
        /Users/tut34411/fsl/bin/bet "$input_file" "$output_file" -m -f 0.2 -g 0.1 -R -v 

        echo "Processing complete for $input_file" 
        echo "Output file saved as $output_file" 
done
