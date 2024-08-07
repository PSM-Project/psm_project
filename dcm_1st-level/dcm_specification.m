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
%% Specify DCM Models
% SPECIFICATION DCMs "attentional modulation of backward/forward connection"
%--------------------------------------------------------------------------
% To specify a DCM, you might want to create a template one using the GUI
% then use spm_dcm_U.m and spm_dcm_voi.m to insert new inputs and new
% regions. The following code creates a DCM file from scratch, which
% involves some technical subtleties and a deeper knowledge of the DCM
% structure.
for j = 1:numel(subject_folder) % for loop from 1 to number of elements in folder_sub

    S = []; % init empty structure
    S.data_folder_path = data_folder_path; % add data folder path
    S.subject_folder = subject_folder{j}; % add subject path
    
    glm_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'GLM');     % defining GLM folder path
    specified_glm = spm_select('FPList', glm_folder_path, '^SPM.mat$');

    VOI_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'VOI');     % defining VOI folder path

    DCM_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'DCM');
    if ~exist(DCM_folder_path, 'dir')     % Check if the 'DCM' folder does not exist
        mkdir(DCM_folder_path);      % Create the 'DCM' folder
    else
        disp('DCM folder already exists.');
    end

load(fullfile(glm_folder_path,'SPM.mat'));

% Load regions of interest into DCM struct
%--------------------------------------------------------------------------
load(fullfile(VOI_folder_path,'VOI_rBA2_1.mat'),'xY');
DCM.xY(1) = xY;
load(fullfile(VOI_folder_path,'VOI_left_temporal_pole_1.mat'),'xY');
DCM.xY(2) = xY;
load(fullfile(VOI_folder_path,'VOI_right_insula_1.mat'),'xY');
DCM.xY(3) = xY;

DCM.n = length(DCM.xY);      % number of regions
DCM.v = length(DCM.xY(1).u); % number of time points

% Time series
%--------------------------------------------------------------------------
DCM.Y.dt  = SPM.xY.RT;
DCM.Y.X0  = DCM.xY(1).X0;
for i = 1:DCM.n
    DCM.Y.y(:,i)  = DCM.xY(i).u;
    DCM.Y.name{i} = DCM.xY(i).name;
end

DCM.Y.Q    = spm_Ce(ones(1,DCM.n)*DCM.v);

% Experimental inputs
%--------------------------------------------------------------------------
% Set the time interval (assuming all sessions have the same dt)
DCM.U.dt = SPM.Sess(1).U(1).dt;

% Concatenate input names from all sessions
DCM.U.name = {'Stimulation', 'Imagery', 'Task'}; % Ensure names are correctly concatenated

% Concatenate input values from all sessions, using the entire matrix
DCM.U.u = [SPM.Sess(1).U(1).u; ...
           SPM.Sess(2).U(2).u; ...
           SPM.Sess(3).U(3).u];

% DCM parameters and options
%--------------------------------------------------------------------------
DCM.delays = repmat(SPM.xY.RT/2,DCM.n,1);
DCM.TE     = 0.03; % Define TE (3000ms)

DCM.options.nonlinear  = 0; % Bilinear modulation
DCM.options.two_state  = 0; % One-state
DCM.options.stochastic = 0; % No stochastic effects
DCM.options.nograph    = 1; %

%  Connectivity matrices for null model
%--------------------------------------------------------------------------
DCM.b = zeros(3,3,3); % No modulation
DCM.c = [0, 0, 1;  % Driving input 3 affects `rBA2`
         0, 0, 0;  % No input to `left_temporal_pole`
         0, 0, 0]; % No input to `right_insula`
% 
 save(fullfile(DCM_folder_path,'DCM_m1_null.mat'),'DCM');

% Connectivity matrices for full model
% --------------------------------------------------------------------------
DCM.a = [1,1,1;1,1,0;1,0,1];
DCM.b = zeros(3,3,3); 
DCM.b = zeros(3,3,3); DCM.b(1,2,1) = 1; DCM.b(1,3,1) = 1; DCM.b(2,1,1) = 1; DCM.b(3,1,1) = 1; DCM.b(1,2,2) = 1; DCM.b(1,3,2) = 1; DCM.b(2,1,2) = 1; DCM.b(3,1,2) = 1; % Defining non-zero entries in 3D matrix B
DCM.c = [0,0,1;0,0,1;0,0,1];
DCM.d = [];

save(fullfile(DCM_folder_path,'DCM_m16_full.mat'),'DCM');

clear matlabbatch

matlabbatch = [];
matlabbatch{1}.spm.dcm.fmri.estimate.dcmmat = {...
    fullfile(DCM_folder_path, 'DCM_full_model.mat')}; ...

spm_jobman('run',matlabbatch);

end