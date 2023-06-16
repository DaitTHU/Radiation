function [mu, muen] = Xmu(E, Z, fraction)
%{
% AUTHOR: wyp, Dait
% XMU:
%     X-Ray Mass Attenuation Coefficients
% INPUT:
%     E (MeV): vector
%     Z, or struct have Z/composition field
%     fraction: mass fraction of each Z
% OUTPUT:
%     mu (cm2/g): mu/rho
%     muen (cm2/g): muen/rho
%}
arguments
    E (:, 1) {isnumeric}
    Z (:, 1)
    fraction (:, 1) = ones(size(Z))
end
if isnumeric(Z)
    fraction = fraction / sum(fraction);
elseif isstruct(Z)
    if isfield(Z, 'Z')
        Z = Z.Z; fraction = 1;
    else
        fraction = Z.composition(:, 2);
        Z = Z.composition(:, 1);
    end
end
mu2 = 0;
for ii = 1 : numel(Z)
    xmu = Material.getXmu(Z(ii));
    mu2 = mu2 + fraction(ii) .* ...
        interp1(xmu(:, 1), xmu(:, 2 : 3), E, "spline");
end
if nargout == 1
    mu = mu2;
    return
end
mu = mu2(:, 1); muen = mu2(:, 2);
end
