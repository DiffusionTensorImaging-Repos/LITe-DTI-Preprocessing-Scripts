#### B0 Concatinating: strips the Baseline image from the pa and ap DTI image, and then merges them --> neccesary for topup - NEXT STEP!


#!/bin/bash

# Extract b0 from ap-pa fieldmaps
for n in 2121; do
    bash -c '
        . "/Users/tur50045/fsl/etc/fslconf/fsl.sh"

        fslroi "/Volumes/DTI/DTI/Wave1/NIFTI/Chein_LITE1_P'"$n"'/dti/cmrr_fieldmapse_ap/'"$n"'_cmrr_fieldmapse_ap.nii" "/Volumes/DTI/DTI/Wave1/NIFTI/Chein_LITE1_P'"$n"'/dti/cmrr_fieldmapse_ap/'"$n"'_a2p_b0.nii" 0 1

        fslroi "/Volumes/DTI/DTI/Wave1/NIFTI/Chein_LITE1_P'"$n"'/dti/cmrr_fieldmapse_pa/'"$n"'_cmrr_fieldmapse_pa.nii" "/Volumes/DTI/DTI/Wave1/NIFTI/Chein_LITE1_P'"$n"'/dti/cmrr_fieldmapse_pa/'"$n"'_p2a_b0.nii" 0 1
    '

    bash -c '
        . /Users/tur50045/fsl/etc/fslconf/fsl.sh && \
        fslmerge -t "/Volumes/DTI/DTI/Wave1/NIFTI/Chein_LITE1_P'"$n"'/dti/'"$n"'_merged.nii.gz" \
        "/Volumes/DTI/DTI/Wave1/NIFTI/Chein_LITE1_P'"$n"'/dti/cmrr_fieldmapse_ap/'"$n"'_a2p_b0.nii.gz" \
        "/Volumes/DTI/DTI/Wave1/NIFTI/Chein_LITE1_P'"$n"'/dti/cmrr_fieldmapse_pa/'"$n"'_p2a_b0.nii.gz"
    '
done
