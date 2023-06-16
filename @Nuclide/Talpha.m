function T = Talpha(AX, unit)
%{
% AUTHOR: Dait
% kinetic energy T (keV) of alpha partical in alpha decay,
% variables notes see Qalpha
%}
arguments
    AX (:, 1) string
    unit (1, 1) string = "keV"
end
[Z, A, N] = Nuclide.atomicNum(AX);
load @Nuclide\data\nuclide\Qalpha.mat QA
T = diag(QA(N, Z)).* (A - 4) ./ A * SI.unit2v("keV", unit);
end