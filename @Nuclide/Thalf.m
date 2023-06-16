function T = Thalf(AX, unit)
%{
% AUTHOR: Dait
% half life time (s), variables notes see Qalpha
%}
arguments
    AX (:, 1) string
    unit (1, 1) string = "s"
end
[Z, ~, N] = Nuclide.atomicNum(AX);
load @Nuclide\data\nuclide\halfLife.mat halfLife
T = diag(halfLife(N, Z)) * SI.unit2v("s", unit);
end
