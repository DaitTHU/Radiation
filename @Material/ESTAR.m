function [Sc, Sr, St, Rc, Y, Erho] = ESTAR(T, Z, fraction)
%{
% AUTHOR: wyp, Dait
% ESTAR:
%  stopping power and range of electron
% INPUT:
%         T = proton kinetic energy, MeV
%         Z = Z, or struct have Z/composition field
%  fraction = mass fraction of each Z
% OUTPUT:
%   STOP(c) = collision stopping power, MeV cm2/g
%   STOP(r) = radiation stopping power, MeV cm2/g
%   STOP(t) = total stopping power, MeV cm2/g
%  RANGE(c) = csda range, g/cm2 (computational statistics and data anaylsis)
%         Y = radiation yield
%     E_rho = density effect
%}
arguments
    T (:, 1) {isnumeric}
    Z (:, 1)
    fraction (:, 1) = ones(size(Z))
end
if isnumeric(Z)
    fraction = fraction / sum(fraction);
    star = 0;
    for ii = 1 : numel(Z)
        estar = Material.element.(Material.element.symbol(Z(ii))).ESTAR;
        star = star + fraction(ii) .* ...
            interp1(estar(:, 1), estar(:, 2 : 7), T, "spline");
    end
elseif isstruct(Z)
    estar = Z.ESTAR;
    star = interp1(estar(:, 1), estar(:, 2 : 7), T, "spline");
end
if nargout == 1
    Sc = star;
    return
end
Sc = star(:, 1); Sr = star(:, 2); St = star(:, 3); Rc = star(:, 4);
Y = star(:, 5); Erho = star(:, 6);
end
