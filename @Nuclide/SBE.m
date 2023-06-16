function E = SBE(AX, unit)
%{
% AUTHOR: Dait
% specific bonding energy (keV), variables notes see Qalpha
%}
arguments
    AX (:, 1) string
    unit (1, 1) string = "keV"
end
[Z, ~, N] = Nuclide.atomicNum(AX);
load @Nuclide\data\nuclide\SBE.mat BEPA
E = diag(BEPA(N, Z)) * SI.unit2v("keV", unit);
end