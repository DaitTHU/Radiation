function Q = Qalpha(AX, unit)
%{
% AUTHOR: Dait
% QALPHA:
%     Energy release in alpha decay
% INPUT:
%     ["222Rn", "218Po"] is okay
%     N, Z is okay
%         if N, Z correspond one to one (vector of the same size), it will 
%         return the same size vector rather than a square matrix.
% OUTPUT:
%     Q (keV)
%}
arguments
    AX (:, 1) string
    unit (1, 1) string = "keV"
end
[Z, ~, N] = Nuclide.atomicNum(AX);
load @Nuclide\data\nuclide\Qalpha.mat QA
Q = diag(QA(N, Z)) * SI.unit2v("keV", unit);
end