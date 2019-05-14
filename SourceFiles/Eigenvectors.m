% Eigenvectors.m
% Last modification: 7/5/2017 by T. Chuanromanee
% Rotates the leaf to be vertical. Identify principal axes, and rotate image
% by the difference between the major axis and the vertical axis 

function [theta_shortaxis,theta_longaxis] = Eigenvectors(leafBw)
% generate 2D inertia tensor for image based on binary image values using
% cov command, then use eig command to generate eigenvectors and
% eigenvalues for image.
[y,x]=find(leafBw);
cov_matrix=cov(x,y);
[evectors,~]=eig(cov_matrix);

%%
dim_leafBw=size(leafBw);
%initialize variables
sumX=0;
sumY=0;
% find the center of mass of image
for ii=1:dim_leafBw(1)
    for jj=1:dim_leafBw(2)
        sumX=sumX+ii*leafBw(ii,jj);
        sumY=sumY+jj*leafBw(ii,jj);    
    end
end
% sumBw=sum(sum(leafBw));
% COMy=(sumX/sumBw);
% COMx=(sumY/sumBw);

q2=acos(evectors(1,2));
theta_longaxis=rad2deg(q2);
q1=asin(evectors(2,1));
theta_shortaxis=rad2deg(q1);
