% Auxiliary function to find the nearest suprathreshold cluster
function nearest_centre = find_nearest_cluster(initial_centre, search_radius, specified_glm)

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

for i = 1:numel(subject_folder) % for loop from 1 to number of elements in folder_sub

    S = []; % init empty structure
    S.data_folder_path = data_folder_path; % add data folder path
    S.subject_folder = subject_folder{i}; % add subject path
    
    glm_folder_path = fullfile(S.data_folder_path, S.subject_folder, 'GLM');     % defining GLM folder path
    specified_glm = spm_select('FPList', glm_folder_path, '^SPM.mat$');

    nearest_centre = [];

    % Load the SPM.mat file
    load(specified_glm);

    % Get the statistical map
    V = SPM.xCon(1).Vspm;

    % Load the image data
    Y = spm_read_vols(V);

    % Find suprathreshold voxels
    suprathresh_indices = find(Y > 0.005);  % Adjust the threshold as necessary
    [x, y, z] = ind2sub(size(Y), suprathresh_indices);

    % Convert voxel indices to coordinates
    voxel_coords = V.mat * [x y z ones(size(x))]';
    voxel_coords = voxel_coords(1:3, :)';

    % Calculate distances from the initial centre
    distances = sqrt(sum((voxel_coords - initial_centre).^2, 2));

    % Find the nearest cluster within the search radius
    nearby_indices = find(distances < search_radius);

    if ~isempty(nearby_indices)
        [~, min_idx] = min(distances(nearby_indices));
        nearest_centre = voxel_coords(nearby_indices(min_idx), :);
    end
end
end