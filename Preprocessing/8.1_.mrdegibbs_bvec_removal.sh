# mrdegibbs and b250 removed from bvec files seperately from bval in last step - because these steps for some reason were not being succesfully run together.

#!/bin/bash

# Set FSLDIR and add FSL bin directory to PATH
export FSLDIR="/Users/tut34411/fsl"
export PATH="$FSLDIR/bin:$PATH"

# Denoise directory
denoise_dir="/Volumes/DTI/DTI/Wave1/derivatives/denoise/"

# Acqparams and index files
acq_params_file="/Volumes/DTI/DTI/Wave1/acqp.txt"
index_file="/Volumes/DTI/DTI/Wave1/index_no_b250.txt"

# List of subjects
subjects_file="/Volumes/DTI/sublist2080.txt"

# Loop through each subject
while IFS= read -r subject; do
    # Extract four digits from subject name
    subject_number=$(echo "$subject" | grep -oE '[0-9]{4}')

    # Update directories with current subject
    topup_output_dir="/Volumes/DTI/DTI/Wave1/NIFTI/$subject/dti/topup_output"
    cmrr_dir="/Volumes/DTI/DTI/Wave1/NIFTI/$subject/dti/cmrr_mb3hydi_ipat2_64ch"

    # Get the indices of b=250 shells from the bval file
    bval_file="$cmrr_dir/${subject_number}_cmrr_mb3hydi_ipat2_64ch.bval"
    b250_indices=$(awk '{for(i=1;i<=NF;i++) if ($i == 250) printf "%s,",i}' "$bval_file" | sed 's/,$//')

    # Remove the b=250 shells from the bvec file
    bvec_file="$cmrr_dir/${subject_number}_cmrr_mb3hydi_ipat2_64ch.bvec"
    awk -v indices="$b250_indices" \
        'BEGIN{split(indices, idx, ",")}{for(i in idx) $idx[i]=""; print}' \
        "$bvec_file" | tr -s ' ' > "$denoise_dir/$subject_number/mrdegibbs_no_b250/${subject_number}_modified_bvec.bvec"

done < "$subjects_file"
