%%Leaf_Analysis_V6.m
% Last modified: 1/15/18 by T. Chuanromanee
% Operations performed:
    %analyze a leaf image selected by a user.
    %First uses ImageSelect to get that user's image
    %Then manipulates leaf image as needed, and 
    %prints an assortment of figures and data.
    

%% Read image through ImageSelect function (utilizing a figure)
%read selected image
clear all;
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

%measure 1 cm on a reference object to get ratio of pixels to inches
 [distanceinpixels,croppedscale] = pixel_to_cm(img);
% If the user gives invalid input for distance and unit, terminate.
% Variable distanceinpixels will be -1 when the user  gives a bad value

if distanceinpixels == -1
 disp('Program terminated. Please try again.');
 close all;
 return;
end
%%
%convert image to gray, smooth grayed image for clean boundary
img_gray = rgb2gray(img);
img_gray_smooth=medfilt2(img_gray,[5 5]);
% 2) Display image and store handle:
fig.bound=figure;
imshow(img_gray_smooth);
title('Draw outline around leaf');
% 3) Create a freehand ROI:
e = impoly(gca);
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
rotatedLeafBw = imrotate(leafBw,(theta_longaxis + 90));
rotatedLeafBw = imrotate(rotatedLeafBw, 180);
smooth_rotated=medfilt2(rotatedLeafBw,[5 5]);
% imshow(smooth_rotated);

%%
% Find outline on smoothed, rotated leaf. 8-connected outline.
Bound = bwboundaries(smooth_rotated, 8,'noholes');
outlineLeaf = cell2mat(Bound); %make outline a matrix
    
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
    plot(outlineLeaf(:,2),outlineLeaf(:,1),'r--','LineWidth',2.5);
    %plots the outline 
    %subplot(1,2,2),imshow(croppedscale,'InitialMagnification',100);
% Get the area of the leaf
area_pixel = LeafBwStats.Area;
    
%Print ellipse based measurements from regionprops and length width ratio
%of the leaf
disp(tabledatarotated);
% Check if length and width are switched or not, apparent when W > L
if length_pixel < width_pixel % Length should always be >= width, so switch them if this isn't the case
   temp = length_pixel;
   length_pixel = width_pixel;
   width_pixel = temp;
end
Length_cm = length_pixel/distanceinpixels;
Width_cm = width_pixel/distanceinpixels;
area_cm2 = area_pixel/(distanceinpixels * distanceinpixels);
disp('Length(cm)');
disp(Length_cm);
disp('width(cm)');
disp(Width_cm);
disp('area(cm^2)');
disp(area_cm2);
disp('Length to Width ratio (L/W): ');
lengthWidthRatio = length_pixel/width_pixel; %If LWR>1 Length is longer
disp(lengthWidthRatio);    

% leaf angle
line_angle;
efd_setup;
export_outline(efdOutline);

% Export length, width, ratio, leaf tip angle, asymmetry
measurementsFile = 'measurements.txt';
if exist(measurementsFile, 'file') == 2
    measFileID = fopen(measurementsFile,'a');
    fprintf(measFileID, '\n');
else
    measFileID = fopen(measurementsFile,'wt');
    fprintf(measFileID, '%s \t', 'Length(cm');
    fprintf(measFileID, '%s \t', 'Width(cm)');
    fprintf(measFileID, '%s \t', 'Area(cm^2)');
    fprintf(measFileID, '%s \t', 'L/W Ratio');
    fprintf(measFileID, '%s \t', 'Leaf Tip Angle');
    fprintf(measFileID, '%s', 'Fluctuating Asymmetry');
    fprintf(measFileID, '\n');
end
% fprintf(measFileID, '\n');
% fprintf(measFileID, '\n%f \t', Length_cm);
% fprintf(measFileID, '%f \t', Width_cm);
% fprintf(measFileID, '%f \t', area_cm2);
% fprintf(measFileID, '%f \t', lengthWidthRatio);
% fprintf(measFileID, '%f \t', angle);
% fprintf(measFileID, '%f', fluctuatingAsymm);
% fprintf(measFileID, '\n');
fclose(measFileID);
%landmarks(img_gray_smooth, theta_longaxis, 0); % Landmarks to be 0 for
%command line
close(rotateBWFig);
% close(rotatedleafFig);
