% symmetry.m
% Last modified: 2/15/18 by T. Chuanromanee
% Use fluctuating asymmetry to get measure of symmetry for a leaf
function fluctuatingAsymm = symmetry(outline)
    highestPoint = max(outline);
    highestPoint = highestPoint(2);
    lowestPoint = min(outline);
    lowestPoint = lowestPoint(2);
    midHeightPoint = (highestPoint + lowestPoint) / 2;

    lengths = outline(:,2);

    % Find the closest 2 points corresponding to mid point
    % https://www.mathworks.com/matlabcentral/answers/9593-find-smallest-five-elements-in-a-vector
    [B,idx] = sort(abs(lengths - midHeightPoint));
    lowestIndex = idx(1);
    secondLowestIndex = idx(2);
    midpoint1 = outline(lowestIndex, 1);
    midpoint2 = outline(secondLowestIndex, 1);

    % The higher the FA, the more asymmetric the leaf
    % Perfect FA is 0
    % Abs value of each midpoint should be taken since now leaf is
    % normalized and centered horizontally at 0
    fluctuatingAsymm = 2 * abs(abs(midpoint1) - abs(midpoint2)) / (abs(midpoint1) + abs(midpoint2));
end