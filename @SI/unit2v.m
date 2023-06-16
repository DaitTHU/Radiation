function factor = unit2v(old_expr, new_expr)
%{
% AUTHOR: Dait
% UNIT2V:
%     factor that transform old expression to a new one, regardless demension
%     difference.
%     e.g. ? mJ = 1 MeV, SI.unit2v("MeV", "mJ")
% INPUT:
%     old_expr
%     new_expr
% OUTPUT:
%     factor
%}
factor = SI.unitv(old_expr) ./ SI.unitv(new_expr);
end