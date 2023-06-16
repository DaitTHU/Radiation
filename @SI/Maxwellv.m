function v = Maxwellv(T, m, type)
%{
% AUTHOR: Dait
% MAXWELLV:
%     Maxwell velocity distribution,
%     velocity
% INPUT:
%     T: temperature (K)
%     m: mass of gas atom (kg)
%     type:
%         'average'
%         'most_probable'
%         'rms'
% OUTPUT:
%     f: PDF
%}
arguments
    T
    m
    type (1, 1) string = 'average'
end
switch type
    case 'average'
        v = sqrt(8 * SI.kB * T ./ (pi * m));
    case 'most_probable'
        v = sqrt(2 * SI.kB * T ./ m);
    case 'rms'
        v = sqrt(3 * SI.kB * T ./ m);
end
end
