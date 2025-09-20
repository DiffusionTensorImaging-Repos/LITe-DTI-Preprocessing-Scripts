#Meanb0image across time
###averaging the B0 images across time helps in creating a more robust and accurate representation of the brain's structure, which is essential for high-quality diffusion tensor imaging and other analyses in neuroimaging studies.


#!/bin/bash

# Set the root directory
root_directory="/Volumes/DTI/DTI/Wave1/NIFTI"

# Loop through all directories with the pattern Chein_LITE1_P_____
for dir in "$root_directory"/Chein_LITE1_P*; do 
    # Check if it's a directory 
    if [ -d "$dir" ]; then 
        # Get the 4 digit number from the directory name 
        dir_name=$(basename "$dir") 
        four_digit_number=${dir_name##*_P} 

        # Define the input and output file paths 
        input_file="${dir}/dti/topup_output/${four_digit_number}_topup_output_my_hifi_b0.nii.gz" 
        output_file="${dir}/dti/topup_output/${four_digit_number}_topup_output_my_hifi_b0_Tcollapsed.nii.gz" 

        # Source FSL environment 
        source /Users/tut34411/fsl/etc/fslconf/fsl.sh 

        # Set FSLOUTPUTTYPE environment variable 
        export FSLOUTPUTTYPE=NIFTI_GZ 

        # Run fslmaths 
        fslmaths "$input_file" -Tmean "$output_file" 
    fi 
done
