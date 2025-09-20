################### AFQ PREP ####################################### 

#!/bin/bash 

# Set the path to the subjects file 
subjects_file="/Volumes/DTI/9sublist.txt"

# Loop through each subject in the subjects file 
while IFS= read -r subject; do 

    # Extract the last 4 digits from the subject name 
    subject_number=$(echo "$subject" | grep -oE 'P[0-9]{4}$' | grep -oE '[0-9]{4}') 

    # Base directory for the project 
    mkdir -p "/Volumes/DTI/DTI/Wave1/pyAFQ/derivatives/sub-${subject_number}/" 
    mkdir -p "/Volumes/DTI/DTI/Wave1/pyAFQ/derivatives/sub-${subject_number}/dwi" 
    mkdir -p "/Volumes/DTI/DTI/Wave1/pyAFQ/derivatives/sub-${subject_number}/anat" 

    # Eddy output dir 
    eddy_output_dir="/Volumes/DTI/DTI/derivatives/eddyoutput/$subject/eddy_output_no_b250/" 

    # Output dirs 
    pyafq_dwi_dir="/Volumes/DTI/DTI/Wave1/pyAFQ/derivatives/sub-${subject_number}/dwi" 
    pyafq_anat_dir="/Volumes/DTI/DTI/Wave1/pyAFQ/derivatives/sub-${subject_number}/anat"  

    # Denoise directory 
    denoise_dir="/Volumes/DTI/DTI/Wave1/derivatives/denoise/"
  
    # Output the B0 image to the appropriate location 
    if [ -f "/Volumes/DTI/DTI/Wave1/NIFTI/$subject/dti/topup_output/${subject_number}_my_hifi_b0_Tcollapsed_brain.nii.gz" ]; then 
        cp "/Volumes/DTI/DTI/Wave1/NIFTI/$subject/dti/topup_output/${subject_number}_my_hifi_b0_Tcollapsed_brain.nii.gz" "$pyafq_dwi_dir/sub-${subject_number}_dwi_desc-b0_dwi.nii.gz" 
    fi 

    # Copy the bvals and correct bvecs files to the appropriate location 
    if [ -f "/Volumes/DTI/DTI/Wave1/derivatives/bedpostx_input/$subject/bvals" ]; then 
        cp "/Volumes/DTI/DTI/Wave1/derivatives/bedpostx_input/$subject/bvals" "$pyafq_dwi_dir/sub-${subject_number}_dwi.bval" 
    fi 
    if [ -f "/Volumes/DTI/DTI/Wave1/derivatives/bedpostx_input/$subject/bvecs" ]; then 
        cp "/Volumes/DTI/DTI/Wave1/derivatives/bedpostx_input/$subject/bvecs" "$pyafq_dwi_dir/sub-${subject_number}_dwi.bvec" 
    fi 

    # Copy the best T1 file to the appropriate location 
    if [ -f "/Volumes/DTI/DTI/Wave1/NIFTI/${subject}/struct/${subject_number}_struct.nii" ]; then 
        cp "/Volumes/DTI/DTI/Wave1/NIFTI/${subject}/struct/${subject_number}_struct.nii" "$pyafq_anat_dir/sub-${subject_number}_T1w.nii.gz" 
    fi 

    # Copy the brain-extracted image and brain mask to the appropriate location 
    if [ -f "/Volumes/DTI/DTI/Wave1/derivatives/ANTs/${subject}/${subject_number}_BrainExtractionBrain.nii.gz" ]; then 
        cp "/Volumes/DTI/DTI/Wave1/derivatives/ANTs/${subject}/${subject_number}_BrainExtractionBrain.nii.gz" "$pyafq_anat_dir/sub-${subject_number}_desc-brain_T1w.nii.gz" 
    fi 
    if [ -f "/Volumes/DTI/DTI/Wave1/derivatives/ANTs/${subject}/${subject_number}_BrainExtractionMask.nii.gz" ]; then 
        cp "/Volumes/DTI/DTI/Wave1/derivatives/ANTs/${subject}/${subject_number}_BrainExtractionMask.nii.gz" "$pyafq_anat_dir/sub-${subject_number}_desc-brain_mask.nii.gz" 
    fi 

    # Copy the dwi brain mask to the appropriate location 
    if [ -f "/Volumes/DTI/DTI/Wave1/derivatives/bedpostx_input/$subject/nodif_brain_mask.nii.gz" ]; then 
        cp "/Volumes/DTI/DTI/Wave1/derivatives/bedpostx_input/$subject/nodif_brain_mask.nii.gz" "$pyafq_dwi_dir/sub-${subject_number}_dwi_desc-brain_mask.nii.gz" 
    fi 

done < "$subjects_file"
