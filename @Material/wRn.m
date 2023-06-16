function w = wRn(E, unitE)
%{
% AUTHOR: wyp, Dait
% WRN:
%     Radiation weight factor for neutrons
% INPUT:
%     E: neutron energy
%     unitE: energy unit, default MeV
% OUTPUT:
%     w: weight factor
%}
arguments
    E (:, 1)
    unitE (1, 1) string = 'MeV'
end
w = zeros(size(E));
E = E * SI.unit2v(unitE, 'MeV');
s = (E <= 1);
w(s) = 2.5 + 18.2 .* exp(-log(E(s)).^2 / 6);
s = (1 < E) & (E < 50);
w(s) = 5.0 + 17.0 .* exp(-log(2 * E(s)).^2 / 6);
s = (E >= 50);
w(s) = 2.5 + 3.2 .* exp(-log(0.04 * E(s)).^2 / 6);


