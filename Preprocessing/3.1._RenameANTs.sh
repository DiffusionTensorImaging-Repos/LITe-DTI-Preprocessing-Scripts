#!/bin/bash

# Change directory to the specified location
cd /Volumes/DTI/DTI/Wave1/derivatives/ANTs || exit

# Iterate over each directory
for dir in Chein_LITE1_P*; do
    if [ -d "$dir" ]; then
        # Extract last 4 digits from the directory name
        prefix=$(echo "$dir" | grep -oE '[0-9]{4}$')

        # Rename the files within the directory
         mv "$dir/BrainExtractionBrain.nii.gz" "$dir/${prefix}_BrainExtractionBrain.nii.gz"
         mv "$dir/BrainExtractionMask.nii.gz" "$dir/${prefix}_BrainExtractionMask.nii.gz"
         mv "$dir/BrainExtractionPrior0GenericAffine.mat" "$dir/${prefix}_BrainExtractionPrior0GenericAffine.mat"

        # Optionally, print a message for each directory
        echo "Files renamed for $dir"
    fi
done

# Optionally, print a message indicating completion
echo "All files renamed successfully."
