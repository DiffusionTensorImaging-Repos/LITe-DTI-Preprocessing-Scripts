############## 3. ANTs Skullstripping ###################


 
###DOWNLOADING MASKS:  
 
#https://figshare.com/articles/dataset/ANTs_ANTsR_Brain_Templates/915436 
#used NKI template 


##This code will remove extract just the brain from the T1, stripping away the skull and face
##good brain extraction allows better registration of an anatomical image to 
##a standard template and thus better alignment of the data to the standard space.




### AFTER THIS CODE IS RUN, EACH FILE WILL NEED TO BE CHECKED USING FSLEYES FOR ACCURACY.
## IF NOT SUFFICIENTLY ACCURATE FOR NUMEROUS PARTICIPANTS, ANOTHER MASK SHOULD BE USED. 
###PLEASE REACH OUT TO danny.zweben99@gmail.com for assistance. 

#!/bin/bash

# Define the directory where ANTs binaries are located
ANTs_bin_dir="/Users/tut34411/ANTs/bin"

# Update the PATH environment variable to include ANTs binaries directory
export PATH="$ANTs_bin_dir:$PATH"

# Set the paths for input files and output directory
TEMPLATE="/Volumes/DTI/DTI/Wave1/ANTsTemplate/NKI/T_template.nii.gz"
TEMPLATE_MASK="/Volumes/DTI/DTI/Wave1/ANTsTemplate/NKI/T_template_BrainCerebellumMask.nii.gz"
output_dir="/Volumes/DTI/DTI/Wave1/derivatives/ANTs/"

# List of all the filenames to process
files=(
     "Chein_LITE1_P2089"
"Chein_LITE1_P3002"
"Chein_LITE1_P3157"
"Chein_LITE1_P3158"
"Chein_LITE1_P1019"
"Chein_LITE1_P1117"
"Chein_LITE1_P2086"
"Chein_LITE1_P2087"
"Chein_LITE1_P2088"
"Chein_LITE1_P2089"
"Chein_LITE1_P2090"
"Chein_LITE1_P2091"
"Chein_LITE1_P2092"
"Chein_LITE1_P2094"
"Chein_LITE1_P2095"
"Chein_LITE1_P2096"
"Chein_LITE1_P2097"
"Chein_LITE1_P2098"
"Chein_LITE1_P2099"
"Chein_LITE1_P2100"
"Chein_LITE1_P2101"
"Chein_LITE1_P2102"
"Chein_LITE1_P2104"
"Chein_LITE1_P2105"
"Chein_LITE1_P2106"
"Chein_LITE1_P2108"
"Chein_LITE1_P2109"
"Chein_LITE1_P2111"
"Chein_LITE1_P2112"
"Chein_LITE1_P2113"
"Chein_LITE1_P2115"
"Chein_LITE1_P2116"
"Chein_LITE1_P2117"
"Chein_LITE1_P2118"
"Chein_LITE1_P2119"
"Chein_LITE1_P2120"
"Chein_LITE1_P2121"
"Chein_LITE1_P2124"
"Chein_LITE1_P2125"
"Chein_LITE1_P2128"
"Chein_LITE1_P2130"


)



# Loop over each filename
for filename in "${files[@]}"; do
    # Get the last 4 digits of the filename for the input file
    last_four_digits="${filename: -4}"

    # Construct the full path for the NIFTI file
    nii_file="/Volumes/DTI/DTI/Wave1/NIFTI/${filename}/struct/${last_four_digits}_struct.nii"

    # Define the output file path for this particular file
    output_file_path="${output_dir}${filename}/"

    # Create the output directory if it doesn't exist
    mkdir -p "$output_file_path"

    # Execute the ANTs script with sudo
     "$ANTs_bin_dir/antsBrainExtraction.sh" -d 3 -a "$nii_file" -e "$TEMPLATE" -m "$TEMPLATE_MASK" -o "$output_file_path"
done


