function [tr_tracks] = toTrack_analysis(trjR)
%TOTRACKANALYSIS Convert Troika tracks to track_analysis tracks.
%   Link to track_analysis: https://github.com/andrewx101/track_analysis
%   For track_analysis, pixel size and time lag are specified in its main window.
    [~, dim, spots] = size(trjR);

    idxNonZ = trjR(:,1,:) ~= 0;
    numFrames = sum(idxNonZ);
    tr_tracks = nan(nnz(idxNonZ), dim + 1);

    % Create index of tr
    idxTo   = reshape(cumsum(numFrames), [], 1)';
    idxFrom = [0 idxTo] + 1; idxFrom(end) = [];

    for iTraj = 1:spots
        idx = idxNonZ(:,:,iTraj);
        trFrames = find(idx);
        tr_tracks(idxFrom(iTraj):idxTo(iTraj), :) =... 
            [trjR(idx, 1:end-1, iTraj), trFrames, repmat(iTraj, numFrames(iTraj), 1)];
    end
end

