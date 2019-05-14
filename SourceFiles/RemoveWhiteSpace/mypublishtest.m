% test example
% © February 2nd, 2012, By Reza Farrahi Moghaddam, Synchromedia Lab, ETS, Montreal, Canada

% with image
u_in = mat2gray(imread('test.png'));
figure, imshow(u_in);
figure, imshow(RemoveWhiteSpace(u_in));


% with file
RemoveWhiteSpace([], 'file', 'test.png', 'output', 'test_out.png');
