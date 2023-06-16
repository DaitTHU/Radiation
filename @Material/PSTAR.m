function [Se, Sn, St, Rc, Rp, detour] = PSTAR(T, Z, fraction)
%{
% AUTHOR: wyp, Dait
% PSTAR:
%  stopping power and range of proton
% INPUT:
%         T = proton kinetic energy, MeV
%         Z = Z, or struct have Z/composition field
%  fraction = mass fraction of each Z
% OUTPUT:
%   STOP(e) = electronic stopping power, MeV cm2/g
%   STOP(n) = nuclear stopping power, MeV cm2/g
%   STOP(t) = total stopping power, MeV cm2/g
%  RANGE(c) = csda range, g/cm2 (computational statistics and data anaylsis)
%  RANGE(p) = projected range, g/cm2
%    DETOUR = detour factor, projected/csda
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
        pstar = Material.element.(Material.element.symbol(Z(ii))).PSTAR;
        star = star + fraction(ii) .* ...
            interp1(pstar(:, 1), pstar(:, 2 : 7), T, "spline");
    end
elseif isstruct(Z)
    pstar = Z.PSTAR;
    star = interp1(pstar(:, 1), pstar(:, 2 : 7), T, "spline");
end
if nargout == 1
    Se = star;
    return
end
Se = star(:, 1); Sn = star(:, 2); St = star(:, 3); Rc = star(:, 4);
Rp = star(:, 5); detour = star(:, 6);
end
