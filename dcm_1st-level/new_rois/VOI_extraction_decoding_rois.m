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
subject_folder = {'sub-006' 'sub-007' 'sub-008' 'sub-009' 'sub-010'};

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

% EXTRACTING TIME SERIES: S1 (BA1, BA2, BA3b)
%--------------------------------------------------------------------------
matlabbatch{1}.spm.util.voi.spmmat = {specified_glm};
matlabbatch{1}.spm.util.voi.adjust = 0;  
matlabbatch{1}.spm.util.voi.session = 1; % session 1
matlabbatch{1}.spm.util.voi.name = 'S1';

matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat = {''};
matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast = 3;
% matlabbatch{1}.spm.util.voi.roi{1}.spm.conjunction = 2; % global conjunction (logical OR) between contrasts
matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh = 0.001; % you can increase it if you get empty VOIs
matlabbatch{1}.spm.util.voi.roi{1}.spm.extent = 0;
matlabbatch{1}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
matlabbatch{1}.spm.util.voi.roi{2}.sphere.centre = [52 -12 46];
matlabbatch{1}.spm.util.voi.roi{2}.sphere.radius = 8;
matlabbatch{1}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
matlabbatch{1}.spm.util.voi.expression = 'i1 & i2'; % logical AND between the two criteria (threshold and fixed sphere based on coordinates)

% EXTRACTING TIME SERIES: S2
%--------------------------------------------------------------------------
matlabbatch{2}.spm.util.voi.spmmat = {specified_glm};
matlabbatch{2}.spm.util.voi.adjust = 0;  
matlabbatch{2}.spm.util.voi.session = 1; % session 1
matlabbatch{2}.spm.util.voi.name = 'S2';

matlabbatch{2}.spm.util.voi.roi{1}.spm.spmmat = {''};
matlabbatch{2}.spm.util.voi.roi{1}.spm.contrast = 3;
% matlabbatch{2}.spm.util.voi.roi{1}.spm.conjunction = 2; % global conjunction (logical OR) between contrasts
matlabbatch{2}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
matlabbatch{2}.spm.util.voi.roi{1}.spm.thresh = 0.001; % you can increase it if you get empty VOIs
matlabbatch{2}.spm.util.voi.roi{1}.spm.extent = 0;
matlabbatch{2}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
matlabbatch{2}.spm.util.voi.roi{2}.sphere.centre = [-50 -34 22];
matlabbatch{2}.spm.util.voi.roi{2}.sphere.radius = 8;
matlabbatch{2}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
matlabbatch{2}.spm.util.voi.expression = 'i1 & i2'; % logical AND between the two criteria (threshold and fixed sphere based on coordinates)

% EXTRACTING TIME SERIES: left IPL
%--------------------------------------------------------------------------
matlabbatch{3}.spm.util.voi.spmmat = {specified_glm};
matlabbatch{3}.spm.util.voi.adjust = 0;  
matlabbatch{3}.spm.util.voi.session = 1; % session 1
matlabbatch{3}.spm.util.voi.name = 'left_IPL';

matlabbatch{3}.spm.util.voi.roi{1}.spm.spmmat = {''};
matlabbatch{3}.spm.util.voi.roi{1}.spm.contrast = 3;
% matlabbatch{3}.spm.util.voi.roi{1}.spm.conjunction = 2; % global conjunction (logical OR) between contrasts
matlabbatch{3}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
matlabbatch{3}.spm.util.voi.roi{1}.spm.thresh = 0.001; % you can increase it if you get empty VOIs
matlabbatch{3}.spm.util.voi.roi{1}.spm.extent = 0;
matlabbatch{3}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
matlabbatch{3}.spm.util.voi.roi{2}.sphere.centre = [48 -26 26];
matlabbatch{3}.spm.util.voi.roi{2}.sphere.radius = 8;
matlabbatch{3}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
matlabbatch{3}.spm.util.voi.expression = 'i1 & i2'; % logical AND between the two criteria (threshold and fixed sphere based on coordinates)

spm_jobman('run',matlabbatch);

 % % Move VOI files from GLM to VOI folder
    
voi_mat_pattern = '^VOI_.*\.mat$';
 voi_mat_files = spm_select('FPList', glm_folder_path, voi_mat_pattern);
    
    if isempty(voi_mat_files)
        warning('No VOI .mat files found for subject %s', subject_folder{i});
    else
          for j = 1:size(voi_mat_files, 1)
            current_file = deblank(voi_mat_files(j, :));           
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
            full_file_path_nii = fullfile(glm_folder_path, [base_nii_file '.nii']);
            movefile(full_file_path_nii, VOI_folder_path);
        end
     end
end