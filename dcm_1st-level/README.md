To run the first-level analysis, please do the following:
1. Download dataset (preprocessed functional scans of at least run 1 contained in each subject's folder onset and condition name file)
2. Add SPM paths and local data folder path to scripts (exception: 6-dcm_posterior_parameters where DCM.mat file should be specified)
3. Specify for which subject data to run the script on in provided string
4. Run in the following order:
     1-glm.m
     2-voi_extraction.m
     3-dcm_specification.m
     4-dcm_model_comparison.m
     5-dcm_posterior_parameters
