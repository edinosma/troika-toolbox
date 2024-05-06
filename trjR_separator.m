% Separate combined trajectories into separate files. Written by Edin O. 3/28/24

% Load your trajectory file first!
%% Declare vars
NUM_SPLITS = 3; % What to split trajectories by
SAVE_DIR = "D:\Clouds\OneDrives\Georgia State University\OMICS lab_NSC 249 - Documents\Data\Diyali\03262024\Laser Power\COMBINED\SPLIT\";

%% Main program
[filename, filepath] = uigetfile('*.mat','SPT files?','MultiSelect','off');
load([filepath filename])

split_idx = floor(size(trjR,3) / NUM_SPLITS);

trjR_source = trjR;

for i = 1:NUM_SPLITS
    % Handle special cases
    trjR = [];

    if i == 1
        trjR = trjR_source(:, :, 1:split_idx);
    end

    if i == NUM_SPLITS
        trjR = trjR_source(:, :, (split_idx * (i-1)):end);
    end

    if isempty(trjR)
        trjR = trjR_source(:, :, (split_idx * i):(split_idx * (i+1)));
    end

    save(SAVE_DIR + string([filename(1:end-4)]) + "_" + string(i) + ".mat", "trjR", '-mat', "-v7.3")
end