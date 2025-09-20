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
TEMPLATE="/Volumes/DTI/DTI/Wave1/ANTsTemplate/OASIS/T_template0.nii.gz"
TEMPLATE_MASK="/Volumes/DTI/DTI/Wave1/ANTsTemplate/OASIS/T_template0_BrainCerebellumMask.nii.gz"
output_dir="/Volumes/DTI/DTI/Wave1/derivatives/ANTs/OASIS/"

# List of all the filenames to process
files=(
    "Chein_LITE1_P1001"
    "Chein_LITE1_P1002"
    "Chein_LITE1_P1003"
    "Chein_LITE1_P1005"
    "Chein_LITE1_P1006"
    "Chein_LITE1_P1007"
    "Chein_LITE1_P1008"
    "Chein_LITE1_P1009"
    "Chein_LITE1_P1011"
    "Chein_LITE1_P1012"
    "Chein_LITE1_P1017"
    "Chein_LITE1_P1018"
    "Chein_LITE1_P1019"
    "Chein_LITE1_P1021"
    "Chein_LITE1_P1022"
    "Chein_LITE1_P1023"
    "Chein_LITE1_P1024"
    "Chein_LITE1_P1025"
    "Chein_LITE1_P1026"
    "Chein_LITE1_P1029"
    "Chein_LITE1_P1030"
    "Chein_LITE1_P1033"
    "Chein_LITE1_P1034"
    "Chein_LITE1_P1035"
    "Chein_LITE1_P1036"
    "Chein_LITE1_P1037"
    "Chein_LITE1_P1038"
    "Chein_LITE1_P1039"
    "Chein_LITE1_P1041"
    "Chein_LITE1_P1047"
    "Chein_LITE1_P1048"
    "Chein_LITE1_P1049"
    "Chein_LITE1_P1050"
    "Chein_LITE1_P1053"
    "Chein_LITE1_P1057"
    "Chein_LITE1_P1058"
    "Chein_LITE1_P1061"
    "Chein_LITE1_P1063"
    "Chein_LITE1_P1065"
    "Chein_LITE1_P1066"
    "Chein_LITE1_P1067"
    "Chein_LITE1_P1068"
    "Chein_LITE1_P1069"
    "Chein_LITE1_P1070"
    "Chein_LITE1_P1071"
    "Chein_LITE1_P1072"
    "Chein_LITE1_P1073"
    "Chein_LITE1_P1074"
    "Chein_LITE1_P1077"
    "Chein_LITE1_P1078"
    "Chein_LITE1_P1079"
    "Chein_LITE1_P1080"
    "Chein_LITE1_P1081"
    "Chein_LITE1_P1084"
    "Chein_LITE1_P1086"
    "Chein_LITE1_P1087"
    "Chein_LITE1_P1088"
    "Chein_LITE1_P1091"
    "Chein_LITE1_P1092"
    "Chein_LITE1_P1094"
    "Chein_LITE1_P1095"
    "Chein_LITE1_P1097"
    "Chein_LITE1_P1098"
    "Chein_LITE1_P1099"
    "Chein_LITE1_P1100"
    "Chein_LITE1_P1104"
    "Chein_LITE1_P1107"
    "Chein_LITE1_P1110"
    "Chein_LITE1_P1111"
    "Chein_LITE1_P1112"
    "Chein_LITE1_P1113"
    "Chein_LITE1_P1114"
    "Chein_LITE1_P1117"
    "Chein_LITE1_P1118"
    "Chein_LITE1_P1123"
    "Chein_LITE1_P1124"
    "Chein_LITE1_P1125"
    "Chein_LITE1_P1127"
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


