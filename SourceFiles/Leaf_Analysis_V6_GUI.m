%%Leaf_Analysis_V6_GUI.m
% Last modified: 8/15/18 by T. Chuanromanee
% Operations performed:
% analyze a leaf image selected by a user.
% First uses ImageSelect to get that user's image
% Then manipulates leaf image as needed, and 
% prints an assortment of figures and data.

function Leaf_Analysis_V6_GUI(rulerLength, rulerUnits, choices, numHarmonics, numLandmarks, numExtPts, landmarkLinks)
% read choices
    efdChecked = choices(1);
    landmarksChecked = choices(2);
    procrustesChecked = choices(3);
    pcaChecked = choices(4);
    superimposeOutlinesChecked = choices(5);
    widerThanLong = choices(6);
    measureTipAngle = choices(7);
    rotate45degs = choices(8);
    
    % Determine export file name (for date in the name)
    exportFileName = datestr(now, 'yyyy_mm_dd_HHMMSS');
    if (efdChecked == 1) || (landmarksChecked == 1)
        %% Read image through ImageSelect function (utilizing a figure)
        %read selected image
        %clear all;
        % Turn off image warning to reduce console noise
        warning('off', 'Images:initSize:adjustingMag');
        Image = ImageSelect();

         % If the user presses cancel during the file selection, then should
         % terminate the program
         % Variable filename will be 0 when the user does not select an image

         if Image == 0
             disp('No file selected. Please try again.');
             close all;
             return;
         end

        img = imread(Image);

        % Check ruler length is invalid (If so, user has not entered any value)
        if (rulerLength <= 0 && basicAnalysisChecked)
            %measure 1 cm on a reference object to get ratio of pixels to inches
             [distanceinpixels,croppedscale] = pixel_to_cm(img);
            % If the user gives invalid input for distance and unit, terminate.
            % Variable distanceinpixels will be -1 when the user  gives a bad value
        else
            distanceinpixels = pixel_to_cm_GUI(img, rulerLength, rulerUnits);
        end
        if distanceinpixels == -1
         disp('Program terminated. Please try again.');
         close all;
         return;
        end
        %%
        %convert image to gray, smooth grayed image for clean boundary
        img_gray = rgb2gray(img);
        img_gray_smooth=medfilt2(img_gray,[5 5]);
        full_gray_smooth = img_gray_smooth; % backup version of img_gray_smooth
        continue_analysis = 'Yes';
        % Loop for multiple leaves
        while (strcmp(continue_analysis, 'Yes') == 1)
            % 2) Display image and store handle:
            % reset value of img_gray_smooth since it has been overwritten
            img_gray_smooth = full_gray_smooth; 
            fig.bound=figure;
            imshow(full_gray_smooth);
            title('Draw outline around leaf');
            
            
            userconfirm = 'No';
            % 3) Create a freehand ROI:
            e = impoly(gca);
            while strcmp(userconfirm, 'No')
                userconfirm = questdlg('Confirm selection?','Confirm selection');
                if strcmp(userconfirm, 'No')
                    delete(e);
                    e = impoly(gca);
                else
                    break
                end
            end
            if strcmp(userconfirm, 'Cancel')
               disp('Outline selection cancelled.'); 
               % Actually quit the process
               return;
            end

            % 4) Create a mask from the ROI:
            BW = createMask(e);
            close(fig.bound);

            %%
            %Set the pixels outside ROI to white to prevent the ROI border
            %from being binarized, white is used because our images are dark leaves on
            %a light background
            img_gray_smooth(BW == 0) = 255;
            %binarize gray img
            img_bw_i = imbinarize(img_gray_smooth);
            %clean holes in image below 3000 pixels in area
            %this can be adjusted for smaller images
            img_bw_cleaned = bwareaopen(img_bw_i,500);
            img_bw = imcomplement(img_bw_cleaned);
            img_cleaned = bwareaopen(img_bw, 500);
            leafBw = img_cleaned;
            %display leaf
            %figure, imshow(leafBw);

            %%
            %use eigenvectors function to retrieve angle between principal axes and
            %x-axis
            [theta_shortaxis,theta_longaxis] = Eigenvectors(leafBw); 
            if widerThanLong ~= 1 % User specifies if leaf width is greater than length
                theta_longaxis = theta_shortaxis + 180; % Use the short axis and rotate 180 degrees to compensate for upside down
            end
            if rotate45degs == 1
                theta_longaxis = theta_longaxis + 45;
            end
            %theta_longaxis = theta_longaxis + 45;
            rotatedLeafBw = imrotate(leafBw,(theta_longaxis)); %+ 90));
            %rotatedLeafBw = imrotate(rotatedLeafBw, 180);
            smooth_rotated=medfilt2(rotatedLeafBw,[5 5]);
            % imshow(smooth_rotated);

            %%
            % Find outline on smoothed, rotated leaf. 8-connected outline.
            Bound = bwboundaries(smooth_rotated, 8,'noholes');
            outlineLeaf = cell2mat(Bound); %make outline a matrix
            [normalized_outline, ratioScale] = normalize_outline(outlineLeaf);
            
            % Uncomment the next 8 lines if want to plot normalized outline
                 figure;
                hold on;
                elliptic_fourier_title = sprintf('Normalized outline');
                title(elliptic_fourier_title);
                xlabel('Width') % x-axis label
                ylabel('Length') % y-axis label
                plot(normalized_outline(:,2), normalized_outline(:,1), 'linewidth', 2.5);
                axis equal;

            %Again find region properties of new rotation to show 
                %major/minor axis lines & CM
            LeafBwStats = regionprops(smooth_rotated,'all');
            [RDMX,RDMY,RCMX,RCMY,RDNX,RDNY,RCNX,RCNY] = CalcAxis(LeafBwStats);

            tabledatarotated = regionprops('Table',smooth_rotated, 'Centroid',...
                'Orientation', 'MajorAxisLength', 'MinorAxisLength','FilledArea',...
                'BoundingBox');

            length_pixel = tabledatarotated.BoundingBox(1,4);
            width_pixel = tabledatarotated.BoundingBox(1,3);

            rotateBWFig = figure('name','Analysis 2 of Selected Image');
            imshow(smooth_rotated);
            hold on, title('Rotated leaf BW with curves highlighted');
             plot(imgca,LeafBwStats(1).Centroid(:,1),...
             LeafBwStats(1).Centroid(:,2),'r*');
             line(RCMX,RCMY);
            line(RCNX,RCNY);
            %set(impixelinfo,'Position',[5, 1 300 20]);
            plot(outlineLeaf(:,2),outlineLeaf(:,1),'r--','LineWidth',1);
            %plots the outline 
            %subplot(1,2,2),imshow(croppedscale,'InitialMagnification',100);
            % Get the area of the leaf
            area_pixel = LeafBwStats.Area;
            % Get the perimeter of the leaf
            perimeter_pixel = LeafBwStats.Perimeter;
            % Get the are of convex hull in pixels
            solidity = LeafBwStats.Solidity;

            %Print ellipse based measurements from regionprops and length width ratio
            %of the leaf
            %disp(tabledatarotated);
            Length_cm = length_pixel/distanceinpixels;
            Width_cm = width_pixel/distanceinpixels;
            perimeter_cm = perimeter_pixel/distanceinpixels;
            area_cm2 = area_pixel/(distanceinpixels * distanceinpixels);
            
            % Computed values 
            fluctuatingAsymm = symmetry(normalized_outline);
            lengthWidthRatio = length_pixel/width_pixel; 
            roundness = 4 * (area_cm2 / (pi * Length_cm * Length_cm));
            circularity = 4 * pi * (area_cm2 / (perimeter_cm * perimeter_cm));
            % if user wants to measure leaf angle
            if measureTipAngle == 1
                line_angle;
            end
            % Export length, width, ratio, leaf tip angle, asymmetry
            measurementsFile = sprintf('measurements_%s.csv', exportFileName); 
            if exist(measurementsFile, 'file') == 2
                measFileID = fopen(measurementsFile,'a');
            else
                measFileID = fopen(measurementsFile,'wt');
                fprintf(measFileID, '%s,', 'Length(cm');
                fprintf(measFileID, '%s,', 'Width(cm)');
                fprintf(measFileID, '%s,', 'Area(cm^2)');
                fprintf(measFileID, '%s,', 'L/W Ratio');
                if measureTipAngle == 1
                    fprintf(measFileID, '%s,', 'Leaf Tip Angle');
                end
                fprintf(measFileID, '%s,', 'Fluctuating Asymmetry');
                fprintf(measFileID, '%s,', 'Roundness');
                fprintf(measFileID, '%s,', 'Circularity');
                fprintf(measFileID, '%s,', 'Solidity');
                fprintf(measFileID, '\n');
            end
            fprintf(measFileID, '%f,', Length_cm);
            fprintf(measFileID, '%f,', Width_cm);
            fprintf(measFileID, '%f,', area_cm2);
            fprintf(measFileID, '%f,', lengthWidthRatio);
            if measureTipAngle == 1
                fprintf(measFileID, '%f,', tipAngle);
            end
            fprintf(measFileID, '%f,', fluctuatingAsymm);
            fprintf(measFileID, '%f,', roundness);
            fprintf(measFileID, '%f,', circularity);
            fprintf(measFileID, '%f,', solidity);
            close(rotateBWFig);
            % close(rotatedleafFig);

            %% EFD section
            if (efdChecked == 1) && (numHarmonics > 0)
                [efdOutline, coefficients] = efd_setup(numHarmonics, normalized_outline, ratioScale);
                isMean = false;
                export_outline(efdOutline, exportFileName, isMean);
                export_coefficients(coefficients, exportFileName);
            elseif (efdChecked == 1)
                disp("Must have number of harmonics greater than 0")
            end
            fprintf(measFileID, '\n');
            fclose(measFileID);
            %% Landmarks section
            if (landmarksChecked == 1) && (numLandmarks > 0)
                landmarks(img_gray_smooth, theta_longaxis, widerThanLong, numLandmarks, exportFileName, numExtPts, landmarkLinks);
            elseif (landmarksChecked == 1)
                disp("Must have number of landmarks greater than 0")
            end
            continue_analysis = questdlg('Do you want to process any additional leaves?','Continue analysis?');
        end % end while loop
    end % End if EFD/landmarks are checked
    
    %% Do mass analyses
    if procrustesChecked == 1
       procrustes_analysis(numExtPts, landmarkLinks); 
    end
    if pcaChecked == 1
       pca_analysis; 
    end
    if superimposeOutlinesChecked == 1
       superimpose_outlines; 
    end
end
