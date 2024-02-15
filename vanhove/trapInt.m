% Plot trapezoids under a van Hove graph.

widths = cumtrapz(x(1,:), y(1,:));
heights = y(1,:);

vert = cell([1 98]);
for i = 1
    vert{i} = ...
           [x(1,i),   heights(i);  ... % (0, 0)
            x(1,i+1), heights(i);  ... % (1, 0)
            x(1,i+1), heights(i+1);... % (1, 1)
            x(1,i),   heights(i+1);... % (0, 1)
        ];
end

face = 1:1:length(widths)*4;
face = reshape(face, 4, []);

vert = cell2mat(vert);
face = reshape(face, 4, []);

% hold on
% plot(x(1,:), y(1,:));
% patch('Faces', face', 'Vertices', vert', 'FaceColor','red')