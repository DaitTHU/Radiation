function cp = PAEC(c_RnDP, A_Rn)
%{
% AUTHOR: Dait
% PAEC (J/m3):
%     potential alpha energy concentration
% INPUT:
%     c_RnDP (Bq/m3): activity concentration of 4 RnDPs
%     A_Rn: A of Rn, 222, 220 or 219
% OUTPUT:
%     cp: PAEC (J/m3)
%}
arguments
    c_RnDP (:, 4)
    A_Rn (1, 1)
end
ep_ln2 = Nuclide.PAE(c_RnDP, A_Rn) / log(2);
switch A_Rn
    case 222
        cp = ep_ln2 .* Nuclide.Thalf(["218Po", "214Pb", "214Bi", "214Po"]);
    case 220
        cp = ep_ln2 .* Nuclide.Thalf(["216Po", "212Pb", "212Bi", "212Po"]);
    case 219
        cp = ep_ln2 .* Nuclide.Thalf(["215Po", "211Pb", "211Bi", "207Tl"]);
end
end