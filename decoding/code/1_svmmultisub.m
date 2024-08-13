% This script is an adaption of a script called 'decoding_template.m' which
% is part of The Decoing Toolbox of Martin N Hebart, Kai Görgen and
% John-Dylan Haynes. It has been modified to implement a decoing analysis
% using nonlinear support vector machines in a searchlight approach on
% multisubject fMRI data.
% It assumes that the data is already preprocessed (including smoothing and
% normalizing) and that beta-images from a first level GLM have been computed.

% set neccessary matlab paths
%-----------------------------------------------------------------------------------------

% Add The Decoding Toolbox and SPM to your Matlab path 
% TDT
tdt_path = 'C:\Users\User\Documents\MATLAB\decoding_toolbox'
addpath(tdt_path)
assert(~isempty(which('decoding_defaults.m', 'function')), 'TDT not found in path, please add')
% SPM
spm_path = 'C:\Users\User\Documents\MATLAB\spm12'
addpath(spm_path)
assert((~isempty(which('spm.m', 'function')) || ~isempty(which('BrikInfo.m', 'function'))) , 'Neither SPM nor AFNI found in path, please add (or remove this assert if you really dont need to read brain images)')

% set the configuartion structure and the analysis type
%-----------------------------------------------------------------------------------------

% Set the configuration structure of The Decoding Toolbox to default values
cfg = decoding_defaults;
% Set the decoding method to a classification problem
cfg.decoding.method = 'classification';

% Set the type of decoding analysis that should be performed (here:
% searchlight)
cfg.analysis = 'searchlight'; 
% set the searchlight radius to 3 voxels
cfg.searchlight.radius = 3; 

% prepare the loop over all subjects
%-----------------------------------------------------------------------------------------

% generate as many subject IDs as you have subjects to analyze
subids = generate_subids(10); 
% assign the folder which contains your data

base_dir = 'C:\data\Decoding';

% create an empty variable to eventually create subject specific result
% folders
result_dirs = cell(1, length(subids));

%% loop over all subjects (svm searchlight)
%-----------------------------------------------------------------------------------------

% create the subject specific results folders for the decoding analysis
% that will be performed
for i = 1:length(subids)
    subid = subids{i};
    result_dir = fullfile(base_dir, 'results_svmmultisub', ['sub-', subid]);
    
     if ~isfolder(result_dir)
            mkdir(result_dir);
     end

 % Set results directory in cfg
        cfg.results.dir = result_dir;

        % Set beta location specific to the current subject
        beta_loc = fullfile(base_dir, ['sub-', subid], '1st_level_good_bad_Imag');

        % Set mask file specific to the current subject
        cfg.files.mask = fullfile(base_dir, ['sub-', subid], '1st_level_good_bad_Imag', 'mask.nii');

        % Set label names and values
        labelnames = {'StimPress', 'StimFlutt', 'StimVibro', 'ImagPress', 'ImagFlutt', 'ImagVibro'};
        % Setting the lable values in order to decode the Stimulus
        % Condition vs the Imagery Condition
        labelvalues = [1, 1, 1, -1, -1, -1]; 
       
        % Set the type of decoder you want to use, here we use nonlinear
        % SVM
        cfg.decoding.software = 'libsvm'; 
   
        cfg.decoding.train.classification.model_parameters = struct();
        cfg.decoding.train.classification.model_parameters.shrinkage = 'lw';
        
        % Select if you want to see a plot of the searchlight while the
        % analysis is running (500 meaning every 500th step)
        cfg.plot_selected_voxels = 500; 

        % Select which output measure you want to get from the analysis
        % (here we want to have accuracy maps)
        cfg.results.output = {'accuracy_minus_chance'}; 

        % Extract the regressor names from the first level GLM specified
        % with SPM
        regressor_names = design_from_spm(beta_loc);
        % sat up the configuration structure
        cfg = decoding_describe_data(cfg, labelnames, labelvalues, regressor_names, beta_loc);
        % set up a leave-one-out cross validation design
        cfg.design = make_design_cv(cfg);
  

        % Run decoding and store results for each subject
        results{i} = decoding(cfg);
    end


   
    
