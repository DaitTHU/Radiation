function ep = PAE(N_RnDP, A_Rn)
%{
% AUTHOR: Dait
% PAE (J):
%     potential alpha energy
% INPUT:
%     N_RnDP: nuclei number N of 4 RnDPs
%     A_Rn: A of Rn, 222, 220 or 219
% OUTPUT:
%     ep: PAE (J)
%}
arguments
    N_RnDP (:, 4)
    A_Rn (1, 1) = 222
end
switch A_Rn
    case 222 % 218Po (6), 214Pb, 214Bi, 214Po (7.687)
        ep = N_RnDP * ([Nuclide.Talpha("218Po"); 0; 0; 0] + Nuclide.Talpha("214Po"));
    case 220 % 216Po (6.7785), 212Pb, 212Bi (36%, 6.09), 212Po (64%, 8.785)
        ep = N_RnDP * [[Nuclide.Talpha("216Po"); 0; 0] + ...
            0.36 * Nuclide.Talpha("212Bi") + 0.64 * Nuclide.Talpha("212Po"); ...
            Nuclide.Talpha("212Po")];
    case 219 % 215Po (7.3863), 211Pb, 211Bi (6.6224), 207Tl
        ep = N_RnDP * [[Nuclide.Talpha("215Po"); 0; 0] + Nuclide.Talpha("211Bi"); 0];
    otherwise
        ep = NaN(height(N_RnDP), 1);
end
ep = ep * SI.unitv("keV");
end
