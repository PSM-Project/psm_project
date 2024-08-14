%% Extracting Posterior Parameters for One DCM Model
% This script takes the estimated DCM files for one subject and extracts
% posterior parameters for one model at a time. Outputs are the following:
% 1. bar plot with posterior estimates, variance, and probability of given
% model and 2. txt file with each parameter for each connection
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

subject_folder = {'sub-007'};

for j = 1:numel(subject_folder) % for loop from 1 to number of elements in folder_sub

    S = []; % creating an empty structue to store data path and subject folder j
    S.data_folder_path = data_folder_path; % add data folder path
    S.subject_folder = subject_folder{j}; % add subject path

    DCM_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'DCM');
    addpath(DCM_folder_path)

% Load the DCM model file
load('DCM_m4_stimBU_stimTD.mat'); % estimated model

%Extracting Matrix Parameters
%--------------------------------------------------------------
% Extract posterior estimates of each matrix
ep_posterior_A = DCM.Ep.A;  % Intrinsic connections
ep_posterior_B = DCM.Ep.B;  % Modulatory connections
ep_posterior_C = DCM.Ep.C;  % Driving inputs

% Extract posterior variance estimates of each matrix
vp_posterior_A = DCM.Vp.A;  % Intrinsic connections
vp_posterior_B = DCM.Vp.B;  % Modulatory connections
vp_posterior_C = DCM.Vp.C;  % Driving inputs

% Extract posterior probability estimates of each matrix
pp_posterior_A = DCM.Pp.A;  % Intrinsic connections
pp_posterior_B = DCM.Pp.B;  % Modulatory connections
pp_posterior_C = DCM.Pp.C;  % Driving inputs


% Extract parameters for each connection
%-----------------------------------------------------------------------------------------
%Intrinsic Connections EP
ep_endog_S1toS2 = ep_posterior_A(2, 1);
ep_endog_S2toS1 = ep_posterior_A(1,2);
ep_endog_S2toIPL = ep_posterior_A(2,3);
ep_endog_IPL_toS2 = ep_posterior_A(3,2);

% Intrinsic connections VP
vp_endog_S1toS2 = vp_posterior_A(2, 1);
vp_endog_S2toS1 = vp_posterior_A(1,2);
vp_endog_S2toIPL = vp_posterior_A(2,3);
vp_endog_IPL_toS2 = vp_posterior_A(3,2);

% Intrinsic connections PP
pp_endog_S1toS2 = pp_posterior_A(2, 1);
pp_endog_S2toS1 = pp_posterior_A(1,2);
pp_endog_S2toIPL = pp_posterior_A(2,3);
pp_endog_IPL_toS2 = pp_posterior_A(3,2);

% Modulatory connection EP
ep_StimBU_S1toS2 = ep_posterior_B(2,1,1);   % (y,x,z) --> (column, row of non-zero element, dimension: (1=stim,2=imag))
ep_StimBU_S2toIPL = ep_posterior_B(3,2,1);
ep_ImagTD_S2toS1 = ep_posterior_B(1,2,2);
ep_ImagTD_IPLtoS2 = ep_posterior_B(2,3,2);

ep_StimTD_S2toS1 = ep_posterior_B(1,2,1);   
ep_StimTD_IPLtoS2 = ep_posterior_B(2,3,1);
ep_ImagBU_S1toS2 = ep_posterior_B(2,1,2);
ep_ImagBU_S2toIPL = ep_posterior_B(3,2,2);

% Modulatory connection VP
vp_StimBU_S1toS2 = vp_posterior_B(2,1,1);   
vp_StimBU_S2toIPL = vp_posterior_B(3,2,1);
vp_ImagTD_S2toS1 = vp_posterior_B(1,2,2);
vp_ImagTD_IPLtoS2 = vp_posterior_B(2,3,2);

vp_StimTD_S2toS1 = vp_posterior_B(1,2,1);   
vp_StimTD_IPLtoS2 = vp_posterior_B(2,3,1);
vp_ImagBU_S1toS2 = vp_posterior_B(2,1,2);
vp_ImagBU_S2toIPL = vp_posterior_B(3,2,2);

% Modulatory connection PP
pp_StimBU_S1toS2 = pp_posterior_B(2,1,1);   
pp_StimBU_S2toIPL = pp_posterior_B(3,2,1);
pp_ImagTD_S2toS1 = pp_posterior_B(1,2,2);
pp_ImagTD_IPLtoS2 = pp_posterior_B(2,3,2);

pp_StimTD_S2toS1 = pp_posterior_B(1,2,1);   
pp_StimTD_IPLtoS2 = pp_posterior_B(2,3,1);
pp_ImagBU_S1toS2 = pp_posterior_B(2,1,2);
epp_ImagBU_S2toIPL = pp_posterior_B(3,2,2);

% Driving input EP
ep_driving_input_Stimulation_S1 = ep_posterior_C(1,1);
ep_driving_input_Imagery_S1 =  ep_posterior_C(1,2);

% Driving input VP
vp_driving_input_Stimulation_S1 = vp_posterior_C(1,1);
vp_driving_input_Imagery_S1 =  vp_posterior_C(1,2);

% Driving input PP
pp_driving_input_Stimulation_S1 = pp_posterior_C(1,1);
pp_driving_input_Imagery_S1 =  pp_posterior_C(1,2);


%Saving a TXT File with Posterior Parameters in Subject DCM folder
% Portions of this section was written with the help of ChatGPT
%-----------------------------------------------------------------------------------------
% Define the file path for saving
    output_file_path = fullfile(DCM_folder_path, 'DCM_values_M4.txt'); % change output file title according to model

    % Open the file for writing
    fid = fopen(output_file_path, 'w');

    % Write header information
    fprintf(fid, 'Posterior Estimates (Ep), Variances (Vp), and Precisions (Pp):\n');

    % Write Intrinsic Connections
    fprintf(fid, '\nIntrinsic Connections:\n');
    fprintf(fid, 'S1 to S2:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_posterior_A(2, 1));
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_A(2, 1));
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_A(2, 1));

    fprintf(fid, 'S2 to S1:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_posterior_A(1, 2));
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_A(1, 2));
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_A(1, 2));

    fprintf(fid, 'S2 to IPL:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_posterior_A(2, 3));
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_A(2, 3));
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_A(2, 3));

    fprintf(fid, 'IPL to S2:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_posterior_A(3, 2));
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_A(3, 2));
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_A(3, 2));

    % Write Modulatory Connections
    fprintf(fid, '\nModulatory Connections (StimBU):\n');
    fprintf(fid, 'S1 to S2:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_StimBU_S1toS2);
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_B(2, 1, 1)); 
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_B(2, 1, 1));
    
    fprintf(fid, 'S2 to IPL:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_StimBU_S2toIPL);
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_B(3, 2, 1));
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_B(3, 2, 1));
    
    fprintf(fid, '\nModulatory Connections (ImagTD):\n');
    fprintf(fid, 'S2 to S1:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_ImagTD_S2toS1);
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_B(1, 2, 2)); 
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_B(1, 2, 2));
    
    fprintf(fid, 'IPL to S2:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_ImagTD_IPLtoS2);
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_B(2, 3, 2));
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_B(2, 3, 2));
    
    fprintf(fid, '\nModulatory Connections (StimTD):\n');
    fprintf(fid, 'S2 to S1:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_StimTD_S2toS1);
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_B(1, 2, 1)); 
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_B(1, 2, 1));
    
    fprintf(fid, 'IPL to S2:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_StimTD_IPLtoS2);
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_B(2, 3, 1));
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_B(2, 3, 1));
    
    fprintf(fid, '\nModulatory Connections (ImagBU):\n');
    fprintf(fid, 'S1 to S2:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_ImagBU_S1toS2);
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_B(2, 1, 2)); 
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_B(2, 1, 2));
    
    fprintf(fid, 'S2 to IPL:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_ImagBU_S2toIPL);
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_B(3, 2, 2));
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_B(3, 2, 2));


    % Write Driving Inputs
    fprintf(fid, '\nDriving Inputs:\n');
    fprintf(fid, 'Stimulation to S1:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_posterior_C(1, 1));
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_C(1, 1));
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_C(1, 1));

    fprintf(fid, 'Imagery to S1:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_posterior_C(1, 2));
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_C(1, 2));
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_C(1, 2));

    % Close the file
    fclose(fid);

% Plot Parameters into a Bar Plot
%--------------------------------------------------------------
% Portions of this section were created with the help of ChatGPT
% Define the file path for saving the bar plot
plot_file_path = fullfile(DCM_folder_path, 'ModelComparisonFigures', 'Model4_parameters_plot.png');

% Define connections and corresponding values (excluding driving inputs)
connections = {'Endogenous: S1 to S2', 'Endogenous: S2 to S1', ...
                'Endogenous: S2 to IPL', 'Endogenous: IPL to S2', ...
                'Stimulation modulating S1 to S2', 'Stimulation modulating S2 to IPL', ...
                'Imagery modulating S2 to S1', 'Imagery modulating IPL to S2'};

% Combine posterior estimates (Ep), variances (Vp), precisions (Pp) for endogenous and modulatory connections
ep_values = [ep_endog_S1toS2, ep_endog_S2toS1, ep_endog_S2toIPL, ep_endog_IPL_toS2, ...
             ep_StimBU_S1toS2, ep_StimBU_S2toIPL, ...
             ep_ImagTD_S2toS1, ep_ImagTD_IPLtoS2];

vp_values = [vp_endog_S1toS2, vp_endog_S2toS1, vp_endog_S2toIPL, vp_endog_IPL_toS2, ...
             vp_StimBU_S1toS2, vp_StimBU_S2toIPL, ...
             vp_ImagTD_S2toS1, vp_ImagTD_IPLtoS2];

pp_values = [pp_endog_S1toS2, pp_endog_S2toS1, pp_endog_S2toIPL, pp_endog_IPL_toS2, ...
             pp_StimBU_S1toS2, pp_StimBU_S2toIPL, ...
             pp_ImagTD_S2toS1, pp_ImagTD_IPLtoS2];

% Define a threshold for probabilities
threshold = 0.95;

% Create the bar plot
figure;
bar(ep_values, 'FaceColor', [0.5 0.7 1]); % Bar colors for estimates

% Add error bars
hold on;
errorbar(1:numel(ep_values), ep_values, sqrt(vp_values), 'k.', 'LineWidth', 1.5); % Variance error bars

% Add asterisks for probabilities above the threshold
ylims = ylim; % Get y-axis limits for positioning
for i = 1:numel(pp_values)
    if pp_values(i) > threshold
        text(i, ep_values(i) + 0.1 * diff(ylims), '*', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    end
end

% Customize plot appearance
set(gca, 'XTick', 1:numel(connections), 'XTickLabel', connections, 'XTickLabelRotation', 45);
ylabel('Posterior Estimates (Ep)');
xlabel('Connections');
title('Model 4');
legend('Posterior Estimates (Ep)', 'Variance (Vp)', 'Location', 'Best');
grid on;

% Save the plot
saveas(gcf, plot_file_path);

% Close the figure
close(gcf);
end