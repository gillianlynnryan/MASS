% efd_setup.m
% Last modified: 3/1/18 by T. Chuanromanee
% Normalize image, given the leaf outline from Leaf_Analysis_V6.m, get the
% chain code, and plot the elliptical fourier approximation

function [efdOutline, coefficients] = efd_setup(num_harmonics, normalized_outline, ratioScale)
%% Declare variables
    num_reconstruction_pts = 100;
    normalized_already = 1;
    unwrap = 0;
    
%% Get chain code and elliptic Fourier
    cc = cell(1, length(normalized_outline)); % pre-allocate chain code matrix
    cc{1} = chaincode(normalized_outline, ratioScale, unwrap); % get chain code for the k'th object
    % Uncomment the next 5 lines if plotting the chain code is desired
%     figure;
%     hold on;
%     title('Chain code');
%     axis equal;
%     plot_chain_code(cc{1,1}.code);
    % Once we have the chain code, can get fourier approximation
    [efdOutline, coefficients] = plot_fourier_approx(cc{1,1}.code, num_harmonics, num_reconstruction_pts, normalized_already, 'r');
%% Plot normalized EFD
    figure;
    hold on;
    elliptic_fourier_title = sprintf('Normalized Elliptical Fourier Approximation, %d harmonics', num_harmonics);
    title(elliptic_fourier_title);
    xlabel('Width (AU)') % x-axis label
    ylabel('Length (AU)') % y-axis label
    % Once we have the chain code, can get fourier 
    [normalized_efd, ratioScale] = normalize_outline(efdOutline);
    normalized_efd(:,1) = -normalized_efd(:,1);
    efdOutline = normalized_efd; % Update efd outline variable
    plot(normalized_efd(:,1), normalized_efd(:,2), 'linewidth', 2.5);
    axis equal;
    compute_harmonic_power(coefficients);
end