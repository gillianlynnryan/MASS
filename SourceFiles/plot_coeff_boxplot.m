% plot_coeff_boxplot.m
% Last modified: 10/22/17 by T. Chuanromanee
% Plot the coefficient boxplots for harmonic coefficients


function plot_coeff_boxplot
    %% Based on https://stackoverflow.com/questions/29155899/matlab-multipleparallel-box-plots-in-single-figure
    % Get file and coefficients from CSV
    inputFile = uigetfile('*.csv','Select an input CSV file');
    if inputFile == 0
        disp('No input file selected. Quitting...');
       return;
    end
    harmonicArray = csvread(inputFile,1,0); % Start reading at 1 row from the first row at 1st col 
    numHarmonics = 5;
    
    figure;
    color = colormap(parula(numHarmonics));
    C = [color; ones(4,3); color];  % this is the trick for coloring the boxes

    labelCell = {'','','1','','','','2','','','','3','','','','','4','','','','','','5','','',''};
    % regular plot
    boxplot(harmonicArray, 'colors', C, 'plotstyle', 'compact', ...
        'labels', labelCell); % label only two categories
    hold on;
    for ii = 1:4
        plot(NaN,1, 'color', color(ii,:), 'LineWidth', 4);
    end

    title('Coefficients');
    ylabel('Amplitude');
    xlabel('Harmonics');
    legend({'Coefficient A', 'Coefficient B', 'Coefficient C', 'Coefficient D'});

    %set(gca, 'XLim', [0 8], 'YLim', [-5 5]);
    
end