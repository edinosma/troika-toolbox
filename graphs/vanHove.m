% Generate van Hove graphs from trajectories. Written by Edin O. on 9.8.23
%% Declare Vars
TIME_LAG = [16, 33, 66, 134, 267]; % In frames.
% TIME_LAG = 1;
PX_SIZE = 0.160;
GRAPH_SPACING = 3;

%% Calculate and rescale
vhFig = figure;
for iLag = 1:length(TIME_LAG)
    [y, x] = vanHoveAtTau(trjR, TIME_LAG(iLag));
    y = rescale(y, 0, 1); x = x(1:end-1) + diff(x) ./ 2;
    y = y .* 10^(GRAPH_SPACING * iLag); % For offsetting values on the graph
    
    %% Plot graph
    hold on
    plot((x .* PX_SIZE), y, "o", ...
        "DisplayName", "\Deltat = " + num2str(TIME_LAG(iLag) * 0.03), Marker=".", MarkerSize=20);
end

%% Pretty Up Graph
set(gca, 'YScale', 'log');
legend("Location","northwest");
xlabel("\Deltax (\mum)"); ylabel("G(\Deltax, \Deltat)");
% title('Remember to change ylabel \Deltat to value!');
box on

%% Van Hove Function
function [bins, edges] = vanHoveAtTau(trjR, lagtime)
    [frames, dim, spots] = size(trjR);
    dim = dim - 1;
    outdata = NaN(frames, spots);

    for iTraj = 1:spots % For every trajectory, get all nonzero values
        nonzs = reshape(nonzeros(trjR(:,1:dim,iTraj)), [], dim);

        for jTraj = 1:size(nonzs, 1) % Calculate the displacement between timelags
            if (jTraj + lagtime) <= size(nonzs, 1)
                outdata(jTraj, iTraj) = nonzs(jTraj + lagtime, 2) - nonzs(jTraj, 2);
            else % If timelag is out of range, stop processing
                break
            end

        end

    end
    
    % Put it in a histogram
    [bins, edges] = histcounts(outdata, 100, "Normalization", "pdf");
end