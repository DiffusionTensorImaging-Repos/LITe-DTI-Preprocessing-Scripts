# Welcome to Project LITe (Long Term Impact of Technology) Diffusion Tensor Imaging Pipeline

### Authored by: Danny Z for the Control and Adaptive Behavior Lab (CABLab) under Dr. Jason Chein

## Preprocessing Folder:
The preprocessing folder includes the essential steps required to prepare the diffusion tensor imaging (DTI) data for analysis. Each step is designed to ensure that the data is cleaned, aligned, and ready for further processing. Below are the steps included:

1. **Filepath Preparation**  
   Organizes and standardizes file paths, ensuring that all input and output files are correctly located and referenced for subsequent analysis steps.

2. **DICOM to NIfTI Conversion**  
   Converts raw DICOM images (standard format for MRI scanners) into NIfTI format, which is commonly used in neuroimaging research for storage and analysis.

3. **ANTs Skull Stripping**  
   Uses ANTs (Advanced Normalization Tools) to perform skull stripping, removing non-brain tissue (e.g., skull, scalp) from the DTI images, isolating the brain for further analysis.

4. **RB0 Concat**  
   Concatenates the B0 images (the diffusion-weighting scheme with no gradient applied) across different acquisitions into a single dataset, ensuring proper alignment of the data.

5. **TOPUP**  
   Corrects for motion-induced distortions in the DTI data. TOPUP is a technique used to adjust for susceptibility-induced distortions, particularly in areas like the orbitofrontal cortex.

6. **Mean B0 Image**  
   Averages the B0 images across all acquisitions, creating a high-quality, motion-free reference image that will be used for spatial alignment in the following steps.

7. **Binary Brain Mask**  
   Creates a binary mask representing the brain region, separating brain tissue from non-brain structures (e.g., background, skull) for downstream analysis.

8. **MRDegibbes**  
   Removes 250 high-gradient shell images that caused volume distortions during diffusion-weighted imaging (DWI) acquisitions. This is done to improve the overall quality of the dataset.

9. **Eddy Current Correction**  
   Applies corrections for eddy current-induced distortions in the DWI data. Eddy currents are often generated during the rapid switching of gradient fields, causing geometric distortions in the acquired images.

10. **DWI Extraction**  
   Extracts the diffusion-weighted images (DWI) from the raw data, isolating the specific data used to calculate diffusion metrics (e.g., Fractional Anisotropy, Mean Diffusivity).

11. **DTI Fit**  
   Fits the diffusion tensor model to the DWI data to compute key diffusion parameters, such as Eigenvalues and Eigenvectors, from which diffusion metrics are derived.

12. **FLIRT and Convert**  
   Performs registration using FMRIB's Linear Image Registration Tool (FLIRT) to align the data to a standard space or reference. This step is included but is not run as we're not doing probabilistic tractography in this pipeline.

13. **AFQ Prep - BIDS Conversion**  
   Prepares the data in the Brain Imaging Data Structure (BIDS) format. This step ensures that the data can be processed by AFQ (Automated Fiber Quantification), which requires specific file organization. This is crucial for making the data compatible with AFQ.

14. **ICV Calculation**  
   Computes the Intracranial Volume (ICV), an important measure for brain size and normalization. It is often used in neuroimaging studies as a covariate in analyses.

15. **pyAFQ Tutorial**  
   Provides a tutorial for running pyAFQ (Python-based Automated Fiber Quantification). This step guides you through the process of preparing and running fiber tractography-based analysis of DTI data.

## Other Files:
### R Scripts:
These R scripts demonstrate how to:
- Merge the output from pyAFQ (tract node data) with behavioral data, linking neuroimaging findings with cognitive or behavioral outcomes.
- Convert this output into a normalized format that is compatible with downstream analysis tools.
- Generate tract-wise data for each fiber tract (100 nodes per participant) and save them as individual CSV files, with each CSV representing a single tract's data for all participants.

**Note:** This dataset contains de-identified node-wise data, which serves as the raw dataset for Project LITe. All identifying information has been removed to ensure participant privacy.

### Next Folder: **pyAFQ**
Contains an example dataset and the necessary structure for running pyAFQ. This includes:
- BIDS derivatives (preprocessed neuroimaging data in BIDS format)
- JSON files specifying imaging parameters for pyAFQ
The example data in this folder is provided for template purposes only and is not real participant data.

### Next: **Config Files**
This folder contains the crucial configuration files for both the pyAFQ pipeline and the preprocessing steps. These configuration files specify the parameters, preprocessing settings, and analysis options required to run the pipeline correctly. It is essential to modify these files according to your specific dataset and research needs.
