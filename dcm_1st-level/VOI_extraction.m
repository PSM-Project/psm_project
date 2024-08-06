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
run_folder = {'run-01' 'run-02' 'run-03' 'run-04' 'run-05' 'run-06'};

%%
for i = 1:numel(subject_folder) % for loop from 1 to number of elements in folder_sub

    S = []; % init empty structure
    S.data_folder_path = data_folder_path; % add data folder path
    S.subject_folder = subject_folder{i}; % add subject path
    
    glm_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'GLM');     % defining GLM folder path
    specified_glm = spm_select('FPList', glm_folder_path, '^SPM.mat$');

    VOI_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'VOI');     % defining VOI folder path

    if ~exist(VOI_folder_path, 'dir')     % Check if the 'DCM' folder does not exist
        mkdir(VOI_folder_path);      % Create the 'DCM' folder
    else
        disp('VOI folder already exists.');
    end

matlabbatch = [];

% EXTRACTING TIME SERIES: rBA2
%--------------------------------------------------------------------------
matlabbatch{1}.spm.util.voi.spmmat = {specified_glm};
matlabbatch{1}.spm.util.voi.adjust = 3;  % "effects of interest" F-contrast
matlabbatch{1}.spm.util.voi.session = 1; % session 1
matlabbatch{1}.spm.util.voi.name = 'rBA2';
matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat = {''}; % using SPM.mat above
matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast = [1 2];  
matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh = 0.001;
matlabbatch{1}.spm.util.voi.roi{1}.spm.extent = 0;

 % Search for nearest voxel if no activation found
matlabbatch{1}.spm.util.voi.roi{2}.sphere.centre = [44 -40 60]; % Initial coordinates
matlabbatch{1}.spm.util.voi.roi{2}.sphere.radius = 8; % Initial search radius
matlabbatch{1}.spm.util.voi.roi{2}.sphere.move.local.spm = 1; % Allow SPM to find nearest voxel
matlabbatch{1}.spm.util.voi.expression = 'i1 & i2';

% EXTRACTING TIME SERIES: left temporal pole
%--------------------------------------------------------------------------
matlabbatch{2}.spm.util.voi.spmmat = {specified_glm};
matlabbatch{2}.spm.util.voi.adjust = 3;  % "effects of interest" F-contrast
matlabbatch{2}.spm.util.voi.session = 1; % session 1
matlabbatch{2}.spm.util.voi.name = 'left_temporal_pole';
matlabbatch{2}.spm.util.voi.roi{1}.spm.spmmat = {''}; % using SPM.mat above
matlabbatch{2}.spm.util.voi.roi{1}.spm.contrast = [1 2];  
matlabbatch{2}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
matlabbatch{2}.spm.util.voi.roi{1}.spm.thresh = 0.001;
matlabbatch{2}.spm.util.voi.roi{1}.spm.extent = 0;

 % Search for nearest voxel if no activation found
matlabbatch{2}.spm.util.voi.roi{2}.sphere.centre = [58 6 2]; % Initial coordinates
matlabbatch{2}.spm.util.voi.roi{2}.sphere.radius = 8; % Initial search radius
matlabbatch{2}.spm.util.voi.roi{2}.sphere.move.local.spm = 1; % Allow SPM to find nearest voxel
matlabbatch{2}.spm.util.voi.expression = 'i1 & i2';

% EXTRACTING TIME SERIES: right insula
%--------------------------------------------------------------------------
matlabbatch{3}.spm.util.voi.spmmat = {specified_glm};
matlabbatch{3}.spm.util.voi.adjust = 3;  % "effects of interest" F-contrast
matlabbatch{3}.spm.util.voi.session = 1; % session 1
matlabbatch{3}.spm.util.voi.name = 'right_insula';
matlabbatch{3}.spm.util.voi.roi{1}.spm.spmmat = {''}; % using SPM.mat above
matlabbatch{3}.spm.util.voi.roi{1}.spm.contrast = [1 2];  
matlabbatch{3}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
matlabbatch{3}.spm.util.voi.roi{1}.spm.thresh = 0.001;
matlabbatch{3}.spm.util.voi.roi{1}.spm.extent = 0;

 % Search for nearest voxel if no activation found
matlabbatch{3}.spm.util.voi.roi{2}.sphere.centre = [60 10 2]; % Initial coordinates
matlabbatch{3}.spm.util.voi.roi{2}.sphere.radius = 8; % Initial search radius
matlabbatch{3}.spm.util.voi.roi{2}.sphere.move.local.spm = 1; % Allow SPM to find nearest voxel
matlabbatch{3}.spm.util.voi.expression = 'i1 & i2';

spm_jobman('run',matlabbatch);

 % % Move VOI files from GLM to VOI folder
    
voi_mat_pattern = '^VOI_.*\.mat$';
 voi_mat_files = spm_select('FPList', glm_folder_path, voi_mat_pattern);
    
    if isempty(voi_mat_files)
        warning('No VOI .mat files found for subject %s', subject_folder{i});
    else
          for j = 1:size(voi_mat_files, 1)
            % Get the current file path, trimming spaces
            current_file = deblank(voi_mat_files(j, :));
            
            % Move the file to the VOI folder path
            movefile(current_file, VOI_folder_path);
          end
    end

  
voi_nii_pattern =  '^VOI_.*\.nii$';
voi_nii_files = spm_select('ExtFPList', glm_folder_path, voi_nii_pattern);

     if isempty(voi_nii_files)
        warning('No VOI .nii files found for subject %s', subject_folder{i});
     else
        % Loop through each file path to move individually since 2 nii
        % files are generated per sub
        for j = 1:size(voi_nii_files, 1)
            current_nii_file = deblank(voi_nii_files(j, :));
            
            % Remove the volume specification ',1'
            base_nii_file = spm_file(current_nii_file, 'basename');
            
            % Construct the full file path without volume spec
            full_file_path_nii = fullfile(glm_folder_path, [base_nii_file '.nii']);
            
            % Move the file to the VOI folder path
            movefile(full_file_path_nii, VOI_folder_path);
        end
     end
end