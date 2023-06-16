function fx = Fexpose(E, unitE)
%{
% AUTHOR: wyp, Dait
% FEXPOSE:
%     the Exposure Factor for X-ray
% INPUT:
%     E : X-ray Energy
%     unitE: unit of E, default MeV
% OUTPUT:
%     fx: Exposure Factor in air, C.cm^2/g
%}
arguments
    E (:, 1)
    unitE (1, 1) string = 'MeV'
end
[~, muen] = Material.Xmu(E, Material.compound.air);
fx = E * SI.unitv(unitE) .* muen / 33.85; % W.air = 33.85 eV
