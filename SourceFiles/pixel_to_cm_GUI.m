% pixel_to_cm.m
% Last modification: 11/5/2017 by T. Chuanromanee
% Opens a new figure and displays instructions
% User crops part of the image and draws a line on the cropped segment and
% line segment length is determined. Length and unit already known

function [distanceinpixels,croppedscale] = pixel_to_cm_GUI(img, distance, unit)

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

calibration.units = unit;
calibration.distanceInPixels = distanceinpixels;
 % Data has already been validated by user input in GUI
close(scale.fig);
close(crop.fig);
end

function msgboxw(message)
uiwait(msgbox(message));
end


