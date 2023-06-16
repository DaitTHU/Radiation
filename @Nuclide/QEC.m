function Q = QEC(AX, unit)
%{
% AUTHOR: Dait
% EC (electron capture) Q (keV), variables notes see Qalpha
%}
arguments
    AX (:, 1) string
    unit (1, 1) string = "keV"
end
[Z, ~, N] = Nuclide.atomicNum(AX);
load @Nuclide\data\nuclide\QEC.mat QE
Q = diag(QE(N, Z)) * SI.unit2v("keV", unit);
end