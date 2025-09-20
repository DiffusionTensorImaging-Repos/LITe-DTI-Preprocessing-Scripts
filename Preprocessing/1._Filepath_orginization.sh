##################### 1. ORGANIZING FILEPATHS ##########################  
 
# This code is used to make sure that the original DICOM files all have the same names


######## Correcting "LITE" capitalization 
##The first section of code will ensure that the word "LITE" is capitalized in a uniform manner accross all of the DICOM files

#!/bin/bash

# Navigate to the directory
cd /Volumes/Expansion/Lite_Raw_fMRI_backups

# Loop through each file in the directory
for file in *; do
    # Check if the filename contains "lite", "LITe", or "Lite"
    if [[ $file =~ [lL][iI][tT][eE] ]]; then
        # Rename the file by capitalizing "lite", "LITe", or "Lite"
        new_file=$(echo "$file" | sed 's/[lL][iI][tT][eE]/LITE/g')
        mv "$file" "$new_file"
        echo "Renamed '$file' to '$new_file'"
    fi
done

######## Folder Sctucture Uniformity  
##adds a necessary "scans" folder within each DICOM Participant folder in which the DICOM files are located

#!/bin/bash

directory="/Volumes/Expansion/Lite_Raw_fMRI_backups"

for folder in "$directory"/*/; do
    folder_name=$(basename "$folder")
    
    if [ ! -d "$folder/scans" ]; then
        mkdir "$folder/scans"
        mv "$folder"/* "$folder/scans/"
    fi
done



