%% Time Series Extraction
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
subject_folder = {'sub-001' 'sub-002' 'sub-003' 'sub-004' 'sub-005' 'sub-006' 'sub-007' 'sub-009' 'sub-010'};

%% DCM Estimation
for j = 1:numel(subject_folder) % for loop from 1 to number of elements in folder_sub

    S = []; % init empty structure
    S.data_folder_path = data_folder_path; % add data folder path
    S.subject_folder = subject_folder{j}; % add subject path

    DCM_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'DCM');
    addpath(DCM_folder_path)

% Bayesian Model Comparison
%--------------------------------------------------------------------------
DCM_m1_null = load('DCM_m1_null.mat','F');
DCM_m2_stimBU = load('DCM_m2_stimBU.mat','F');
DCM_m3_stimTD = load('DCM_m3_stimTD.mat','F');
DCM_m4_stimBU_stimTD = load('DCM_m4_stimBU_stimTD.mat','F');
DCM_m5_imagBU = load('DCM_m5_imagBU.mat','F');
DCM_m6_stimBU_imagBU = load('DCM_m6_stimBU_imagBU.mat','F');
DCM_m7_stimTD_imagBU = load('DCM_m7_stimTD_imagBU.mat','F');
DCM_m8_stimBU_stimTD_imagBU = load('DCM_m8_stimBU_stimTD_imagBU.mat','F');
DCM_m9_imagTD = load('DCM_m9_imagTD.mat','F');
DCM_m10_stimBU_imagTD = load('DCM_m10_stimBU_imagTD.mat','F');
DCM_m11_stimTD_imagTD = load('DCM_m11_stimTD_imagTD.mat','F');
DCM_m12_stimBU_stimTD_imagTD = load('DCM_m12_stimBU_stimTD_imagTD.mat','F');
DCM_m13_imagBU_imagTD = load('DCM_m13_imagBU_imagTD','F');
DCM_m14_stimBU_imagBU_imagTD = load('DCM_m14_stimBU_imagBU_imagTD','F');
DCM_m15_stimTD_stimBU_imagTD = load('DCM_m15_stimTD_stimBU_imagTD.mat','F');
DCM_m16_full = load('DCM_m16_full','F');

% Array of model names for display purposes
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