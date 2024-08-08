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
subject_folder = {'sub-001' 'sub-002'};

%% DCM Estimation
for j = 1:numel(subject_folder) % for loop from 1 to number of elements in folder_sub

    S = []; % init empty structure
    S.data_folder_path = data_folder_path; % add data folder path
    S.subject_folder = subject_folder{j}; % add subject path
    
    glm_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'GLM');     % defining GLM folder path
    specified_glm = spm_select('FPList', glm_folder_path, '^SPM.mat$');

    VOI_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'VOI');     % defining VOI folder path

    DCM_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'DCM');

matlabbatch = [];
matlabbatch{1}.spm.dcm.fmri.estimate.dcmmat = {...
    fullfile(DCM_folder_path, 'DCM_m1_null.mat') ...
    fullfile(DCM_folder_path,'DCM_m16_full.mat')}; ...

spm_jobman('run',matlabbatch);

end