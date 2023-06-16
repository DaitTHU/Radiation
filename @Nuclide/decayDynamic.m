function [t, n, AXs] = decayDynamic(obj, tspan, n0, options)
%{
% AUTHOR: Dait
% DECAYDYNAMIC:
%     decay dynamic, n-t relation
% INPUT:
%     obj: Nuclide (e.g. "222Rn")
%     tspan, n0, see ode15s
%     options:
%         plotN: whether to plot n-t or not
%         plotChain: whether plot decay chain or not
%         Tstable, Imin: see decayChain
% OUTPUT:
%     t (s): time
%     n: number of decay nuclei
%}
arguments
    obj (1, 1) Nuclide
    tspan = []
    n0 = []
    options.plotN (1, 1) logical = false
    options.plotChain (1, 1) logical = false
    options.Tstable (1, 1) = inf
    options.Imin (1, 1) = 0
end
% get decay chain
[I, T, AXs] = obj.decayChain(plotChain=options.plotChain, ...
    Tstable=options.Tstable, Imin=options.Imin);
if options.plotN && options.plotChain 
    figure()
end
% dNdt = AN, get A
lambda = log(2) ./ T;
lambda(isinf(lambda)) = 0; % T_ij = 0, lambda_ij = 0
A = (lambda .* I)';
A = A - diag(sum(A));
% default tspan: [0 1e3 * min(T)]
if isempty(tspan)
    tspan = [0 10 * min(T(T > 0))];
end
% n0
if isempty(n0)
    n0 = zeros(size(AXs));
    n0(1) = 1; % only parent nucleus exists
end
[t, n] = ode15s(@(t, n) A * n, tspan, n0);
if ~options.plotN
    return
end
semilogy(t, n, 'LineWidth', 1)
title(obj.AX + " decay dynamic")
xlabel('t (s)')
ylabel('n')
grid on
legend(AXs, "Location", "best")
end
