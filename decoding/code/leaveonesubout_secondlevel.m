% This script builts on the results from the svmmultisub.m and does a
% specifity analysis as proposed by PAPER EINFÜGEN, to test if ...
% For this, the second-level-GLM and t-contrast are estimated in a leave
% one subject out fashion.

%% specification
% Store all the accuracy maps from the decoding anaylsis in a variable
scans = {
    'C:\data\Decoding\results_ldamultisub\sub-001\res_accuracy_minus_chance.nii,1'
    'C:\data\Decoding\results_ldamultisub\sub-002\res_accuracy_minus_chance.nii,1'
    'C:\data\Decoding\results_ldamultisub\sub-003\res_accuracy_minus_chance.nii,1'
    'C:\data\Decoding\results_ldamultisub\sub-004\res_accuracy_minus_chance.nii,1'
    'C:\data\Decoding\results_ldamultisub\sub-005\res_accuracy_minus_chance.nii,1'
    'C:\data\Decoding\results_ldamultisub\sub-006\res_accuracy_minus_chance.nii,1'
    'C:\data\Decoding\results_ldamultisub\sub-007\res_accuracy_minus_chance.nii,1'
    'C:\data\Decoding\results_ldamultisub\sub-008\res_accuracy_minus_chance.nii,1'
    'C:\data\Decoding\results_ldamultisub\sub-009\res_accuracy_minus_chance.nii,1'
    'C:\data\Decoding\results_ldamultisub\sub-010\res_accuracy_minus_chance.nii,1'
};

% Specifiy the bae directory to store the results in
output_base_dir = 'C:\data\Decoding\sensitivityana';

% Loop to leave each subject out once
for i = 1:10
    % Create a new directory for each iteration to store the results in
    output_dir = fullfile(output_base_dir, sprintf('iteration_%02d', i));
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    clear matlabbatch
    
    % Create a new batch structure 
    matlabbatch{1}.spm.stats.factorial_design.dir = {output_dir};
    
    % Select the scans for each iteration, leaving the i-th scan out
    selected_scans = scans;
    selected_scans(i) = [];
    
    % Put the selected scans in the to the matlabbatch
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = selected_scans;
    
    % Use the default SPM 12 values
    matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
    
    % Run the batch
    spm_jobman('run', matlabbatch);
    
end

%% model estimaton 

% List to store paths to the SPM.mat files
spmmat_paths = cell(1, 10);

% Put in the list the paths to the SPM.mat files from each iteration
for i = 1:10
    spmmat_paths{i} = fullfile(output_base_dir, sprintf('iteration_%02d', i), 'SPM.mat');
end

% Loop over each SPM.mat file to estimate all 10 models
for i = 1:10
    iteration_dir = fullfile(output_base_dir, sprintf('iteration_%02d', i));

    clear matlabbatch;
    matlabbatch = cell(1, 1);
    
    matlabbatch{1}.spm.stats.fmri_est.spmmat = {spmmat_paths{i}};
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    
    % Change directory to the iteration folder to make sure the results are
    % stored where I want them to be
    cd(iteration_dir);
    
    % Run the batch
    spm_jobman('run', matlabbatch);
end

%% t-contrast 

spmmat_paths = cell(1, 10);
for i = 1:10
    spmmat_paths{i} = fullfile(output_base_dir, sprintf('iteration_%02d', i), 'SPM.mat');
end

% Loop over each SPM.mat file to compute the 10 contrast images
for i = 1:10
    iteration_dir = fullfile(output_base_dir, sprintf('iteration_%02d', i));
    
    clear matlabbatch;
    matlabbatch = cell(1, 1);
    
    % Batch configuration for contrasts
    matlabbatch{1}.spm.stats.con.spmmat = {spmmat_paths{i}};
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Accuracy > 0';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = 1;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{1}.spm.stats.con.delete = 0;
    
    
    % Run the contrast batch
    spm_jobman('run', matlabbatch);
      
end