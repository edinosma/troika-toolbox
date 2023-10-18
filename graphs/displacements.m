% Plot the displacement vs. time lag.
%% Get info from trjR
[frames, dim, spots] = size(trjR);
Rt = nan(frames, spots);
LIMIT = 0.48; % in um
TIME_LAG = 0.03; % in seconds; for display only

%% Calculate R(t)
for iTraj = 1:spots
    nonzs  = reshape(nonzeros(trjR(:,:,iTraj)), [], dim); 
    
    for jTraj = 1:size(nonzs, 1)
        Rt(jTraj, iTraj) = sqrt((nonzs(jTraj,2) - nonzs(1,2)).^2 + ...
            (nonzs(jTraj,1) - nonzs(1,1)).^2);
    end
end

idxFast = any(Rt > LIMIT);

%% Plot R(t)
% Fast trajectories are black. Slow trajectories are red.
x = 1:1:frames; x = x .* TIME_LAG;

dispFig = figure; hold on;
plot(x, Rt(:, idxFast), "Color","black");
plot(x, Rt(:, ~idxFast), "Color","red");