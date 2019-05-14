% line_angle.m
% Last modified: 02/26/2018 by T. Chuanromanee
% Crop image to magnify leaf tip and calculate angle of leaf tip
angle_fig = figure;
img=img_gray_smooth;
imshow(img);
title('drag a box around leaf tip to magnify')
userconfirm = 'No';
% User draws rectangle
h=imrect;
while strcmp(userconfirm, 'No')
    userconfirm = questdlg('Confirm selection?','Confirm selection');
    if strcmp(userconfirm, 'No')
        delete(h);
        h=imrect;
    else
        break
    end
end
if strcmp(userconfirm, 'Cancel')
   disp('Angle selection cancelled.'); 
   % Actually quit the process
   return;
end
position = getPosition(h);
croppedline = imcrop(img, position);
angleLineSegFig = figure;
imshow(croppedline)
title('Draw three points along leaf tip, terminate line with right click')
userconfirm = 'No';
[~, ~, ~, xi,yi] = improfile; % Draw 3 points along the leaf tip and saves x and y coordinates
while strcmp(userconfirm, 'No')
    userconfirm = questdlg('Confirm selection?','Confirm selection');
    if strcmp(userconfirm, 'No')
        [~, ~, ~, xi,yi] = improfile; % Draw 3 points along the leaf tip and saves x and y coordinates
    else
        break
    end
end
if strcmp(userconfirm, 'Cancel')
   disp('Angle selection cancelled.'); 
   % Actually quit the process
   return;
end
imshow(croppedline)
hold on;
plot(xi, yi, 'b-', 'LineWidth', 2);

x1 = xi(1,1);
x2 = xi(2,1);
x3 = xi(3,1);
y1 = yi(1,1);
y2 = yi(2,1);
y3 = yi(3,1);

% theta1 = atan((y1-y2)/(x1-x2));
% theta2 = atan((y2-y3)/(x2-x3));
% theta = theta1-theta2;
% angle = rad2deg(theta) %#ok<NOPTS>

% dot product
vector1 = [(x1-x2),(y1-y2)];
vector2 = [(x3-x2),(y3-y2)];
dp = dot(vector1, vector2);
length1 = sqrt(sum(vector1.^2));
length2 = sqrt(sum(vector2.^2));
tipAngle = acos(dp/(length1.*length2))*180/pi;
close(angle_fig);
close(angleLineSegFig);