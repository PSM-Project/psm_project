% Ths script is based on the SPM batch system and computes a second level
% analysis based on the results of the subject-specific decoding analysis
% performed within the svmmultisub.m script. It specifies and estimates a
% second level GLM with the default parameters set in SPM 12 and afterwards
% computes a one-sample-t-test to test in which brain regions the
% classifier classifies the Imagery vs Stimulus conditions above chance

%% model specification
clear matlabbatch 

matlabbatch{1}.spm.stats.factorial_design.dir = {'C:\data\Decoding\groupresults_svm'};

matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = {
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
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

spm_jobman('run', matlabbatch);

%% model estmation
clear matlabbatch
matlabbatch{1}.spm.stats.fmri_est.spmmat = {'C:\data\Decoding\groupresults_svm\SPM.mat'};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

spm_jobman('run', matlabbatch);

%% compute the t-contrast

clear matlabbatch

matlabbatch{1}.spm.stats.con.spmmat = {'C:\data\Decoding\groupresults_svm\SPM.mat'};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Accuracy > 0';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = 1;
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.delete = 0;

spm_jobman('run', matlabbatch);
