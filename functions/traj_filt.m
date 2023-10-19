function [filtered] = traj_filt(trjR, desiredFrames)
%TRAJ_FILT Get trajectories lasting desiredFrames frames or greater.
% Also interpolate between "blinks" of tracking. If you just want to use
% the interpolation, set desiredFrames to 0.
spots = size(trjR, 3);
numNonZ = zeros(spots, 1);

for iTraj = 1:spots
    % If a track disappears for a frame but comes back ("blinking"),
    % interpolate from prev frame to next.
    numFrames = find(trjR(:,1,iTraj));
      idxDiff = diff( numFrames ) > 1;

    if any(idxDiff)
        idxZero = find(trjR(numFrames(1):numFrames(end), 1, iTraj) == 0);
        idxZero = (idxZero + numFrames(1)) - 1; % Realign to frames
        trjR(idxZero,:,iTraj) = (trjR(idxZero-1,:,iTraj) + trjR(idxZero+1,:,iTraj)) ./ 2; % Get average from before and after
    end
    
    numNonZ(iTraj) = nnz(trjR(:,1,iTraj));
end

idxFiltered = numNonZ > desiredFrames;

filtered = trjR(:,:,idxFiltered);