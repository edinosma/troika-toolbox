function [msd] = compMSD(trjR, timelag)
%COMPMSD Compute the MSD of a trjR.
%   Ensemble-MSD(t) = <r>^2 (t) = <|(y(j)-y(0))|^2 + |(x(j) - x(0))|^2> 

%% Allocation of memory
[frames, dim, spots] = size(trjR);
dim = dim - 1;
msd = nan(frames-1, dim+1, spots);

for iTraj = 1:spots
    %% Get dR, find dT, save to msd(timeframe, [mean(dR.^2, 1), dT], particle number)
    nonzs = reshape(nonzeros(trjR(:,1:dim,iTraj)), [], dim);
    numNZ = size(nonzs,1);
    atTime = diff(find(trjR(:,1,iTraj)) .* timelag); atTime = [0; atTime];

    for jTraj = 1:numNZ
        dR = [abs(nonzs(jTraj:end,1) - nonzs(1,1)), ...
              abs(nonzs(jTraj:end,2) - nonzs(1,2))]; % dy, dx

        msd(jTraj, :, iTraj) = [mean(dR.^2, 1), atTime(jTraj)]; % dy, dx, dt
    end
end

end