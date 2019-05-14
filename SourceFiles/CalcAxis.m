% CalcAxis.m
% Last modified 6/26/17 by A. Minasian
function [DMX,DMY,CMX,CMY,DNX,DNY,CNX,CNY] = CalcAxis(Stats)
% CalcAxis(Stats)
% Calculates the coordinates for where to draw major and minor axis lines
% Lines stem from the center of mass (centroid) of the leaf. Sometimes this
% calculation fails and gives back garbage. Redraw the image
%%
%CalcAxis is an extra function used in the program

% DMX,DMY,DNX, and DNY are simply components of the major & minor axes
% CMX,CMY,CNX, and CNY are just x & y coordinates of the ends of these axes 
    %lengths. Useful to drawing the lines
% DMX-->Delta Major X
% DMY-->Delta Major Y
% CMX-->Coordinate of Major X
% CMY-->Coordinate of Major Y
% DNX-->Delta Minor X
% DNY-->Delta Minor Y
% CNX-->Coordinate of Minor X
% CNY-->Coordinate of Minor Y

%Major Axis Calculations
DMX = Stats(1).MajorAxisLength*cosd(Stats(1).Orientation);
DMY = Stats(1).MajorAxisLength*sind(Stats(1).Orientation);
CMX = [Stats(1).Centroid(1)+DMX/2, Stats(1).Centroid(1)-DMX/2];
CMY = [Stats(1).Centroid(2)-DMY/2, Stats(1).Centroid(2)+DMY/2];

%Minor Axis Calculations
DNX = Stats(1).MinorAxisLength*cosd(Stats(1).Orientation+90);
DNY = Stats(1).MinorAxisLength*sind(Stats(1).Orientation+90);
CNX= [Stats(1).Centroid(1)-DNX/2,...
                Stats(1).Centroid(1)+DNX/2];
CNY = [Stats(1).Centroid(2)+DNY/2,...
                Stats(1).Centroid(2)-DNY/2];
end    