%% Model Inference (F: Free energy approximation to log model evidence)
% This script takes the estimated DCM models to compute the F values of
% each model for each subject and outputs them as 1. bar plots of log
% evidence and probability and 2. a txt file with log evidence values for
% each model.
%Angela Seo
%-----------------------------------------------------------------------------------------


% initializing SPM
spm_path = '/Users/angelaseo/Documents/spm-main'; % Enter the path of your SPM folder

% set local data path
data_folder_path = '/Users/angelaseo/Desktop/PSM_Project/PSM_data'; % Enter the root path of where your data is stored

% add paths
addpath(spm_path)
addpath(data_folder_path)

spm('defaults', 'fmri')
spm_jobman('initcfg')

% specifying data, participant and run paths
subject_folder = {'sub-001'};

for j = 1:numel(subject_folder) % for loop from 1 to number of elements in folder_sub

    S = [];
    S.data_folder_path = data_folder_path; 
    S.subject_folder = subject_folder{j}; 

    DCM_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'DCM');
    addpath(DCM_folder_path)

    matlabbatch = [];
    models = {fullfile(DCM_folder_path, 'DCM_m1_null.mat'); ...
        fullfile(DCM_folder_path, 'DCM_m2_stimBU.mat'); ...
        fullfile(DCM_folder_path, 'DCM_m3_stimTD.mat');...
        fullfile(DCM_folder_path, 'DCM_m4_stimBU_stimTD.mat'); ...
        fullfile(DCM_folder_path, 'DCM_m5_imagBU.mat'); ...
        fullfile(DCM_folder_path, 'DCM_m6_stimBU_imagBU.mat'); ...
        fullfile(DCM_folder_path, 'DCM_m7_stimTD_imagBU.mat'); ...
        fullfile(DCM_folder_path, 'DCM_m8_stimBU_stimTD_imagBU.mat'); ...
        fullfile(DCM_folder_path, 'DCM_m9_imagTD.mat'); ...
        fullfile(DCM_folder_path, 'DCM_m10_stimBU_imagTD.mat'); ...
        fullfile(DCM_folder_path, 'DCM_m11_stimTD_imagTD.mat'); ...
        fullfile(DCM_folder_path, 'DCM_m12_stimBU_stimTD_imagTD.mat'); ...
        fullfile(DCM_folder_path, 'DCM_m13_imagBU_imagTD.mat'); ...
        fullfile(DCM_folder_path, 'DCM_m14_stimBU_imagBU_imagTD.mat'); ...
        fullfile(DCM_folder_path, 'DCM_m15_stimTD_stimBU_imagTD.mat'); ...
        fullfile(DCM_folder_path, 'DCM_m16_full.mat')
        };
    matlabbatch{1}.spm.dcm.bms.inference.dir = {DCM_folder_path};

    matlabbatch{1}.spm.dcm.bms.inference.sess_dcm{1}.dcmmat = models;

    matlabbatch{1}.spm.dcm.bms.inference.model_sp = {''};
    matlabbatch{1}.spm.dcm.bms.inference.load_f = {''};
    matlabbatch{1}.spm.dcm.bms.inference.method = 'FFX';
    matlabbatch{1}.spm.dcm.bms.inference.family_level.family_file = {''};
    matlabbatch{1}.spm.dcm.bms.inference.bma.bma_no = 0;
    matlabbatch{1}.spm.dcm.bms.inference.verify_id = 1;

    spm_jobman('run', matlabbatch)

    % Save the resulting figures in the figures folder
    %--------------------------------------------------------------
        % received help for this section from ChatGPT
    figHandles = findall(0, 'Type', 'figure'); % Find all figure handles
    figures_folder = fullfile(DCM_folder_path, 'ModelComparisonFigures');
    subject = subject_folder{j}; % Get the current subject ID

    if ~exist(figures_folder, 'dir')
        mkdir(figures_folder);
    end

    for i = 1:length(figHandles)
        figHandle = figHandles(i);
        figName = sprintf('ModelComparison_%s_Figure_%d.png', subject, j);
        saveas(figHandle, fullfile(figures_folder, figName)); % Save the figure in the folder
        close(figHandle); % Close the figure after saving
    end

    %% To save Free energy approximation to log model evidence outputs as txt
    %--------------------------------------------------------------
    model_names = {
        'm1_null', 'm2_stimBU', 'm3_stimTD', 'm4_stimBU_stimTD', ...
        'm5_imagBU', 'm6_stimBU_imagBU', 'm7_stimTD_imagBU', 'm8_stimBU_stimTD_imagBU', ...
        'm9_imagTD', 'm10_stimBU_imagTD', 'm11_stimTD_imagTD', 'm12_stimBU_stimTD_imagTD', ...
        'm13_imagBU_imagTD', 'm14_stimBU_imagBU_imagTD', 'm15_stimTD_stimBU_imagTD', 'm16_full'
        };

    % Array to hold the model evidences
    model_evidences = [
        DCM_m1_null.F, DCM_m2_stimBU.F, DCM_m3_stimTD.F, DCM_m4_stimBU_stimTD.F, ...
        DCM_m5_imagBU.F, DCM_m6_stimBU_imagBU.F, DCM_m7_stimTD_imagBU.F, DCM_m8_stimBU_stimTD_imagBU.F, ...
        DCM_m9_imagTD.F, DCM_m10_stimBU_imagTD.F, DCM_m11_stimTD_imagTD.F, DCM_m12_stimBU_stimTD_imagTD.F, ...
        DCM_m13_imagBU_imagTD.F, DCM_m14_stimBU_imagBU_imagTD.F, DCM_m15_stimTD_stimBU_imagTD.F, DCM_m16_full.F
        ];

    % Open a file to write the model evidence for each subject
    output_file_path = fullfile(DCM_folder_path, 'model_evidence.txt');
    file_id = fopen(output_file_path, 'w'); % Open the file for writing

    % Check if the file opened successfully
    if file_id == -1
        error('Failed to open the file for writing: %s', output_file_path);
    end

    % Print the model evidence for each model and write it to the file
    for i = 1:length(model_evidences)
        fprintf(file_id, 'Subject: %s, Model evidence for %s: %f\n', S.subject_folder, model_names{i}, model_evidences(i));
    end

    fclose(file_id); % Close the file after writing


end