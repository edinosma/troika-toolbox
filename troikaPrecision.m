% Precision of still particles in a Troika trjR file. Written by Edin Osmanbasic on 7.23.23.
%%  Settings
PX_SIZE = 0.160;
UNITS = "um";
AXIS = {"Y", "X"};

%% Calculate
trimmed = trjR(:,1:2,:) .* PX_SIZE;
idxZeros = trimmed == 0;
trimmed(idxZeros) = NaN;

sigma = std(trimmed, 0, "omitmissing");

sigma = reshape(sigma, [], 2);
med = median(sigma); mu = mean(sigma);

%% Plotting
for iFigs = 1:size(sigma, 2)
    figure;
    hist = histogram(sigma(:, iFigs), 'Normalization', 'probability');
    ylabel("Probability of " + string(AXIS{iFigs})); xlabel("Standard Deviations (" + UNITS + ")");
    strMean = "Mean: " + string(mu(iFigs)) + UNITS; strMed = "Median: " + string(med(iFigs)) + UNITS;
    dim = [.2 .5 .3 .3];
    annotation('textbox',dim,'String',{strMean(1,1), strMed(1,1)},'FitBoxToText','on');
end