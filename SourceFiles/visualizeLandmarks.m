% visualizeLandmarks.m
% Last modified: 5/22/18 by T. Chuanromanee
% Visualize landmarks for leaves in a plot

function visualizeLandmarks(allXLandmarks, allYLandmarks, links, numExtPts)
    % leafLandmarks is the array of landmarks by format of [x1 y1; x2
    % y2;...xn, yn]
    % links is an array of interior to exterior line segments needed to be
    % drawn in addition of the outline, eg [1 10; 2 10; 7 9....]
    % numExtPts is the number of landmarks that form the leaf's exterior
    % outline
    
    % Extract numberical matrix from link (which is a string input)
    links = str2num(links);
    
    % Extract interior points
    interiorXLandmarks = allXLandmarks(1:numExtPts);
    interiorYLandmarks = allYLandmarks(1:numExtPts);
    
    interiorXLandmarks(end+1) = interiorXLandmarks(1);
    interiorYLandmarks(end+1) = interiorYLandmarks(1);
    segmentsX = zeros(length(links),2);
    segmentsY = zeros(length(links),2);
    % Add interior point links
    for i=1:size(links,1)
        % Link the segment
        segmentsX(i,:) = [allXLandmarks(links(i,1)), allXLandmarks(links(i,2))];
        segmentsY(i,:) = [allYLandmarks(links(i,1)), allYLandmarks(links(i,2))];
    end
    
    % Plot the first fig
   figure;
    hold on;
    title('Landmarks');
    xlabel('Width (AU)') % newLeaf-axis label
    ylabel('Length (AU)') % standard-axis label
    plot(interiorXLandmarks, interiorYLandmarks, 'linewidth', 2.5, 'color', 'blue'); % exterior points
    % Plot segments
    for i=1:size(segmentsX,1)
        % Link the segment
        plot(segmentsX(i,:), segmentsY(i,:), 'linewidth', 2.5, 'color', 'blue'); % interior points
    end
    % Add interior plots
    axis equal;
end