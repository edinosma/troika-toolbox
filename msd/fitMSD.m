% Fits MSD and log(MSD) to mx+b. Written by Edin Osmanbasic.
%% Settings
TIME_LAG   =  0.03;
R2_VALUE   =  0.80; % Consider coefficients from fits with an R2 of this and greater
ALPHA_CAP  =  0.50; % Fit mx+b to this percent of log(MSD) data
REGEN_MSD  = true; % Regenerate MSD?

%% Get MSD, allocate memory
if REGEN_MSD
    msd = compMSD(trjR, TIME_LAG, false);
end
coeff = cell(size(msd));
[coeff{:}] = deal(nan(1,4));

parfor iMSD = 1:size(msd, 1)
    %% Clean up data
    % Linear
    cleanData = msd{iMSD}(~isnan(msd{iMSD}));
    cleanData = reshape(cleanData, [], 3);

    % Log (with ALPHA_CAP)
    logTo = floor(size(cleanData, 1) * ALPHA_CAP);
    logX  = log(cleanData(1:logTo,3));
    logY  = log(cleanData(1:logTo,1));

    infinites = isinf(logX) | isinf(logY);
    logX(infinites) = []; logY(infinites) = [];

    %% Fits
    if numel(cleanData(:,1)) >= 2
        [fitD, gofD] = fit(cleanData(:,1), cleanData(:,3), 'poly1'); % MSD = Dx + ...
    else; continue
    end

    if numel(logX) >= 2
        [fitAlp, gofAlp] = fit(logX, logY, 'poly1'); % log(MSD) = alpha*x + ...
    else; continue
    end

    %% Save to variable
    coeffD   = coeffvalues(fitD);
    coeffAlp = coeffvalues(fitAlp);
    coeff{iMSD} = [coeffD(1), gofD.adjrsquare, coeffAlp(1), gofAlp.adjrsquare];
end

%% Get D, alpha, with consideration of R2_VALUE
coeff = cell2mat(coeff);
goodD = coeff(:,2) >= R2_VALUE; goodAlp = coeff(:,4) >= R2_VALUE;

meanD = mean(coeff(goodD,1)); stdD = std(coeff(goodD,1));
