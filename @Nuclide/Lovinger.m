function dotD = Lovinger(obj, A, medium, d, unit)
%{
% AUTHOR: Dait
% LOVINGER:
%     Lovinger empirical formula, 0.167 - 2.24 MeV beta ray
% INPUT:
%     obj: beta source, Nuclide object
%     A: the activity of the source (Bq)
%     medium: the absorbing medium
%         fullname: "air" or "tissue"
%         rho: density
%     d: depth of the absorbing medium (cm)
% OUTPUT:
%     dotD: dose rate (default mGy/h)
%}
arguments
    obj (1, 1) Nuclide
    A
    medium (1, 1) struct
    d (1, 1)
    unit (1, 1) string = "mGy/h"
end
Emax = Nuclide.Qbetam(obj.AX, "MeV");
switch obj.AX
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
betaInfo = [obj.Decay.beta];
Emean = betaInfo.E * SI.unit2v('keV', 'MeV');
K = 4.59e-5 * medium.rho^2 * v^3 .* Emean / ...
    ((3 - exp(1)) * c^2 + exp(1)); % coefficient
vr = v * d * medium.rho; % v * mass depth (g/cm2)
if vr >= c
    dotD = K .* A .* exp(1 - vr) ./ vr;
else
    dotD = K .* A .* (c - vr * exp(1 - vr / c) + vr * exp(1 - vr)) ./ vr.^2;
end
dotD = dotD * SI.unit2v('mGy/h', unit);
end

