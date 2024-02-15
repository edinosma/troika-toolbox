% Generate and fit van Hove graphs from trajectories. Written by Edin O. on 9.8.23
%% Declare Vars
% Frame(s) to view
% TIME_LAG = [1, 16]; % In frames.
TIME_LAG = [1, 2, 4, 8, 16];
% TIME_LAG = 1;

% Settings
TIME_SCALE = 0.03;
PX_SIZE = 0.160;
GRAPH_SPACING = 0; % 0 to disable.

% Booleans
FIT_GRAPH = false; % Fit graphs to 2 gaussians; find the diffusion.
CALC_ALPHA2 = false; % Calculate the non-Gaussianity param, or alpha 2.
PLOT_VH = true; % Plot the van Hove correlation function

%% Make van Hoves for ALL time lags
% vhFig = figure;

if isempty(TIME_LAG); TIME_LAG = 1:size(trjR, 1); end
assert(max(TIME_LAG) <= size(trjR, 1), "Timelags must be smaller than the number of frames!")

% Per fitVH, we export x and y as [frames 101].
% Parfor only likes to work with cells. These guys will be flattened after
% processing.

y = cell(length(TIME_LAG), 1);
a2 = y; displace = y;
[y{:}] = deal(nan(1, 100));
x = y;

disp("Generating van Hoves for specified time-lags. This will take a second.")
for i = 1:length(TIME_LAG)
    [tempY, tempX, tempDR] = calcVH(trjR .* PX_SIZE, TIME_LAG(i));
    y{i, 1} = tempY;
    x{i, 1} = tempX(1:end-1) + diff(tempX)/2; % Get bin centers
    displace{i, 1} = tempDR; % Displacement at time lag
end

% Flatten van Hove data
y = cell2mat(y); % [TIME_LAG 100]
x = cell2mat(x);

for i = 1:length(TIME_LAG)
    yFit = log10(y(i, :));

    yGraph = y(i, :) .* 10^(GRAPH_SPACING * (i - 1)); % For offsetting values on the graph
    xGraph = x(i, :);

    frameToSec = TIME_LAG(i) * TIME_SCALE;

    %% Calculate alpha2
    if CALC_ALPHA2
        if i == 1; disp("Calculating alpha_2 values for all van Hove graphs."); end
        tempA2 = calcAlpha2(displace{i});
        a2{i} = [TIME_LAG(i), tempA2];
    end

    %% Fit graph
    %   Fit 2 gauss/1 gauss 1 exponential to every van Hove graph
    if FIT_GRAPH
        fitObj(i) = fitVH(xGraph, yGraph, 0.2, 0.05);
    end

    %% Plot graph
    if PLOT_VH
    hold on
    plot(xGraph, yGraph, "o", ...
        "DisplayName", "\Deltat = " + num2str(frameToSec), Marker=".", MarkerSize=6);
    end
end

%% Pretty Up Graph
if PLOT_VH
    set(gca, 'YScale', 'log');
    % legend("Location","northwest");
    xlabel("\Deltax (\mum)"); ylabel("G(\Deltax, \Deltat)");
    pbaspect([1 1 1]);
    box on
end

%% Plot alpha 2s
if CALC_ALPHA2
    a2 = cell2mat(a2);
    % a2Fig = figure;
    hold on
    plot(a2(:,1), a2(:,2));
    xlabel("\tau (s)"); ylabel("|\alpha_2| (-)");
    pbaspect([1 1 1]); box on
end

%% Functions
function [bins, edges, dR] = calcVH(trjR, lagtime)
    %CALCVH Make a van Hove graph at a specific lagtime.
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

    dR = outdata;

    % Remove NaNs. Necessary, as NaNs actually affect the height of hists.
    outdata = outdata(:);
    outdata = outdata(~isnan(outdata));

    % Put it in a histogram
    [bins, edges] = histcounts(outdata, 100, "Normalization", "probability");
end

function alpha2 = calcAlpha2(displacement)
    %CALCALPHA2 Calculate the non-Gaussianity parameter from displacement.
    % a2 = 3 * (mean(r(tau)^4) / 5*mean(r(tau)^2)^2) - 1
    % Output is [mean stdev]

    a2  = nan([1 length(displacement)]); % Allocate mem

    for i = 1:length(displacement)
        dR = displacement(:, i);
        dR = dR(~isnan(dR)); % Get rid of NaNs
        
        a2(i) = ((3 * mean(dR .^ 4)) / (5 * mean(dR .^ 2) .^ 2)) - 1;
    end

    % Clean up values (in case there are NaNs, a2 should be |a2|)
    a2 = abs(a2(~isnan(a2)));
    a2 = a2(a2 < 50);
    alpha2 = [mean(a2), std(a2)];
end

function fitObj = fitVH(x, y, center, slope)
    %FITVH Fit two Gaussians or an exponential to a van Hove graph.

    % Depending on the slope of the van Hove at its center,
    % we fit either 2 Gaussians or 1 Gauss and 1 exponential.
    % Navigate to this function to read more.

    % Get slope of data.
    dx = mean(diff(x));
    dy = gradient(y,dx);

    % If the "center" ([-0.2, 0.2]) is a rounded shape (|slope| > 0.05),
    poi = find((x >= center) & (x <= center));

    if max(abs(dy(poi))) > abs(slope)
        % Fit two gaussians.

    else
        % Else, it can be fit with an exponential center and a Gaussian tail.

    end
    
    % Export fit obj. We can extract the data we want from the main program.
end