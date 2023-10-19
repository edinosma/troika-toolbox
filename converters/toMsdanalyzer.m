function [ma_tracks] = toMsdanalyzer(trjR, pxSize, timeLag)
%TOMSDANALYZER Convert Troika tracks to msdanalyzer tracks.
%   DOI for msdanalyzer: 10.1083/jcb.201307172
%   Link to msdanalyzer: https://github.com/tinevez/msdanalyzer
%   For this to work, I need to get rid of the padding Troika adds.
%   I would recommend putting your trajectory through traj_filt first!
    spots = size(trjR, 3);
    ma_tracks = cell(spots, 1);
    trjR(:,1:2,:) = trjR(:,1:2,:) .* pxSize;
    
    for iTraj = 1:spots
        idxNonZ = trjR(:,1,iTraj) ~= 0;
        % Recall that Troika stores positions as [y x w]. We want [t x y].
        ma_tracks{iTraj} = [(find(trjR(:,1,iTraj)) .* timeLag) ...
            trjR(idxNonZ, 2, iTraj) ...
            trjR(idxNonZ, 1, iTraj)];
    end
end