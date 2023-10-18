function [output] = traj_firstframe(trjR)
%TRAJ_FIRSTFRAME Trim particles detected on the first frame of trajectory files.
    [frames, dim, ~] = size(trjR);
    isZero = trjR(1,:,:) == 0;
    idxValid = repmat(isZero, [frames 1 1]);

    output = reshape(trjR(idxValid), frames, dim, []);
end

