% pixel_to_cm.m
% Last modification: 7/5/2017 by T. Chuanromanee
% Opens a new figure and displays instructions
% User crops part of the image and draws a line on the cropped segment and
% line segment length is determined. User inputs the length and unit.

function [distanceinpixels,croppedscale] = pixel_to_cm(img);

% used as reference: https://www.mathworks.com/matlabcentral/answers/uploaded_files/65467/spatial_calibration_demo.m
scale.fig = figure;
imshow(img);
title('Select scalebar');
instructions = sprintf('Draw a box around the scalebar to magnify selection easier.\nThen, left-click to anchor first endpoint of line.\nRight-click or double-left-click to anchor second endpoint of line.\n\nThen, enter real-world distance of the line.');
	%title(instructions);
	msgboxw(instructions);
userconfirm = 'No';
% User draws rectangle
hscale=imrect;
while strcmp(userconfirm, 'No')
    userconfirm = questdlg('Confirm selection?','Confirm selection');
    if strcmp(userconfirm, 'No')
        delete(hscale);
        hscale=imrect;
    else
        break
    end
end
if strcmp(userconfirm, 'Cancel')
   disp('Selection cancelled.'); 
   distanceinpixels = -1;
   croppedscale = -1;
   % Actually quit the process
   return;
end
position = getPosition(hscale);
croppedscale = imcrop(img, position);
crop.fig = figure;
imshow(croppedscale);
truesize;
userconfirm = 'No';
% User draws rectangle
while strcmp(userconfirm, 'No')
    [~, ~, ~, xi, yi] = improfile;
    userconfirm = questdlg('Confirm line segment?','Confirm line');
end
if strcmp(userconfirm, 'Cancel')
   disp('Line segment selection cancelled.'); 
   % Actually quit the process
   distanceinpixels = -1;
   croppedscale = -1;
   return;
end
% xi and yi are the positions of the 2 points of the line segment
distanceinpixels = sqrt( (xi(2)-xi(1)).^2 + (yi(2)-yi(1)).^2);
hold on;
lastDrawnHandle = plot(xi, yi, 'y-', 'LineWidth', 2);

userPrompt = {'Enter real world units (cm by default):','Enter distance in those units:'};
dialogTitle = 'Specify calibration information';
numberOfLines = 1;
defaultAnswer = {'cm', '1'};
answer = inputdlg(userPrompt, dialogTitle, numberOfLines, defaultAnswer);

if isempty(answer)
    disp('Must include units and measurement');
    distanceinpixels = -1; % Flag value that something is not right.
	return;
end
distance = str2double(answer{2,1}); % Convert distance from a string to a number for comparison
calibration.units = answer{1};
calibration.distanceInPixels = distanceinpixels;
if (~strcmp(calibration.units,'cm') && ~strcmp(calibration.units,'in'))
    disp('Measurement must be in either in inches ("in") or centimeters ("cm")');
    distanceinpixels = -1; % Flag value that something is not right.
    return;
elseif distance <= 0
    disp('Measurement must be more than 0. Please try again.');
    distanceinpixels = -1; % Flag value that something is not right.
    return;
elseif isnan(distance) % User entered a non-numeric value as distance
    disp('distance must be a number');
    distanceinpixels = -1; % Flag value that something is not right.
    return;
end
close(scale.fig);
close(crop.fig);
end

function msgboxw(message)
uiwait(msgbox(message));
end


