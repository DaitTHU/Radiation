function P = PAEE(t, c_RnDP, A_Rn)
%{
% AUTHOR: Dait
% PAEE (Js/m3):
%     potential alpha energy exposure
% INPUT:
%     c_RnDP (Bq/m3): activity concentration of 4 RnDPs
%     A_Rn: A of Rn, 222, 220 or 219
% OUTPUT:
%     P: PAEE (Js/m3)
%}
P = trapz(t, Nuclide.PAEC(c_RnDP, A_Rn));
end