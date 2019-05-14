% export_coefficients.m
% Last modified: 2/17/18 by T. Chuanromanee
% Export EFD harmonic coefficients into two files:
% one with all coeffs for all harmonics, and one with coeffs for last
% harmonic
% FILE 1 FORMAT: number of harmonics, A1, ..., An, B1, ..., Bn, C1, ..., Cn, D1, ..., Dn
% FILE 2 FORMAT: number of harmonics, An, Bn, Cn, Dn

function export_coefficients(coefficients, exportFileName)
    %% Define variables
    numHarmonics = size(coefficients,1);
    numCoefficients = size(coefficients,2);
    firstOutputFileName = sprintf('all_coefficients_%s.csv', exportFileName); 
    secondOutputFileName = sprintf('%d_harmonics_coefficients_%s.csv', numHarmonics, exportFileName); 
    
    %% Check if files exist
    if exist(firstOutputFileName, 'file') == 2
       firstExportOption = 2; % Append
    else
        firstExportOption = 1; % Create
    end
    
    if exist(secondOutputFileName, 'file') == 2
       secondExportOption = 2; % Append
    else
        secondExportOption = 1; % Create
    end


    %% Process export
    if firstExportOption == 2
        firstFileID = fopen(firstOutputFileName,'a');
    elseif firstExportOption == 1
        firstFileID = fopen(firstOutputFileName,'w');
        % Write headers
        for i = 1:numCoefficients
            for j = 1:numHarmonics
                if i == 1
                    fprintf(firstFileID, 'A%d,', j);
                elseif i == 2
                    fprintf(firstFileID, 'B%d,', j);
                elseif i == 3
                    fprintf(firstFileID, 'C%d,', j);
                elseif i == 4
                    fprintf(firstFileID, 'D%d,', j);
                end
            end
        end
        fprintf(firstFileID, '\n'); % Add new line
    else
        disp('Invalid selection. Exiting...');
        return;
    end
    
    if secondExportOption == 2
        secondFileID = fopen(secondOutputFileName,'a');
    elseif secondExportOption == 1
        secondFileID = fopen(secondOutputFileName,'w');
        % Write headers
        fprintf(secondFileID, 'A%d,', numHarmonics);
        fprintf(secondFileID, 'B%d,', numHarmonics);
        fprintf(secondFileID, 'C%d,', numHarmonics);
        fprintf(secondFileID, 'D%d,', numHarmonics);
        fprintf(secondFileID, '\n'); % Add new line
    else
        disp('Invalid selection. Exiting...');
        return;
    end
    
    %% Extract each harmonic's coefficient
    % preallocate coefficient arrays
    an = zeros(numHarmonics);
    bn = zeros(numHarmonics);
    cn = zeros(numHarmonics);
    dn = zeros(numHarmonics);
    for i=1:numHarmonics
        an(i) = coefficients(i,1);
        bn(i) = coefficients(i,2);
        cn(i) = coefficients(i,3);
        dn(i) = coefficients(i,4);
    end
    
    %% Write to files    
    % Write coefficients to first file
    for i=1:numCoefficients
        for j=1:numHarmonics
            if i == 1
               fprintf(firstFileID, '%f,', an(j));
            elseif i == 2
               fprintf(firstFileID, '%f,', bn(j));
            elseif i == 3
               fprintf(firstFileID, '%f,', cn(j));
            elseif i == 4
               fprintf(firstFileID, '%f,', dn(j));
            end
        end
    end
    fprintf(firstFileID, '\n'); % Add new line
    
    % Write coefficients to second file
   fprintf(secondFileID, '%f,', an(numHarmonics));
   fprintf(secondFileID, '%f,', bn(numHarmonics));
   fprintf(secondFileID, '%f,', cn(numHarmonics));
   fprintf(secondFileID, '%f,', dn(numHarmonics));
    fprintf(secondFileID, '\n'); % Add new line
    
    % Close both files
    fclose(firstFileID);
    fclose(secondFileID);
end