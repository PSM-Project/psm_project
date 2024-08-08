% This script builts on the svmmultisub.m script and the second_level_GLMandt-test.m script and computes the
% accuracy above chance values for clusters that were found significant in
% the secong level analysis using SPM12. It assumes that one uses an anatomy
% toolbox (here the Julich Anatomy Toolbok) to identify the coordinates of
% the significant clusters of interest, which are then used in the
% SPM GUI to extract the raw y-values of said cluster. These raw y-values
% (which store the accuracy relative to chance)
% are then used as an input into the mean function to compute the desired
% accuracy above chance for each participant and cluster as well as a group
% level mean for each cluster. It also computes the standard deviation over
% the 10 participants.


%% get the accuracy above chance for the first two significant clusters with the highest voxel size 

%% CLUSTER 1 - 
% calculate the mean accuarcy above chance for each participant
mean_accuracy1 = mean(y_clus1,2);

% calculate the overall mean (over all 10 participants)
mean_accuracy_overall1 = mean(mean_accuracy1);

% calulate the standard deviation
std_accuracy1 = std(mean(y_clus1,1));ad

%% CLUSTER 2 
% calculate the mean accuarcy above chance for each participant
mean_accuracy2 = mean(y_clus2,2);

% calculate the overall mean (over all 10 participants)
mean_accuracy_overall2 = mean(mean_accuracy2);

% calulate the standard deviation
std_accuracy2 = std(mean(y_clus2,1));

%% CLUSTER 4
% calculate the mean accuarcy above chance for each participant
mean_accuracy3 = mean(y_clus4,2);

% calculate the overall mean (over all 10 participants)
mean_accuracy_overall3 = mean(mean_accuracy3);

% calulate the standard deviation
std_accuracy3 = std(mean(y_clus4,1));
