function f = Maxwellpdf(T, m, v)
%{
% AUTHOR: Dait
% MAXWELLPDF:
%     Maxwell velocity distribution,
%     probability distribution function (PDF)
% INPUT:
%     T: temperature (K)
%     m: mass of gas atom (kg)
%     v: velocity (m/s)
% OUTPUT:
%     f: PDF
%}
kTinv = 1 ./ (2 * SI.kB .* T);
f = 4 * pi * (m ./ pi .* kTinv).^1.5 .* exp(-m .* v.^2 .* kTinv) .* v.^2;
end
