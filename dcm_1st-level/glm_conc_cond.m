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
    S.run_folder = run_folder{i}; % add run path

    glm_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'GLM');     % defining GLM folder path

    if ~exist(glm_folder_path, 'dir')     % Check if the 'GLM' folder does not exist
        mkdir(glm_folder_path);      % Create the 'GLM' folder
    else
        disp('GLM folder already exists.');
    end

    % Define onset information path and load into workspace
    onset_file_path = spm_select('FPList', fullfile(data_folder_path, S.subject_folder), '^all_onsets_.*\.mat$');
    if isempty(onset_file_path)
        error('Onset file not found.');
    end
    load(onset_file_path);

    % MODEL SPECIFICATION
    matlabbatch= [];
    matlabbatch{1}.spm.stats.fmri_spec.dir = {glm_folder_path}; % specifying GLM directory
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;

    for j = 1:numel(run_folder)
        S.run_folder = run_folder{j}; % add run path

        % Select preprocessed func scans
        nifti_files = cellstr(spm_select('ExtFPList', fullfile(data_folder_path, S.subject_folder, S.run_folder), '^ds8wrag.*\.nii$', Inf));
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).scans = nifti_files; % converting nifti_files from character array to cell array

        % Define Conditions
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(1).name = 'Stimulation';
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(1).onset = [onsets{j, 1:3}]; % Extract Stim onsets from workspace
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(1).duration = 3;  % Set duration to 3 seconds
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(1).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(1).orth = 1;

        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(2).name = 'Imagery';
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(2).onset = [onsets{j, 4:6}]; % Extract Stim onsets from workspace
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(2).duration = 3;  % Set duration to 3 seconds
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(2).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(2).orth = 1;

        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(3).name = 'Null_1';
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(3).onset = onsets{j, 7}; % Extract Imag onsets from workspace
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(3).duration = 3; % Set duration to 3 seconds
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(3).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(3).orth = 1;

        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(4).name = 'Null_2';
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(4).onset = onsets{j, 8}; % Extract Imag onsets from workspace
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(4).duration = 3; % Set duration to 3 seconds
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(4).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(4).orth = 1;

        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(5).name = 'preCue';
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(5).onset = onsets{j, 9}; % Extract Imag onsets from workspace
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(5).duration = 3; % Set duration to 3 seconds
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(5).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(5).orth = 1;

        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(6).name = 'Motion';
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(6).onset = onsets{j, 10}; % Extract Imag onsets from workspace
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(6).duration = 3; % Set duration to 3 seconds
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(6).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(6).orth = 1;

        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(7).name = 'badImag';
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(7).onset = onsets{j, 11}; % Extract Imag onsets from workspace
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(7).duration = 0; % Set duration to 0 seconds
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(7).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).cond(7).orth = 1;

        matlabbatch{1}.spm.stats.fmri_spec.sess(j).multi = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).multi_reg = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(j).hpf = 128;
        matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
        matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
        matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
        matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    end % end run loop
    spm_jobman('run', matlabbatch);

    % Estimate
    specified_glm = spm_select('FPList', glm_folder_path, '^SPM.mat$');

    if isempty(specified_glm)
        error('SPM.mat file not found in %s', glm_folder_path);
    end

    matlabbatch = [];
    matlabbatch{1}.spm.stats.fmri_est.spmmat = {specified_glm};
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

    spm_jobman('run', matlabbatch);

    %Contrasts
    glm_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'GLM');     % defining GLM folder path

    specified_glm = spm_select('FPList', glm_folder_path, '^SPM.mat$');

    matlabbatch = [];
    matlabbatch{1}.spm.stats.con.spmmat = {specified_glm};
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Stimulation>Null';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 0 0 0 0];
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Imagery>Null';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 1 0 0 0 0 0];
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{1}.spm.stats.con.consess{3}.fcon.name = 'Effects of Interest';
    matlabbatch{1}.spm.stats.con.consess{3}.fcon.weights = [
        1 0 0 0 0 0 0;
        0 1 0 0 0 0 0];
    matlabbatch{1}.spm.stats.con.consess{3}.fcon.sessrep = 'none';
    matlabbatch{1}.spm.stats.con.delete = 0;

    spm_jobman('run', matlabbatch);
end