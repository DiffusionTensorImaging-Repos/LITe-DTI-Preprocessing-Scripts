

#Converting DICOM to NIfTI is essential for simplifying medical image data and ensuring compatibility with neuroimaging analysis tools commonly used in research.

# Note - due to manual error during the MRI runs, some files are named incorrectly within 
##dicom logs and thus will not be propely renamed after this code is run! 
##They will still be found in the output folder, but will need to be manually, invididually renamed to match the other files. 


#!/bin/bash

# List of files to process
input_files=(
    
    "Chein_LITE1_P1016"
   
    
)

for input_file in "${input_files[@]}"; do  
    # Create, and then Navigate, to the existing DTI folder  
    cd "/Volumes/DTI/DTI/Wave1/NIFTI" || { echo "Failed to navigate to NIFTI directory"; exit 1; }

    # Create directory for current input file if it doesn't exist  
    input_dir="$input_file"  
    sudo mkdir -p "$input_dir"  

    # Navigate to the directory for current input file  
    cd "$input_dir" || { echo "Failed to navigate to $input_dir"; exit 1; }

    # Create struct and dti directories  
    struct_dir="struct/"  
    sudo mkdir -p "$struct_dir"  

    dti_dir="dti/"  
    sudo mkdir -p "$dti_dir"  

    # Convert structural DICOM files  
    for struct_dir_path in $(find "/Volumes/LITE_fMRI/Lite_Raw_fMRI_backups/${input_file}/scans" -type d | grep -E '/[0-9]+-t1_mpg_07sag_iso$'); do  
        # Convert DICOM files in the structural directory  
        sudo /opt/homebrew/bin/dcm2niix -o "$struct_dir" -f "%i" "$struct_dir_path/resources/DICOM/files"  
    done  

    # Convert other DICOM files  
    for k in $(find "/Volumes/LITE_fMRI/Lite_Raw_fMRI_backups/${input_file}/scans" -type d | grep -E '/[0-9]+-(cmrr_mb3hydi_ipat2_64ch|cmrr_fieldmapse_ap|cmrr_fieldmapse_pa)$'); do  

    # Remove the leading number from the output directory name  
        k=$(basename "$k")  
        output_dir="$dti_dir/$(echo "$k" | cut -d'-' -f2)"  
        sudo mkdir -p "$output_dir"  

        sudo /opt/homebrew/bin/dcm2niix -o "$output_dir" -f "%i" "/Volumes/LITE_fMRI/Lite_Raw_fMRI_backups/${input_file}/scans/${k}/resources/DICOM/files"  
    done  

    # Rename the NIfTI files  
    sudo mv "$dti_dir/cmrr_mb3hydi_ipat2_64ch/${input_file}.bval" "$dti_dir/cmrr_mb3hydi_ipat2_64ch/${input_file: -4}_cmrr_mb3hydi_ipat2_64ch.bval"  
    sudo mv "$dti_dir/cmrr_mb3hydi_ipat2_64ch/${input_file}.bvec" "$dti_dir/cmrr_mb3hydi_ipat2_64ch/${input_file: -4}_cmrr_mb3hydi_ipat2_64ch.bvec"  
    sudo mv "$dti_dir/cmrr_mb3hydi_ipat2_64ch/${input_file}.nii" "$dti_dir/cmrr_mb3hydi_ipat2_64ch/${input_file: -4}_cmrr_mb3hydi_ipat2_64ch.nii"  
    sudo mv "$dti_dir/cmrr_mb3hydi_ipat2_64ch/${input_file}.json" "$dti_dir/cmrr_mb3hydi_ipat2_64ch/${input_file: -4}_cmrr_mb3hydi_ipat2_64ch.json"  

    sudo mv "$dti_dir/cmrr_fieldmapse_ap/${input_file}.nii" "$dti_dir/cmrr_fieldmapse_ap/${input_file: -4}_cmrr_fieldmapse_ap.nii"  
    sudo mv "$dti_dir/cmrr_fieldmapse_ap/${input_file}.json" "$dti_dir/cmrr_fieldmapse_ap/${input_file: -4}_cmrr_fieldmapse_ap.json"  

    sudo mv "$dti_dir/cmrr_fieldmapse_pa/${input_file}.nii" "$dti_dir/cmrr_fieldmapse_pa/${input_file: -4}_cmrr_fieldmapse_pa.nii"  
    sudo mv "$dti_dir/cmrr_fieldmapse_pa/${input_file}.json" "$dti_dir/cmrr_fieldmapse_pa/${input_file: -4}_cmrr_fieldmapse_pa.json"  

    sudo mv "$struct_dir/${input_file}.nii" "$struct_dir/${input_file: -4}_struct.nii"  
    sudo mv "$struct_dir/${input_file}.json" "$struct_dir/${input_file: -4}_struct.json"  
done  
