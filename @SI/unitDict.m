function unit = unitDict()
%{
% AUTHOR: Dait
% UNITDICT:
%     designed for users to conveniently add new units by demension
% NO INPUT.
% OUTPUT:
%     unit: (struct)
%         prefix:
%             symbol: T, G, M, k,  , c, m, u, n, p, ...
%             factor: 1e12, 1e9, ...
%         symbol: s, min, h, d, yr, ...
%         value: 1, 60, 3600, ...
%}
ii = 1;
unitInfo(ii).quantity = "demensionless";
unitInfo(ii).demension = [0 0 0 0];
unitInfo(ii).symbol = ["", "rad", "°", "'", """"];
unitInfo(ii).value = [1, 1, pi / 180, pi / 10800, pi / 648000];
ii = ii + 1;
unitInfo(ii).quantity = "time";
unitInfo(ii).demension = [1 0 0 0];
unitInfo(ii).symbol = ["s", "min", "h", "d", "yr"];
unitInfo(ii).value = [1, 60, 3600, 86400, 31556925.2522];
ii = ii + 1;
unitInfo(ii).quantity = "length";
unitInfo(ii).demension = [0 1 0 0];
unitInfo(ii).symbol = ["m", "au"];
unitInfo(ii).value = [1, 149597870700];
ii = ii + 1;
unitInfo(ii).quantity = "mass";
unitInfo(ii).demension = [0 0 1 0];
unitInfo(ii).symbol = ["g", "u", "eV/c2", "eVpcc"];
unitInfo(ii).value = [1e-3, 1.660539040e-27, SI.e / SI.c^2, SI.e / SI.c^2];
ii = ii + 1;
unitInfo(ii).quantity = "charge";
unitInfo(ii).demension = [0 0 0 1];
unitInfo(ii).symbol = "C";
unitInfo(ii).value = 1;
ii = ii + 1;
unitInfo(ii).quantity = "area";
unitInfo(ii).demension = [0 2 0 0];
unitInfo(ii).symbol = "barn";
unitInfo(ii).value = 1e-28;
ii = ii + 1;
unitInfo(ii).quantity = "pressure";
unitInfo(ii).demension = [-2 -1 1 0];
unitInfo(ii).symbol = ["Pa", "atm", "mmHg"];
unitInfo(ii).value = [1, 1.0133e5, 1.3332e2];
ii = ii + 1;
unitInfo(ii).quantity = "energy, work";
unitInfo(ii).demension = [-2 2 1 0];
unitInfo(ii).symbol = ["J", "eV", "cal"];
unitInfo(ii).value = [1, SI.e, 4.1868];
ii = ii + 1;
unitInfo(ii).quantity = "power";
unitInfo(ii).demension = [-3 2 1 0];
unitInfo(ii).symbol = "W";
unitInfo(ii).value = 1;
ii = ii + 1;
unitInfo(ii).quantity = "activity, frequency";
unitInfo(ii).demension = [-1 0 0 0];
unitInfo(ii).symbol = ["Bq", "Ci", "Hz"];
unitInfo(ii).value = [1, 3.7e10, 1];
ii = ii + 1;
unitInfo(ii).quantity = "kerma, dose";
unitInfo(ii).demension = [-2 2 0 0];
unitInfo(ii).symbol = ["Gy", "Sv"];
unitInfo(ii).value = [1, 1];
ii = ii + 1;
unitInfo(ii).quantity = "exposure";
unitInfo(ii).demension = [0 0 -1 1];
unitInfo(ii).symbol = "R";
unitInfo(ii).value = 2.58e-4;
% ii = ii + 1;
% unit_info(ii).quantity = "";
% unit_info(ii).demension = ;
% unit_info(ii).symbol = ;
% unit_info(ii).value = ;

unit.prefix.symbol = ["T", "G", "M", "k", "", "c", "m", "u", "n", "p", "f"];
unit.prefix.factor = 10.^[12, 9, 6, 3, 1, -2, -3, -6, -9, -12, -15];
unit.symbol = [unitInfo.symbol];
unit.value = [unitInfo.value];
end
