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

%% DCM Estimation
for j = 1:numel(subject_folder) % for loop from 1 to number of elements in folder_sub

    S = []; % init empty structure
    S.data_folder_path = data_folder_path; % add data folder path
    S.subject_folder = subject_folder{j}; % add subject path

    DCM_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'DCM');
    addpath(DCM_folder_path)

% Load the DCM model file
load('DCM_m10_stimBU_imagTD.mat'); % estimated model

% Extract posterior estimates of each matrix
ep_posterior_A = DCM.Ep.A;  % Intrinsic connections
ep_posterior_B = DCM.Ep.B;  % Modulatory connections
ep_posterior_C = DCM.Ep.C;  % Driving inputs

% Extract posterior variance estimates of each matrix
vp_posterior_A = DCM.Vp.A;  % Intrinsic connections
vp_posterior_B = DCM.Vp.B;  % Modulatory connections
vp_posterior_C = DCM.Vp.C;  % Driving inputs

% Extract posterior variance estimates of each matrix
pp_posterior_A = DCM.Pp.A;  % Intrinsic connections
pp_posterior_B = DCM.Pp.B;  % Modulatory connections
pp_posterior_C = DCM.Pp.C;  % Driving inputs

%% For each connection

% Intrinsic connection from region 1 to region 2
ep_endog_S1toS2 = ep_posterior_A(2, 1);
ep_endog_S2toS1 = ep_posterior_A(1,2);
ep_endog_S2toIPL = ep_posterior_A(2,3);
ep_endog_IPL_toS2 = ep_posterior_A(3,2);

% Intrinsic connection from region 1 to region 2
vp_endog_S1toS2 = vp_posterior_A(2, 1);
vp_endog_S2toS1 = vp_posterior_A(1,2);
vp_endog_S2toIPL = vp_posterior_A(2,3);
vp_endog_IPL_toS2 = vp_posterior_A(3,2);

% Intrinsic connection from region 1 to region 2
pp_endog_S1toS2 = pp_posterior_A(2, 1);
pp_endog_S2toS1 = pp_posterior_A(1,2);
pp_endog_S2toIPL = pp_posterior_A(2,3);
pp_endog_IPL_toS2 = pp_posterior_A(3,2);

% Modulatory connection from region 1 to region 2 for the first condition
ep_StimBU_S1toS2 = ep_posterior_B(2,1,1);   % (y,x,z) --> (column, row, dimension)
ep_StimBU_S2toIPL = ep_posterior_B(3,2,1);
ep_ImagTD_S2toS1 = ep_posterior_B(1,2,2);
ep_ImagTD_IPLtoS2 = ep_posterior_B(2,3,2);

% Modulatory connection from region 1 to region 2 for the first condition
vp_StimBU_S1toS2 = vp_posterior_B(2,1,1);   % (y,x,z) --> (column, row, dimension)
vp_StimBU_S2toIPL = vp_posterior_B(3,2,1);
vp_ImagTD_S2toS1 = vp_posterior_B(1,2,2);
vp_ImagTD_IPLtoS2 = vp_posterior_B(2,3,2);

% Modulatory connection from region 1 to region 2 for the first condition
pp_StimBU_S1toS2 = pp_posterior_B(2,1,1);   % (y,x,z) --> (column, row, dimension)
pp_StimBU_S2toIPL = pp_posterior_B(3,2,1);
pp_ImagTD_S2toS1 = pp_posterior_B(1,2,2);
pp_ImagTD_IPLtoS2 = pp_posterior_B(2,3,2);

% Driving input to region 1
ep_driving_input_Stimulation_S1 = ep_posterior_C(1,1);
ep_driving_input_Imagery_S1 =  ep_posterior_C(1,2);

% Driving input to region 1
vp_driving_input_Stimulation_S1 = vp_posterior_C(1,1);
vp_driving_input_Imagery_S1 =  vp_posterior_C(1,2);

% Driving input to region 1
pp_driving_input_Stimulation_S1 = pp_posterior_C(1,1);
pp_driving_input_Imagery_S1 =  pp_posterior_C(1,2);

%% To save txt file with all parameters ep, vp, pp for each connection:
% Define the file path for saving
    output_file_path = fullfile(DCM_folder_path, 'DCM_values.txt');

    % Open the file for writing
    fid = fopen(output_file_path, 'w');

    % Check if file opened successfully
    if fid == -1
        error('Cannot open file %s for writing.', output_file_path);
    end

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
    fprintf(fid, '  Ep: %.4f\n', ep_posterior_B(2, 1, 1));
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_B(2, 1, 1));
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_B(2, 1, 1));

    fprintf(fid, 'S2 to IPL:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_posterior_B(3, 2, 1));
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_B(3, 2, 1));
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_B(3, 2, 1));

    fprintf(fid, '\nModulatory Connections (ImagTD):\n');
    fprintf(fid, 'S2 to S1:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_posterior_B(1, 2, 2));
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_B(1, 2, 2));
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_B(1, 2, 2));

    fprintf(fid, 'IPL to S2:\n');
    fprintf(fid, '  Ep: %.4f\n', ep_posterior_B(2, 3, 2));
    fprintf(fid, '  Vp: %.4f\n', vp_posterior_B(2, 3, 2));
    fprintf(fid, '  Pp: %.4f\n', pp_posterior_B(2, 3, 2));

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

    %% to plot paremeters to bar plot:

    % Define the file path for saving the bar plot
    plot_file_path = fullfile(DCM_folder_path, 'DCM_parameters_plot.png');
    
    % Data preparation
    % Define connections and corresponding values
    connections = {'S1toS2', 'S2toS1', 'S2toIPL', 'IPLtoS2', ...
                    'StimBU_S1toS2', 'StimBU_S2toIPL', ...
                    'ImagTD_S2toS1', 'ImagTD_IPLtoS2', ...
                    'Stimulation_S1', 'Imagery_S1'};
                
    % Posterior estimates (Ep), variances (Vp), precisions (Pp)
    ep_values = [ep_endog_S1toS2, ep_endog_S2toS1, ep_endog_S2toIPL, ep_endog_IPL_toS2, ...
                 ep_StimBU_S1toS2, ep_StimBU_S2toIPL, ...
                 ep_ImagTD_S2toS1, ep_ImagTD_IPLtoS2, ...
                 ep_driving_input_Stimulation_S1, ep_driving_input_Imagery_S1];
    
    vp_values = [vp_endog_S1toS2, vp_endog_S2toS1, vp_endog_S2toIPL, vp_endog_IPL_toS2, ...
                 vp_StimBU_S1toS2, vp_StimBU_S2toIPL, ...
                 vp_ImagTD_S2toS1, vp_ImagTD_IPLtoS2, ...
                 vp_driving_input_Stimulation_S1, vp_driving_input_Imagery_S1];
    
    pp_values = [pp_endog_S1toS2, pp_endog_S2toS1, pp_endog_S2toIPL, pp_endog_IPL_toS2, ...
                 pp_StimBU_S1toS2, pp_StimBU_S2toIPL, ...
                 pp_ImagTD_S2toS1, pp_ImagTD_IPLtoS2, ...
                 pp_driving_input_Stimulation_S1, pp_driving_input_Imagery_S1];

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
    title('Model 10 Posterior Estimates with Variance and Probability');
    legend('Posterior Estimates (Ep)', 'Variance (Vp)', 'Location', 'Best');
    grid on;
    
    % Save the plot
    saveas(gcf, plot_file_path);
    
    % Close the figure
    close(gcf);
end