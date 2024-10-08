%% DCM Estimation
% This script takes the specified DCM.mat files from the dcm_specification
% script to estimate the models.
% Angela Seo
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
subject_folder = {'sub-001' 'sub-002' 'sub-003' 'sub-004' 'sub-005' 'sub-006' 'sub-007' 'sub-009' 'sub-010'}es;

%% DCM Estimation
for j = 1:numel(subject_folder) % for loop from 1 to number of elements in folder_sub

    S = []; % creating empty structure to store data path and subject j
    S.data_folder_path = data_folder_path; % add data folder path
    S.subject_folder = subject_folder{j}; % add subject path

    glm_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'GLM');     % defining GLM folder path
    specified_glm = spm_select('FPList', glm_folder_path, '^SPM.mat$');

    VOI_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'VOI');     % defining VOI folder path

    DCM_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'DCM');    %defining DCM folder path

    % Loading in DCM files into matlabbatch
    %-----------------------------------------------------
    matlabbatch = [];
    matlabbatch{1}.spm.dcm.fmri.estimate.dcmmat = {...
        fullfile(DCM_folder_path, 'DCM_m1_null.mat'); ...
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
        fullfile(DCM_folder_path, 'DCM_m16_full.mat')}; ...

    spm_jobman('run',matlabbatch);

end