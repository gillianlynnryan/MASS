% export_outline.m
% Last modified:6/9/18 by T. Chuanromanee
% Export EFD outlines to a CSV file, at the preference of the user
function export_outline(normEFD, exportFileName, isMean)
    %% Define variables
    % have user set output file
    if isMean == false
        outputFileName = sprintf('outlines_%s.csv', exportFileName); 
    else
        outputFileName = sprintf('mean_outlines_%s.csv', exportFileName); 
    end
    
    %% Process export
    fileID = fopen(outputFileName,'wt');
    if fileID == -1 
        disp('Invalid file selection. Exiting...');
        return;
    end
    fprintf(fileID, '%s', '[');
    for i=1:size(normEFD,1)
       fprintf(fileID, '%f ', normEFD(i,1));
       fprintf(fileID, '%f, ', normEFD(i,2));
    end
    fprintf(fileID, '%s\n', ']');
    fclose(fileID);
end