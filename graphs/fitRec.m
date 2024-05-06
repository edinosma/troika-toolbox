% Load and fit the reconstructed van Hove graph from Track Analysis.

%% Get data from PD file
fitX = van_Hove_rec(:,1) ./ 1e-6; % Convert from m to um
pDX = van_Hove_rec(:,2);
normalization = 2 * pi .* fitX; % Normalize p(delta X) by multiplying with 2 pi r
fitY = real(log10(pDX .* normalization)); % Change to log scale, for fitting

%% Shift data up so fitting Gaussians works
plot(fitX, fitY, '.');