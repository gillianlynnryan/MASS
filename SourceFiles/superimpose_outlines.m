% superimpose_outlines.m
% Last modified: 8/30/18 by T. Chuanromanee
% Superimposes EFD outlines from a CSV file

function superimpose_outlines(~)
    %% Get file and PC information
    exportFileName = datestr(now, 'yyyy_mm_dd_HHMMSS');
    [inputFile, inputDirectory] = uigetfile('*.csv','Select an input CSV file','MultiSelect','on');
    
    if isequal(class(inputFile), 'cell') % Index cell array if multiple files selected
        for i=1:length(inputFile)
            inputPath = fullfile(inputDirectory, inputFile{i});
           tempOutlineArray = importdata(inputPath); % Start reading at 1 row from the first row at 1st col 
           % Concatenate numerical data
            if i == 1
               outlineArray = tempOutlineArray;
            else
                outlineArray = vertcat(outlineArray, tempOutlineArray);
            end
        end
    elseif inputFile == 0
        msgbox('No input file selected. Please try again!','Error');
       return;
    else % Only one file is selected
        inputPath = fullfile(inputDirectory, inputFile);
        outlineArray = importdata(inputPath);
    end
    
    % Set up figure
    figure;
    hold on;
    title('Outline Comparisons');
    xlabel('Width (AU)') % newLeaf-axis label
    ylabel('Length (AU)') % standard-axis label
    % Plot each outline
    for i=1:length(outlineArray) % Each outline
        currOutline = outlineArray(i); % currOutline is a cell
        currOutline = cell2mat(currOutline); % Convert to a matrix
        currOutline = currOutline(2:length(currOutline)-1); % Crop brackets
        % Format as an array for easy plotting
        formattedOutlineStr = char(currOutline);
        formattedOutlineStr = strrep(formattedOutlineStr,';',' ');
        formattedOutlineStr = strrep(formattedOutlineStr,',',' ');
        formattedOutlineStr = char(strsplit(formattedOutlineStr));
        outlineFinal = reshape(str2num(formattedOutlineStr), 2, [])';
        plot(outlineFinal(:,1), outlineFinal(:,2), 'Color', [0,0.7,0.9], 'linewidth', 0.5);
        if i == 1
            % totalOutlineFinal contains all the outlines concatenated into
            % one matrix horizontally, used for computing the mean outline
            totalOutlineFinalXCoords = outlineFinal(:,1);
            totalOutlineFinalYCoords = outlineFinal(:,2);
        else
            totalOutlineFinalXCoords = horzcat(totalOutlineFinalXCoords, outlineFinal(:,1));
            totalOutlineFinalYCoords = horzcat(totalOutlineFinalYCoords, outlineFinal(:,2));
        end
    end
    hold off;
    axis equal;
    
    % Compute and plot the mean outline
    meanOutlineXCoords = mean(totalOutlineFinalXCoords, 2); % mean of the columns
    meanOutlineYCoords = mean(totalOutlineFinalYCoords, 2); % mean of the columns
    figure;
    hold on;
    title('Mean Outline');
    xlabel('Width (AU)') % newLeaf-axis label
    ylabel('Length (AU)') % standard-axis label
    plot(meanOutlineXCoords, meanOutlineYCoords, 'Color', [0,0.7,0.9], 'linewidth', 0.5);
    axis equal;
    totalOutlineFinal = horzcat(meanOutlineXCoords, meanOutlineYCoords);
    % Save the mean outline to a file
    isMean = true;
    export_outline(totalOutlineFinal, exportFileName, isMean);
end
