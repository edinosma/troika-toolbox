% Find which frames particles start and end at. Written by Edin Osmanbasic on 8.1.23.
%% Go Through Trajectories
[frames, dim, spots] = size(trjR);
frameCmb = nan([spots 3]);

for iTraj = 1:spots
    %% Find Last and First Frames of Trajectories
    [frameFirst, ~] = find(trjR(:,:,iTraj), 1, "first");
    [frameLast,  ~] = find(trjR(:,:,iTraj), 1, "last");

    %% Handle emptys
    if isempty(frameFirst)
        frameFirst = 0; frameLast = 0;
    end

    frameCmb(iTraj,:) = [frameFirst, frameLast, (frameLast - frameFirst)];
end