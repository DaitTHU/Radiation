function m = mass(AX, unit)
%{
% AUTHOR: wyp, Dait
% Nuclide mass (u), variables notes see Qalpha
%}
arguments
    AX (:, 1) string
    unit (1, 1) string = "u"
end
[Z, A, N] = Nuclide.atomicNum(AX);
load @Nuclide\data\nuclide\SBE.mat BEPA
try
    BE = A .* diag(BEPA(N, Z)) * SI.unit2v("keV/c2", unit);
catch
    BE = 0;
end
m = (N * SI.mn + Z * (SI.mp + SI.me)) * SI.unit2v("kg", unit) - BE;

