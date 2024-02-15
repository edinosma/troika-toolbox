% Convolute two functions together, and display them on one plot.
% This is used to "merge" the two fits of our van Hove graphs

%% Define functions and grade
func2 = @(x) exp(-abs(x)/0.0362);
func1 = @(x) 0.0017 * exp(-((x+0.0021)/0.6183).^2);

xRange = linspace(-1.33056, 1.33056, 600);

%% Calculate results
result1 = func1(xRange);
result2 = func2(xRange);

%% Plot function addition
plot(xRange, result1 + result2);

%% Functions
function out = nanAt(x, idx)
    x(idx) = NaN;
    out = x;
end