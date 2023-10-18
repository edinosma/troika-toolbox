% Precision of still particles in a Troika trjR file. Written by Edin Osmanbasic on 7.23.23.
%%  Settings
PX_SIZE = 0.160;
UNITS = "um";

%% Calculate
trimmed = trjR(:,1:2,:) .* PX_SIZE;
idxZeros = trimmed == 0;
trimmed(idxZeros) = NaN;

sigma = std(trimmed, 0, "omitmissing");

sigReshaped = reshape(sigma, [], 2);
med = median(sigReshaped); mu = mean(sigReshaped);

%% Plotting
hist = histogram(sigReshaped(:,1), 'Normalization', 'probability'); % x axis
ylabel("Probability"); xlabel("STDs (" + UNITS + ")");
strMean = "Mean: " + string(mu) + UNITS; strMed = "Median: " + string(med) + UNITS;
dim = [.2 .5 .3 .3];
annotation('textbox',dim,'String',{strMean(1,1), strMed(1,1)},'FitBoxToText','on');