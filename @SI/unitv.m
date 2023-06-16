function value = unitv(expr)
%{
% AUTHOR: Dait
% UNITV:
%     factor of unit in SI,
%     e.g. SI.unitv("MeV") = 1.602e-13
% INPUT:
%     expr: expression of unit, use . to connect, / no more than once
%     e.g. "MeV2.m/g"
% OUTPUT:
%     value: factor in SI
%}
arguments
    expr (1, 1) string
end
%% split units
[units, sep] = split(replace(expr, "eV/c2", "eVpcc"), ["/", "."]);
explicit_e = endsWith(units, digitsPattern);
expos = ones(size(units));
[u, e] = split(units(explicit_e), digitsPattern);
if ~isempty(u)
    u = reshape(u, [], 2);
    units(explicit_e) = u(:, 1);
    expos(explicit_e) = str2double(e);
end
deno = 1 + find(sep == "/");
expos(deno : end) = -expos(deno : end);
%% select units with prefix and without prefix
% without prefix
[x, ~] = find((units == SI.unit.symbol)');
prefixed = ~any(units == SI.unit.symbol, 2);
unit_value = zeros(size(units));
unit_value(~prefixed) = SI.unit.value(x);
% with prefix
prefix_units = units(prefixed);
if ~isempty(prefix_units)
    prefixs = extract(prefix_units, 1);
    deprefix_units = extractAfter(prefix_units, 1);
    [xp, ~] = find((prefixs == SI.unit.prefix.symbol)');
    [xq, ~] = find((deprefix_units == SI.unit.symbol)');
    unit_value(prefixed) = SI.unit.prefix.factor(xp) .* SI.unit.value(xq);
end
value = prod(unit_value.^expos);
end

