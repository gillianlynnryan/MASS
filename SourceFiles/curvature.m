%%
img_curve=imshow(smooth_rotated);
hold on;
plot(outlineLeaf(:,2),outlineLeaf(:,1),'r--','LineWidth',2.5);
ROI_curve=imrect();
BW = createMask(ROI_curve,img_curve);
regionoutput=regionprops(BW, 'BoundingBox');
%% find the 4 corners of the bounding box
x_upleft=regionoutput.BoundingBox(1,1);
y_upleft=regionoutput.BoundingBox(1,2);

x_upright=x_upleft+regionoutput.BoundingBox(1,3);
y_upright=y_upleft;

x_downleft=x_upleft;
y_downleft=y_upleft+regionoutput.BoundingBox(1,4);

x_downright=x_upright;
y_downright=y_downleft;
%% set xv and yv to enclose box around ROI, find all points of outline in this box
xv=[x_upleft x_downleft x_downright x_upright x_upleft];
yv=[y_upleft y_downleft y_downright y_upright y_upleft];
xq=outlineLeaf(:,2);
yq=outlineLeaf(:,1);
outline_ROI=inpolygon(xq,yq,xv,yv);
hold on
plot(xv,yv)
%% points from ROI that we want to measure the curvature of
x_outlineROI=xq(outline_ROI);
y_outlineROI=yq(outline_ROI);
outlineROI=[x_outlineROI y_outlineROI];

%% plot the point of the outline that are within the ROI
figure;
plot(x_outlineROI,y_outlineROI,'r+') % points inside
axis equal;
%% measuring curvature of line segment

% x=x_outlineROI;
% y=y_outlineROI;
% dx  = gradient(x);
% ddx = gradient(dx);
% dy  = gradient(y);
% ddy = gradient(dy);
% num   = dx .* ddy - ddx .* dy;
% denom = dx .* dx + dy .* dy;
% denom = denom .^(3/2);
% Curvature = num ./ denom;
% curvature(denom < 0) = NaN;
% curvature(abs(curvature) > 20) = 0;
% figure_curvate=figure;
% plot(x, Curvature, 'b-');
% hold on 
% plot(y, Curvature, 'r-');
% title('Curvatures');
x=x_outlineROI;
y=y_outlineROI;
xe = [x(3);x;x(end-2)]; ye = [y(3);y;y(end-2)];
dx = diff(xe); dy = diff(ye);
dxb = dx(1:end-1); dyb = dy(1:end-1);
dxf = dx(2:end); dyf = dy(2:end);
d2x = xe(3:end)-xe(1:end-2); d2y = ye(3:end)-ye(1:end-2);
curv = 2*(dxb.*dyf-dyb.*dxf)./ ...
       sqrt((dxb.^2+dyb.^2).*(dxf.^2+dyf.^2).*(d2x.^2+d2y.^2));


%%
% fig1=imshow(leafBw);
% ROI_curve=imrect();
% BW = createMask(ROI_curve,fig1);
% regionoutput=regionprops(BW, 'BoundingBox');
% %% find the 4 corners of the bounding box
% x_upleft=regionoutput.BoundingBox(1,1);
% y_upleft=regionoutput.BoundingBox(1,2);
% 
% x_upright=x_upleft+regionoutput.BoundingBox(1,3);
% y_upright=y_upleft;
% 
% x_downleft=x_upleft;
% y_downleft=y_upleft+regionoutput.BoundingBox(1,4);
% 
% x_downright=x_upright;
% y_downright=y_downleft;
% %% set xv and yv to enclose box around ROI, find all points of outline in this box
% xv=[x_upleft x_downleft x_downright x_upright x_upleft];
% yv=[y_upleft y_downleft y_downright y_upright y_upleft];
% xq=outlineLeaf(:,2);
% yq=outlineLeaf(:,1);
% outline_ROI=inpolygon(xq,yq,xv,yv);
% hold on
% plot(xv,yv)
% 
% %%
% x_outlineROI=xq(outline_ROI);
% y_outlineROI=yq(outline_ROI);
% 
% %% plot the point of the outline that are within the ROI
% hold on
% plot(x_outlineROI,y_outlineROI,'r+') % points inside













% %function [center, radius]=curvature(outlineLeaf,())
% %select the points of the outline within a ROI, find the curvature of those
% %points
% 
% %%%%%for testing only
% %img=('binary_sample_img.jpg');
% %fig1=imshow(img);
% %%%%
% 
% fig1=imshow(leafBw);
% ROI_curve=imrect();
% BW = createMask(ROI_curve,fig1);
% regionoutput=regionprops(BW, 'BoundingBox');
% %% find the 4 corners of the bounding box
% x_upleft=regionoutput.BoundingBox(1,1);
% y_upleft=regionoutput.BoundingBox(1,2);
% 
% x_upright=x_upleft+regionoutput.BoundingBox(1,3);
% y_upright=y_upleft;
% 
% x_downleft=x_upleft;
% y_downleft=y_upleft+regionoutput.BoundingBox(1,4);
% 
% x_downright=x_upright;
% y_downright=y_downleft;
% %% set xv and yv to enclose box around ROI, find all points of outline in this box
% xv=[x_upleft x_downleft x_downright x_upright x_upleft];
% yv=[y_upleft y_downleft y_downright y_upright y_upleft];
% xq=outlineLeaf(:,2);
% yq=outlineLeaf(:,1);
% outline_ROI=inpolygon(xq,yq,xv,yv);
% hold on
% plot(xv,yv)
% 
% %%
% x_outlineROI=xq(outline_ROI);
% y_outlineROI=yq(outline_ROI);
% 
% %% plot the point of the outline that are within the ROI
% hold on
% plot(x_outlineROI,y_outlineROI,'r+') % points inside
% 
% 
% 
% 
% %% second derivate calculated, how do I go from a 2nd derivate to a curvature.
% % code referenced: https://www.mathworks.com/matlabcentral/answers/58964-curvature-of-a-discrete-function
% %got curvature
% x=x_outlineROI;
% y=y_outlineROI;
% dx  = gradient(x);
% ddx = gradient(dx);
% dy  = gradient(y);
% ddy = gradient(dy);
% num   = dx .* ddy - ddx .* dy;
% denom = dx .* dx + dy .* dy;
% denom = denom .^(3/2);
% Curvature = num ./ denom;
% %curvature(denom < 0) = NaN;
% %curvature(abs(curvature) > 20) = 0;
% figure_curvate=figure;
% plot(x, Curvature, 'b-');
% hold on 
% plot(y, Curvature, 'r-');
% title('Curvatures');
 
%% unedited method, not complete
% figure;
% fig1=imshow(leafBw);
% ROI_curve=imrect();
% BW = createMask(ROI_curve,fig1);
% regionoutput=regionprops(BW, 'BoundingBox');
% %%
% % %% find the 4 corners of the bounding box
% x_upleft=regionoutput.BoundingBox(1,1);
% y_upleft=regionoutput.BoundingBox(1,2);
% % 
% x_upright=x_upleft+regionoutput.BoundingBox(1,3);
% y_upright=y_upleft;
% % 
% x_downleft=x_upleft;
% y_downleft=y_upleft+regionoutput.BoundingBox(1,4);
% % 
% x_downright=x_upright;
% y_downright=y_downleft;
% % %% set xv and yv to enclose box around ROI, find all points of outline in this box
% xv=[x_upleft x_downleft x_downright x_upright x_upleft];
% yv=[y_upleft y_downleft y_downright y_upright y_upleft];
% xq=outlineLeaf(:,2);
% yq=outlineLeaf(:,1);
% 
% outline_ROI=inpolygon(xq,yq,xv,yv);
% hold on
% plot(xv,yv)
% 
% %%
% x_outlineROI=xq(outline_ROI);
% y_outlineROI=yq(outline_ROI);
% 
% %% plot the point of the outline that are within the ROI
% hold on
% plot(x_outlineROI,y_outlineROI,'r+') % points inside
%% old method

figure;
fontSize = 20;

img=leafBw;
imshow(img);
h=imrect;
position =getPosition(h);
croppedline = imcrop(img, position);
figure;
imshow(croppedline)



grayImage =(croppedline);

figure;
[rows, columns] = size(leafBw);
numberOfColorBands=1;
% Display the original gray scale image.
subplot(2, 2, 1);
imshow(grayImage, []);
title('Original Grayscale Image');
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);


% Get the boundaries, but first you need to binarieze the image into a logical image.
binaryImage = grayImage;
% bwboundaries() returns a cell array, where each cell contains the row/column coordinates for an object in the image.
% Plot the borders of all the coins on the original grayscale image using the coordinates returned by bwboundaries.
subplot(2, 2, 2);
set(gca, 'ydir', 'reverse');
title('Outlines, from bwboundaries()');
hold on;
boundaries = bwboundaries(binaryImage);
%boundaries=Bound
numberOfBoundaries = 1;
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
end
hold off;

% Get the curvature at each point of the first curve.
x = boundaries{1}(:, 2);
y = boundaries{1}(:, 1);
windowSize = 19;
halfWidth = floor(windowSize/2);
curvatures = zeros(size(x));

for k = (halfWidth+1 : (length(x) - halfWidth));
	theseX = x(k-halfWidth:k+halfWidth);
	theseY = y(k-halfWidth:k+halfWidth);
	% Get a fit.
	coefficients = polyfit(theseX, theseY, 2);
	% Get the curvature
	curvatures(k) = coefficients(1);
	xc(k) = x(k);
	yc(k) = y(k);	
end

% Get rid of ridiculous curvatures (straight line segments).
curvatures(abs(curvatures) > 20) = 0;
subplot(2, 2, 3);
plot(x, curvatures, 'b-');
hold on 
plot(y, curvatures, 'r-');
title('Curvatures');

%Make up a colormap
minC = min(curvatures)
maxC = max(curvatures)
range = ceil(maxC - minC)
myColorMap = jet(range);
% Display the image again.
subplot(2,2,4);
imshow(binaryImage);
hold on;
for k = halfWidth+1 : length(x) - halfWidth
	% Get the index in the color map.
	thisIndex = round(size(myColorMap, 1) * (curvatures(k) - minC) / range)
	fprintf('For point #%d, the colormap index is %d\n', k, thisIndex);
	if thisIndex <= 0
		thisIndex = 1;
	end
	if isnan(thisIndex)
		thisIndex = 1;
	end
	% Extract out the RGB triplet for this particular row in the color map.
	thisColor = myColorMap(thisIndex, :);
	plot(x(k), y(k), '.', 'MarkerSize', 25, 'Color', thisColor);
end
title('Curvatures Indicated by Colors');