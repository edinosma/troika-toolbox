% Fits MSD and log(MSD) to mx+b. Written by Edin Osmanbasic.
TIME_LAG = 0.03;

% msd = compMSD(trjR, TIME_LAG, false); % If you have an MSD variable generated, just comment this line out

coeff = cell(size(msd));

parfor iMSD = 1:size(msd, 1)
    fitD   = fit(msd{iMSD}(:,1), msd{iMSD}(:,3), 'poly1'); % MSD = Dx + ...

    msdLogd = log10(msd{iMSD});
    msdLogd = reshape(msdLogd(~isinf(msdLogd)), [], 3);
    fitAlp = fit(, 'poly1'); % log(MSD) = alpha*x + ...

    coeffD   = coeffvalues(fitD);
    coeffAlp = coeffvalues(fitAlp);
    coeff{iMSD} = [coeffD(1), coeffAlp(1)];
end