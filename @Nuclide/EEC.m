function ceq = EEC(c_RnDP, A_Rn)
%{
% AUTHOR: Dait
% EEC (Bq/m3):
%     equilibrium equivalent concentration
% variables notes see PAEC
%}
ceq = Nuclide.PAEC(c_RnDP, A_Rn) ./ Nuclide.PAEC(ones(1, 4), A_Rn);
end
