function dotD = Lovinger(A, Emax, Emean, medium, d, options)
%{
% AUTHOR: Dait
% LOVINGER:
%     Lovinger empirical formula, 0.167 - 2.24 MeV beta ray
% INPUT:
%     A: the activity of the source (Bq)
%     Emax : max beta energy (MeV)
%     Emean: mean Beta Energy (MeV)
%     d: depth of the absorbing medium (cm)
%     medium: the absorbing medium
%         fullname: "air" or "tissue"
%         rho: density
% OUTPUT:
%     dotD: dose rate (default mGy/h)
%}
arguments
    A
    Emax
    Emean
    medium (1, 1) struct
    d (1, 1)
    options.unit (1, 1) string = "mGy/h"
    options.nuclide (1, 1) string = "default"
end
switch options.nuclide
    case "90Sr"
        Erate = 1.17; % E/E*
    case "210Bi"
        Erate = 0.77;
    otherwise
        Erate = 1;
end
if contains(lower(medium.fullname), "air")
    c = 3.11 * exp(-0.56 * Emax);
    v = 16 ./ (Emax - 0.036).^1.4 .* (2 - Erate);
elseif contains(lower(medium.fullname), "tissue")
    c = NaN(size(Emax));
    c(0.17 < Emax & Emax <= 0.5) = 2;
    c(0.5 < Emax & Emax <= 1.5) = 1.5;
    c(1.5 < Emax & Emax < 3) = 1;
    v = 18.6 ./ (Emax - 0.0036).^1.37 .* (2 - Erate);
end
K = 4.59e-5 * medium.rho^2 * v^3 .* Emean / ...
    ((3 - exp(1)) * c^2 + exp(1)); % coefficient

vr = v * d * medium.rho; % v * mass depth (g/cm2)
if vr >= c
    dotD = K .* A .* exp(1 - vr) ./ vr;
else
    dotD = K .* A .* (c - vr * exp(1 - vr / c) + vr * exp(1 - vr)) ./ vr.^2;
end
end

