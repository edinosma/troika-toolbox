function [msd] = compMSD(trjR, timelag, asArray)
%COMPMSD Compute the MSD of a trjR. Saved as [mean, std, dt]
%   Ensemble-MSD(t) = <r>^2 (t) = <|(y(j)-y(0))|^2 + |(x(j) - x(0))|^2> 

%% Allocation of memory
[frames, dim, spots] = size(trjR);
dim = dim - 1;

temp = cell(spots, 1); % Due to how parfor works, we need to make MSD into a cell then flatten it at the end.
[temp{:}] = deal([0,0,0; nan(frames-1, dim+1)]); % Initial MSD is 0 because r(0) - r(0) = 0.

%% ParFor Loop
parfor iTraj = 1:spots
    nonzs = reshape(nonzeros(trjR(:,1:dim,iTraj)), [], dim);
    numNZ = size(nonzs,1) - 1;
    atTime = (find(trjR(:,1,iTraj)) .* timelag);

    for jTraj = 1:numNZ
        dR2 = sum( (nonzs(1+jTraj:end, :) - nonzs(1:end-jTraj, :)).^ 2, 2); % dy, dx

        msdCalc = [mean(dR2), std(dR2), atTime(jTraj)]; % mean, std, dt
        
        temp{iTraj}(jTraj+1, :) = msdCalc;
    end

end

%% Reshape Cell to Array
if asArray
    msd = reshape(cell2mat(temp), frames, [], spots);
else
    msd = temp;
end

end