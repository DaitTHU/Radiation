function [hv_, E, psi] = Compton(hv, theta, m, options)
%{
% AUTHOR: wyp, Dait
% COMPTON:
%     Compton scattering
% INPUT:
%     hv: photon energy
%     theta: scattering angle in C.M.
%     m: mass of particle (default electron)
OUTPUT:
    hv_: scattering photon energy, MeV
    E: particle energy, MeV
    psi: recoil angle
%}
arguments
    hv (:, 1)
    theta (:, 1)
    m (:, 1) = SI.me / SI.unitv('MeV/c2')
    options.unitT (1, 1) string = 'MeV'
    options.unittheta (1, 1) string = '°'
    options.unitm (1, 1) string = 'MeV/c2'
end
hv = hv * SI.unit2v(options.unitT, 'MeV');
m = m * SI.unit2v(options.unitm, 'MeV/c2');
if options.unittheta == "rad"
    psi = acot((1 + hv ./ m) .* tan(theta / 2));
else
    theta = theta * SI.unit2v(options.unittheta, 'rad');
    psi = acotd((1 + hv ./ m) .* tan(theta / 2));
end
hv_ = hv ./ (1 + hv ./ m .* (1 - cos(theta)));
E = hv - hv_;
end
