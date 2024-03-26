% Generate and fit van Hove graphs from trajectories. Written by Edin O. on 9.8.23
%% Declare Vars
% Frame(s) to view
TIME_LAG = 1; % In frames.
% TIME_LAG = [1, 2, 4, 8, 16];

% Settings
TIME_SCALE = 0.03;
PX_SIZE = 0.160;
GRAPH_SPACING = 0; % 0 to disable.

% Booleans
FIT_GRAPH = false; % Fit graphs to 2 gaussians; find the diffusion.
CALC_ALPHA2 = false; % Calculate the non-Gaussianity param, or alpha 2.
PLOT_VH = false; % Plot the van Hove correlation function

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
    x{i, 1} = tempX;
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
    %   Fit 2 gauss to every van Hove graph
    if FIT_GRAPH
        if i == 1; disp("Fitting all van Hove graphs."); end
        fitObj(i,:) = fitVH(xGraph, y(i, :), 0:0.01:0.1, 0.2:0.01:0.5, 0:0.01:1);
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
    plot(a2(:,1) .* TIME_SCALE, a2(:,2));
    xlabel("\tau (s)"); ylabel("|\alpha_2| (-)");
    pbaspect([1 1 1]); box on
end

%% Calculate diffusions from Gaussians
if FIT_GRAPH
    calcDiff = @(x, t) (x^2)/(4 * t);
    for i = 1:length(TIME_LAG)
    end
end

%% Functions
function [bins, centers, dR] = calcVH(trjR, lagtime)
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

    % Put it in a histogram, get bin centers
    [bins, edges] = histcounts(outdata, 100, 'Normalization', 'probability');
    centers = edges(1:end-1) + diff(edges)/2;
end

function alpha2 = calcAlpha2(displacement)
    %CALCALPHA2 Calculate the non-Gaussianity parameter from displacement.
    % a2 = 3 * (mean(r(tau)^4) / 5*mean(r(tau)^2)^2) - 1
    % Output is [mean stdev]

    a2  = nan([1 length(displacement)]); % Allocate mem

    for i = 1:length(displacement)
        dR = displacement(:, i);
        dR = dR(~isnan(dR)); % Get rid of NaNs
        
        a2(i) = (mean(dR .^ 4) / (3 * mean(dR .^ 2) .^ 2)) - 1;
    end

    % Clean up values (in case there are NaNs, a2 should be |a2|)
    a2 = abs(a2(~isnan(a2)));
    a2 = a2(a2 < 50);
    alpha2 = [mean(a2), std(a2)];
end

function outFit = fitVH(x, y, varyS1, varyS2, varyK)
    %FITVH Fit two Gaussians to a van Hove graph.
    % This is done per DOI: 10.1039/c0sm00925c, where we constantly try
    % fitting two Gaussians of varying width (sigma) and height (k), and
    % adjust parameters over and over until we get a good fit.
    % This section could take a while depending on how many graphs we're
    % fitting.
    % Exports sigma1, sigma2, k, and R2 of the best-fitting Gaussians graph.

    % Define anonymous funcs
    fitGauss = @(x, s1, s2, k) (k)*exp(-((x)./s1).^2) + (1-k)*exp(-((x)./s2).^2);

    xbar = mean(y);
    rSquared = @(x, xfit) 1 - (sum((x - xfit).^2) / sum((x - xbar).^2));
    % x = raw data (y), xbar = mean, xfit = fit data

    % Get to work!
    try % For some reason, MATLAB doesn't have a way to escape a nested for loop.
        % Let's do a try-catch statement instead, stopping with our own error.

        for k = varyK
            for s1 = varyS1
                for s2 = varyS2
                    % Calculate r2 for this graph
                    % If greater than 0.90, then we'll plot that
                    doubleGauss = fitGauss(x, s1, s2, k);
                    idx = [find(varyS2 == s2), find(varyS1 == s1), find(varyK == k)];

                    r2val(idx(1), idx(2), idx(3)) = rSquared(y, doubleGauss);
                    
                    assert(~(r2val(idx(1), idx(2), idx(3)) > 0.85), 'break')
                end
            end
        end

        outFit = [NaN, NaN, NaN, NaN];
        disp("Could not fit graph! Max r2val: " + max(r2val, [], "all"))
    catch err
        if strcmp(err.message, 'break')
            disp("Greater than 90 R2: " + s1 + " " + s2 + " " + k + " " + r2val(idx(1), idx(2), idx(3)))
            figure; hold on
            plot(x, y, 'o');
            plot(x, doubleGauss, '-');

            outFit = [s1, s2, k, max(r2val, [], "all")];
        else, rethrow(err)
        end
    end
end