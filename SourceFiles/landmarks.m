% landmarks.m
% Last modified: 5/17/18 by T. Chuanromanee
% Prep image for landmarks, place landmarks on the image, and normalizes
% the image to prepare for PCA

function landmarks(img_gray_smooth, theta_longaxis, widerThanLong, numLandmarks, exportFileName, numExtPts, landmarkLinks)
    % Show the leaf segment only in order to put landmarks on
    rotatedLeafBw = imrotate(RemoveWhiteSpace(img_gray_smooth),theta_longaxis + 180);
    rotatedleafFig = figure;
    imshow(rotatedLeafBw);

    %% Get points in landmark! Double click when done. Press backspace to remove last added landmark
    [xLandmarks, yLandmarks] = getpts(rotatedleafFig);  
    if numLandmarks == 0
        numLandmarks = length(xLandmarks);
    elseif length(xLandmarks) ~= numLandmarks
        msgbox('Warning: Number of landmarks selected differs from configuration! Program will continue by truncating excess landmarks selected.','Warning');
        return;
    end

     
    % Get highest and lowest point (ie. highest and lowest y)
    yNormalized = yLandmarks - min(yLandmarks);
    yRefPt = max(yNormalized);
    yNormalized = yNormalized ./ yRefPt;

    % Find the center point (width coordinate that is the middle)
    centerHighest = xLandmarks(find(1 == yNormalized));
    centerLowest = xLandmarks(find(0 == yNormalized));
    symmetricReferencePoint = (centerHighest + centerLowest) / 2;

    xNormalized = zeros(size(xLandmarks)); % Initialize xNormalized array
    
    % Append first element to end of each array to ensure that the shape is
    % closed
    xLandmarks(end+1) = xLandmarks(1);
    yNormalized(end+1) = yNormalized(1);
   
    % Adjust horizontal axis so that midpoint is at 0
    for i=1:length(xLandmarks)
        xNormalized(i) = xLandmarks(i) - symmetricReferencePoint;
    end
    xNormalized = xNormalized / yRefPt; % Normalize x coordinates
    
    % Compensate for graph flipped vertically (See issue #25)
    yNormalized = abs(yNormalized - max(yNormalized));
    
%     figure;
%     hold on;
%     title('Landmarks');
%     xlabel('Width') % x-axis label
%     ylabel('Length') % y-axis label
%     plot(xNormalized, yNormalized, 'linewidth', 2.5);
%     axis equal;

    %landmarkLinks = [1 3; 1 7; 1 12; 1 17; 1 21];
    %numExtPts = 22;
	visualizeLandmarks(xNormalized, yNormalized, landmarkLinks, numExtPts);
    exportLandmarks(xNormalized, yNormalized, exportFileName);
end

%% export x, y coordinates such that x1 y1 x2 y2 and so forth
function exportLandmarks(xNormalized, yNormalized, exportFileName)
    outputFileName = sprintf('landmarks_%s.csv', exportFileName); 

    %% Check if file exists
    if exist(outputFileName, 'file') == 2
       exportOption = 2; % Append
    else
        exportOption = 1; % Create
    end

    %% Process export
    if exportOption == 2
        fileID = fopen(outputFileName,'a');
    elseif exportOption == 1
        fileID = fopen(outputFileName,'w');
        % Write headers
        for i = 1:length(xNormalized)
            fprintf(fileID, 'x%d,', i);
            fprintf(fileID, 'y%d,', i);
        end
        fprintf(fileID, '\n'); % Add new line
    else
        disp('Invalid selection. Exiting...');
        return;
    end
    
    % check lengths for equality
    if length(xNormalized) ~= length(yNormalized)
        disp('Error! Each x coordinate should have a corresponding y coordinate. Please check your data.');
        return;
    end
    
    % Print coordinates
    for i = 1:length(xNormalized)
        fprintf(fileID, '%f,', xNormalized(i));
        fprintf(fileID, '%f,', yNormalized(i));
    end
    fprintf(fileID, '%s');
    fprintf(fileID, '\n');
    fclose(fileID);

end