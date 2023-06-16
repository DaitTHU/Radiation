function AX = AXstr(A, Z)
%{
% AUTHOR: Dait
% A = Z + N
% X is the symbol, e.g. H, He, ...
%}
AX = string(A) + Material.element.symbol(Z);
end