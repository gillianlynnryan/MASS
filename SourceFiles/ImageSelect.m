% ImageSelect.m
% Last modification: 8/9/2017 by T. Chuanromanee
% searches the same folder as the LeafAnalysis program for .png, .jpg, and .bmp files. 
% The image is read and assigned the variable “img” at the start of the program.

function completename = ImageSelect()
%% ImageSelect()
% ask for a new image from user
%Select file from Windows Explorer
[filename, pathname] = ...
     uigetfile({'*.*';'*.png';'*.jpg';'*.JPG';'*.JPEG';'*.TIFF';'*.tiff';'*.tif';'*.TIF';'*.bmp'},'Select an image');
 
completename = fullfile(pathname, filename);
 
 % If the user presses cancel during the file selection, then should
 % terminate the program
 % Variable filename will be 0 when the user does not select an image
%  
 if filename == 0
     uiwait(msgbox('No file Selected! Please retry.'));
 end
%  close(h.fig)