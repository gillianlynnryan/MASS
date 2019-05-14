% normalize_outline.m
% Last modified: 2/15/18 by T. Chuanromanee
% Normalize image, given the leaf outline from Leaf_Analysis_V6.m

%% Normalize outline
function [normOutline, shrinkRatio] = normalize_outline(leafOutline)
    normOutline = leafOutline - min(leafOutline(:));
    normOutline = normOutline ./ max(normOutline(:));

    % Normalize y axis
    normOutline(:,2) = normOutline(:,2) - min(normOutline(:,2));
    shrinkRatio = max(normOutline(:,2));
    % In this next line it is crucial to divide ALL by
    % max(normOutline(:,1)) to keep the aspect ratio intact
    normOutline(:) = normOutline(:) ./ shrinkRatio;
        
    % Adjust horizontal axis so that it is centered on 0
    minPoint = median(normOutline(:,1));
    for i=1:length(normOutline(:, 1))
        normOutline(i, 1) = normOutline(i, 1) - minPoint;
    end
end