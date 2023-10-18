% Plot the evolution of trajectories as a rainbow.
%% Settings
PLOT_TRJR = 1; % Which trjRs to plot
PIXEL_SIZE = 0.16;
C_MAP = turbo(size(trjR, 1)); % Colormap for trjRs

%% Loop through every trajectory, start coloring
figure; hold on
for iTraj = PLOT_TRJR
    x = trjR(:,2,iTraj) .* PIXEL_SIZE; y = trjR(:,1,iTraj) .* PIXEL_SIZE;
    y(end) = NaN;
    patch('XData', x,'YData', y,'FaceVertexCData', C_MAP,'EdgeColor','interp','Marker','none')
end

box on; pbaspect([1 1 1]);
xlabel("x (\mum)"); ylabel("y (\mum)");
colormap(C_MAP); colorbar;