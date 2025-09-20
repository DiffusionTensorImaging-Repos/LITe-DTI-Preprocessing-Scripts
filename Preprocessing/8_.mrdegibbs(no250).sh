###mrdegibbs is a tool used in MRI preprocessing to remove Gibbs ringing artifacts, which are oscillations that can appear around sharp edges in an image.

##we remove  b=250 image prior to applying mrdegibbs is significant because this particular b-value has been associated with motion artifacts in previous studies.


#!/bin/bash

# Update directories and files as per your instructions
denoise_dir="/Volumes/DTI/DTI/Wave1/derivatives/denoise/"

acq_params_file="/Volumes/DTI/DTI/Wave1/acqp.txt"
index_file="/Volumes/DTI/DTI/Wave1/index.txt"

# Ask user for the number of cores to use
read -p "How many PARTICIPANTS would you like to run simultaneously? Please enter 1 for this process because mrdegibbs uses all cores! " MAX_JOBS

# Read the list of subjects from the provided file
subjects_file="/Volumes/DTI/sublist2080.txt"

# Loop through each subject
while IFS= read -r subject; do 
    # Extract four digits from subject name
    subject_number=$(echo "$subject" | grep -oE '[0-9]{4}')

    # Update directories with current subject
    topup_output_dir="/Volumes/DTI/DTI/Wave1/NIFTI/$subject/dti/topup_output"
    cmrr_dir="/Volumes/DTI/DTI/Wave1/NIFTI/$subject/dti/cmrr_mb3hydi_ipat2_64ch"

    # Create denoising directories
    mkdir -p "$denoise_dir$subject_number/dwidenoise"
    mkdir -p "$denoise_dir$subject_number/mrdegibbs"
    mkdir -p "$denoise_dir$subject_number/mrdegibbs_no_b250"

    # Run dwidenoise
    dwidenoise -mask "$topup_output_dir/${subject_number}_my_hifi_b0_Tcollapsed_brain_mask.nii.gz" \
        -noise "$denoise_dir$subject_number/dwidenoise/${subject_number}_noise_hifi_map.nii" \
        "$cmrr_dir/${subject_number}_cmrr_mb3hydi_ipat2_64ch.nii" \
        "$denoise_dir$subject_number/dwidenoise/${subject_number}_denoised_hifi_vol.nii" -force

    # Run mrdegibbs
    mrdegibbs "$denoise_dir$subject_number/dwidenoise/${subject_number}_denoised_hifi_vol.nii" \
        "$denoise_dir$subject_number/mrdegibbs/${subject_number}_denoised_degibbs_hifi_vol.nii" -force

    # Create directory for output without b=250 volumes
    mkdir -p "$denoise_dir$subject_number/mrdegibbs_no_b250"

    # Remove b=250 volumes using dwiextract
    dwiextract "$denoise_dir$subject_number/mrdegibbs/${subject_number}_denoised_degibbs_hifi_vol.nii" \
        -fslgrad "$cmrr_dir/${subject_number}_cmrr_mb3hydi_ipat2_64ch.bvec" \
        "$cmrr_dir/${subject_number}_cmrr_mb3hydi_ipat2_64ch.bval" \
        -shells 0,1000,2000,3250,5000 \
        "$denoise_dir$subject_number/mrdegibbs_no_b250/${subject_number}_denoised_degibbs_hifi_vol_no_b250.nii" -force

    # Remove b=250 from bval file and change double spaces to single spaces
    awk -v indices="$(awk '{for(i=1;i<=NF;i++) if ($i == 250) printf "%s,",i}' "$cmrr_dir/${subject_number}_cmrr_mb3hydi_ipat2_64ch.bval" | sed 's/,$//')" \
        'BEGIN{split(indices, idx, ",")}{for(i in idx) $idx[i]=""; print}' \
        "$cmrr_dir/${subject_number}_cmrr_mb3hydi_ipat2_64ch.bval" | tr -s ' ' > "$denoise_dir$subject_number/mrdegibbs_no_b250/${subject_number}_modified_bval.bval"

done < "$subjects_file"
