% compute_harmonic_power.m
% Last modified: 10/1/17 by T. Chuanromanee
% Compute harmonic power given function by Bonhomme, Picq, Gaucherel, &
% Claude, 2014 (momocs) p. 14

function compute_harmonic_power(coefficients)
    numharmonics = size(coefficients,1);
    % Construct an array to store the harmonic power of each harmonic
    harmonicPower = zeros(numharmonics,1); 
    for i=1:numharmonics
        an = coefficients(i,1);
        bn = coefficients(i,2);
        cn = coefficients(i,3);
        dn = coefficients(i,4);
        ithPowHarmonic = (power(an,2) + power(bn,2) + power(cn,2) + power(dn,2))/2;
        harmonicPower(i) = ithPowHarmonic;
    end
end