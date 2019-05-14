% procrustes_analysis.m
% Last modified: 9/4/18 by T. Chuanromanee
% Perform gpa on a set of points

function procrustes_analysis(numExtPts, links)
    %% Get file and PC information
    exportFileName = datestr(now, 'yyyy_mm_dd_HHMMSS');
    [inputFile, inputDirectory] = uigetfile('*.csv','Procrustes Analysis: Select an input CSV file','MultiSelect','on');
    if isequal(inputFile, 0)
    	msgbox('No input file selected. Please try again!','Error');
        return;
    end
    if isequal(class(inputFile), 'cell') % Index cell array if multiple files selected
        for i=1:length(inputFile)
            inputPath = fullfile(inputDirectory, inputFile{i});
           tempLandmarkArray = csvread(inputPath,1,0); % Start reading at 1 row from the first row at 1st col 
           % Concatenate numerical data
            if i == 1
               landmarkArray = tempLandmarkArray;
            else
               landmarkArray = vertcat(landmarkArray, tempLandmarkArray);
            end
        end
    else % Only one file is selected
        inputPath = fullfile(inputDirectory, inputFile);
        landmarkArray = csvread(inputPath,1,0); % Start reading at 1 row from the first row at 1st col 
    end
    
    % Compute the mean landmarks
    meanLandmarks = mean(landmarkArray,1);
    % reshape array to 2d with x and y
    meanLandmarks = splitXYcoords(meanLandmarks);
     % Preprocess landmark data here
    standard = meanLandmarks; % Standard to compare other leaves with
    
    % Set up files
    procrustesDistShiftedFile = sprintf('procrustes_distance_shifted_data_%s.csv', exportFileName);
    procrustesDeltasFile = sprintf('procrustes_delta_x_y_%s.csv', exportFileName);
    
    % Write headers to distance shifted file
    procrustesDistShiftFileID = fopen(procrustesDistShiftedFile,'wt');
    fprintf(procrustesDistShiftFileID, '%s,', 'Dissimilarity');
    fprintf(procrustesDistShiftFileID, '%s,', 'Size similarity');
    for i = 1:length(meanLandmarks(:,1))-1
        fprintf(procrustesDistShiftFileID, 'landmark_shift_%d,', i);
    end
    fprintf(procrustesDistShiftFileID, '\n'); % Add new line
    
    % Write headers to Procrustes delta x and delta y file
    procrustesDeltasFileID = fopen(procrustesDeltasFile,'wt');
    fprintf(procrustesDeltasFileID, '%s,', 'Dissimilarity');
    fprintf(procrustesDeltasFileID, '%s,', 'Size similarity');
    for i = 1:length(meanLandmarks(:,1))-1
        fprintf(procrustesDeltasFileID, 'delta_x%d,', i);
        fprintf(procrustesDeltasFileID, 'delta_y%d,', i);
    end
    fprintf(procrustesDeltasFileID, '\n');
        
	% Set up plot
    figure;
    hold on;
    landmarkTitle = sprintf('Procrustes Analysis');
    title(landmarkTitle);
    xlabel('Width (AU)') % newLeaf-axis label
    ylabel('Length (AU)') % standard-axis label
    
    % iterate through each leaf in landmarkArray
    for i=1:size(landmarkArray,1)
        newLeaf = landmarkArray(i,:);
        newLeaf = splitXYcoords(newLeaf);
        % reshape array to 2d with x and y
        % Z is transformed shape
        [dissimiliarity,fittedShape,tr] = procrustes(newLeaf,standard);
        %plot(newLeaf(:,1), newLeaf(:,2),'bx', Z(:,1),Z(:,2),'b:');
        comparisonPlot = plot(fittedShape(:,1),fittedShape(:,2),'b:','DisplayName','Comparison');
        deltaX = standard(:,1) - fittedShape(:,1);
        deltaY = standard(:,2) - fittedShape(:,2);
        % Write dissimiliarity and size similiarity and delta x/delta y shifted to file
        fprintf(procrustesDeltasFileID, '%f,', dissimiliarity); % write dissimilairity
        fprintf(procrustesDeltasFileID, '%f,', tr.b); % write size similiarity
        for j = 1:length(meanLandmarks(:,1))-1
            fprintf(procrustesDeltasFileID, '%f,', deltaX(j)); % print delta x coordinate
            fprintf(procrustesDeltasFileID, '%f,', deltaY(j)); % print delta y coordinate
        end
        
        fprintf(procrustesDeltasFileID, '\n');
        % Get distance shifted
        distanceShifted = sqrt((fittedShape(:,1) - standard(:,1)).^2 + (fittedShape(:,2) - standard(:,2)).^2);
        % Write dissimiliarity and size similiarity and distance shifted to file
        fprintf(procrustesDistShiftFileID, '%f,', dissimiliarity); % write dissimilairity
        fprintf(procrustesDistShiftFileID, '%f,', tr.b); % write size similiarity
         for j = 1:length(meanLandmarks(:,1))-1
            fprintf(procrustesDistShiftFileID, '%f,', distanceShifted(j)); % print x coordinate
        end
        fprintf(procrustesDistShiftFileID, '\n');
        %d = dissimilarity measure, a measure from 0 to 1, with 1 least similar and 0 most similar
        %tr.b = size similarity (scaling factor), 100 minus the factor which you would have to shrink the second image
        
    end
    % close files
    fclose(procrustesDistShiftFileID);
    fclose(procrustesDeltasFileID);
    standardPlot = plot(standard(:,1), standard(:,2),'rx', 'MarkerSize', 5, 'LineWidth', 3,'DisplayName','Target'); % Plot standard leaf
    
    %legend('Target','Comparison', 'Transformed','location','SW')
    %legend('show')
    legend([standardPlot, comparisonPlot(1)], 'Standard', 'Comparison')
    axis equal;
        
    % Plot the mean landmark
    visualizeLandmarks(meanLandmarks(:,1), meanLandmarks(:,2), links, numExtPts);
    
    % Save the mean landmark to a file
    meanLandmarksFile = sprintf('mean_landmarks_%s.csv', exportFileName); 
    meanLandmarksFileID = fopen(meanLandmarksFile,'wt');
    % Write headers
    for i = 1:length(meanLandmarks(:,1))-1
        fprintf(meanLandmarksFileID, 'x%d,', i);
        fprintf(meanLandmarksFileID, 'y%d,', i);
    end
    fprintf(meanLandmarksFileID, '\n');
    % Print coordinates
    for i = 1:length(meanLandmarks(:,1))-1
        fprintf(meanLandmarksFileID, '%f,', meanLandmarks(i,1)); % print x coordinate
        fprintf(meanLandmarksFileID, '%f,', meanLandmarks(i,2)); % print y coordinate
    end
    fclose(meanLandmarksFileID);
end

% Split a 1-d array to a 2-d array with X-values in first col and Y-values
% in 2nd col
function splitArr = splitXYcoords(allLandmarks)
    %splitArr = zeros(size(allLandmarks,1)/2,2);
    rowCount = 1;
    for i=1:length(allLandmarks)
       if mod(i,2) ~= 0 % i is odd
           % Odd goes in first column as an x-coordinate
           splitArr(rowCount, 1) = allLandmarks(i);
       else
           splitArr(rowCount, 2) = allLandmarks(i);
           rowCount = rowCount + 1;
       end
       
    end
end