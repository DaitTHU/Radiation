function Q = Qbetap(AX, unit)
%{
% AUTHOR: Dait
% beta+ Q (keV), variables notes see Qalpha
%}
arguments
    AX (:, 1) string
    unit (1, 1) string = "keV"
end
[Z, ~, N] = Nuclide.atomicNum(AX);
load @Nuclide\data\nuclide\Qbetap.mat QBP
Q = diag(QBP(N, Z)) * SI.unit2v("keV", unit);
end