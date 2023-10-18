function [fast, slow] = traj_sorter(trjR, limit)
%TRAJ_SORTER Separates fast and slow trajectories from one trjR variable.
%   trjR: Trajectory file.
%   limit: Max distance a particle should travel before being considered long. Set to 0 to disable.
%   ---------
%   This program functions per Korabel et al.'s paper (DOI: 10.3390/e23080958),
%   where we sort trajectories as "fast" and "slow" by
%   their total displacement, R(t) = sqrt( (x(t) - x(0))^2 + (y(t) - y(0))^2).
%   If a trajectory's displacement is ever above the limit, then it's saved
%   as a "fast" trajectory. If not, it's "slow".

%% Get sizes from trjR slice, create templates
[frames, dim, spots] = size(trjR);
Rt = nan(frames, spots);

    %% Find nonzeros of all trajectories, get R(t)
    for iTraj = 1:spots
        nonzs  = reshape(nonzeros(trjR(:,:,iTraj)), [], dim); 
        
        for jTraj = 1:size(nonzs, 1)
            Rt(jTraj, iTraj) = sqrt((nonzs(jTraj,2) - nonzs(1,2)).^2 + ...
                (nonzs(jTraj,1) - nonzs(1,1)).^2);
        end
    end

    %% Compare R(t) to limit, sort from there
    idxFast = any(Rt > limit);

    fast = trjR(:,:,idxFast);
    slow = trjR(:,:,~idxFast);
end