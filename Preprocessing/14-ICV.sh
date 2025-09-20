#!/bin/bash

# Initial directories
INITIAL_DIR="/Volumes/DTI/DTI/Wave1/derivatives/ANTs"  # Corrected to the ANTs output directory
OUTPUT_DIR="/Volumes/DTI/DTI/Wave1/derivatives/ICV"  # Output directory for results
CSV_FILE="/Volumes/DTI/DTI/Wave1/derivatives/ICV/icv_results.csv"  # Output CSV file for ICV results

# Ask user for the number of cores to use
read -p "How many cores would you like to use? Put up to 4. Don't put anything more than 4: " MAX_JOBS

# Create CSV header
echo "participant_id,brain_file_name,ICV" > "$CSV_FILE"

# Function to compute ICV from segmented tissues
compute_icv() {
    sub_name=$1
    brain_file=$2
    brain_mask_file=$3

    echo "Processing ICV for $sub_name with brain file: $brain_file"  # Debugging statement

    # Output prefix for segmentation files
    output_prefix="${OUTPUT_DIR}/${sub_name}/anat/$(basename "${brain_file}" .nii.gz)_segmentation"

    # Ensure the output directory for the participant exists
    mkdir -p "$(dirname "$output_prefix")"  # Create the directory for the output files

    # Perform segmentation using Atropos (brain tissue segmentation)
    /Users/tur50045/ANTs/bin/Atropos -d 3 \
        -a "$brain_file" \
        -i KMeans[3] \
        -x "$brain_mask_file" \
        -c [5,0.001] \
        -m [0.3,1x1x1] \
        -o ["${output_prefix}_labelled.nii.gz","${output_prefix}_prob%02d.nii.gz"]

    # Compute volumes for each tissue type (CSF, GM, WM)
    csf_volume=$(fslstats "${output_prefix}_prob01.nii.gz" -V | awk '{print $2}')
    gm_volume=$(fslstats "${output_prefix}_prob02.nii.gz" -V | awk '{print $2}')
    wm_volume=$(fslstats "${output_prefix}_prob03.nii.gz" -V | awk '{print $2}')

    # Calculate total ICV as the sum of all tissue volumes (CSF + GM + WM)
    total_icv=$(echo "$csf_volume + $gm_volume + $wm_volume" | bc)

    # Append results to CSV file
    echo "$sub_name,$(basename "$brain_file"),$total_icv" >> "$CSV_FILE"
}

# Job counter to manage parallel processing
job_count=0

# Debugging: Check if the INITIAL_DIR is correct and contains subdirectories
echo "Looking for subdirectories in: $INITIAL_DIR"
if [ ! -d "$INITIAL_DIR" ]; then
    echo "ERROR: Directory $INITIAL_DIR does not exist."
    exit 1
fi

# Loop through participant directories in the INITIAL_DIR
for sub_dir in "${INITIAL_DIR}"/Chein_LITE1_P*; do
    if [ -d "$sub_dir" ]; then
        sub_name=$(basename "$sub_dir")
        echo "Found participant: $sub_name"  # Debugging statement

        # Extract the four-digit participant ID (e.g., 3156 from Chein_LITE1_P3156)
        participant_id=$(echo "$sub_name" | grep -o '[0-9]\{4\}')

        if [ -z "$participant_id" ]; then
            echo "ERROR: Participant ID not found in $sub_name"
            continue
        fi

        # Construct the brain file path using the participant ID (e.g., 3156_BrainExtractionBrain.nii.gz)
        brain_file="${sub_dir}/${participant_id}_BrainExtractionBrain.nii.gz"
        if [ -f "$brain_file" ]; then
            echo "Found brain file: $brain_file"  # Debugging statement

            # Define the corresponding brain mask file path
            brain_mask_file="${sub_dir}/${participant_id}_BrainExtractionMask.nii.gz"

            # Process segmentation and ICV calculation in the background
            (
                compute_icv "$sub_name" "$brain_file" "$brain_mask_file"
            ) &

            # Update job count
            job_count=$((job_count + 1))

            # If the job count reaches the maximum number of concurrent jobs, wait for them to finish
            if [ "$job_count" -ge "$MAX_JOBS" ]; then
                wait
                job_count=0
            fi
        else
            echo "WARNING: No brain file found for participant $sub_name at $brain_file"
        fi
    else
        echo "No subdirectory found for $sub_dir"
    fi
done

# Wait for all remaining jobs to finish before ending the script
wait

echo "ICV computation completed. Results are saved in $CSV_FILE."
