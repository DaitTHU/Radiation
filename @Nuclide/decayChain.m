function [I, T, AXs, nuclei] = decayChain(obj, options)
%{
% AUTHOR: Dait
% DECAYCHAIN:
%     get decay chain of a Nuclide
%     235U → 231Th → 227Pa → 223Ra → 219Rn → 215Po → 211Bi → 211Po → 207Tl → 207Pb
% INPUT:
%     obj: Nuclide (e.g. "222Rn")
%     options:
%         plotChain: whether plot decay chain or not
%         Tstable: nucleus commit stable if Thalf > Tstable
%         Imin: decay ignored if I < Imin
%         max_nucleus: max number of nuclei in the chain
% OUTPUT:
%     I: intensity matrix
%     T: half life matrix
%     AXs: AX list of nuclei in the chain
%     nuclei: nuclide list of nuclei in the chain
%}
arguments
    obj (1, 1) Nuclide
    options.plotChain (1, 1) logical = true
    options.Tstable (1, 1) = inf
    options.Imin (1, 1) = 0
    options.max_nucleus (1, 1) {mustBeInteger, ...
        mustBeGreaterThan(options.max_nucleus, 27)} = 30
end
% reserved size
IT = zeros(options.max_nucleus, options.max_nucleus, 3);
%% search decay chain
parent_nuclei = obj;
AXs = parent_nuclei.AX;
nuclei = parent_nuclei;
while ~isempty(parent_nuclei)
    daughter_nuclei = [];
    % beginning index of parent and daughter
    grandparent = numel(AXs) - numel(parent_nuclei);
    eldersister = numel(AXs);
    for ii = 1 : numel(parent_nuclei)
        for jj = 1 : numel(parent_nuclei(ii).Decay)
            if parent_nuclei(ii).Decay(jj).Thalf > options.Tstable
                eldersister = eldersister - 1;
                continue
            end
            Int = parent_nuclei(ii).Decay(jj).Intensity;
            if isempty(Int)
                Int = 1;
            elseif Int < options.Imin
                eldersister = eldersister - 1;
                continue
            end
            daughter_nucleus = Nuclide(parent_nuclei(ii).Decay(jj).daughter);
            daughter = find(AXs == daughter_nucleus.AX);
            if isempty(daughter)
                daughter_nuclei = [daughter_nuclei; daughter_nucleus];
                AXs = [AXs; daughter_nucleus.AX];
                daughter = eldersister + jj;
            else % decay diamond
                eldersister = eldersister - 1;
            end
            IT(grandparent + ii, daughter, :) = [Int, ...
                parent_nuclei(ii).Decay(jj).Thalf, ...
                parent_nuclei(ii).Decay(jj).mode == "IT"];
        end
        if jj > 0 % if parent nucleus is stable, for jj = 1 : 0; jj = []
            eldersister = eldersister + jj;
        end
    end
    nuclei = [nuclei; daughter_nuclei];
    parent_nuclei = daughter_nuclei;
end

IT = IT(1 : numel(AXs), 1 : numel(AXs), :);
I = IT(:, :, 1); T = IT(:, :, 2); IT = IT(:, : ,3);

%% plot
if ~options.plotChain
    return
end
digT = digraph(T);
% X = Z, Y = N
plt = plot(digT, "s", "MarkerSize", 8);
title(obj.AX + " decay chain")
plt.XData = arrayfun(@(obj) obj.Z, nuclei);
plt.YData = arrayfun(@(obj) obj.N, nuclei);
plt.NodeLabel = AXs;
axis equal
xrange = [min(plt.XData) - 1, max(plt.XData) + 1];
xlim(xrange)
xticks(xrange(1) : xrange(2))
xlabel("Z")
yrange = [min(plt.YData) - 1, max(plt.YData) + 1];
ylim(yrange)
yticks(yrange(1) : yrange(2))
ylabel("N")
grid on

%% color, width
% repeated_colororder = repmat(get(gca, 'colororder'), ...
%     [1 + rem(numel(AXs), 7) 1]);
% plt.NodeColor = repeated_colororder(1 : numel(AXs), :);
% digIT = digraph(IT(:, :, 3)); % IT info

% no-next-decay node be black
plt.NodeColor = repmat(plt.NodeColor, [numel(AXs), 1]);
plt.NodeColor(outdegree(digT) == outdegree(digraph(IT)), :) = 0;
% plt.NodeColor(end, :) = 0;

% edge width = I
edgI = digraph(I).Edges.Weight;
if isempty(edgI)
    return
end
plt.LineWidth = 3 * max(edgI, 0.05);
plt.ArrowSize = 10;
plt.ArrowPosition = 0.6;
plt.EdgeAlpha = 1;
% egdg label
lblI = string(edgI * 100) + "%";
lblI((0.99 < edgI & edgI <= 1.001) | ... IT no need to show Intensity
    digraph(I + IT).Edges.Weight > edgI) = "";
labeledge(plt, 1 : numedges(digT), lblI)
% edge color = T
plt.EdgeCData = digT.Edges.Weight;
cb = colorbar;
cb.Label.String = 'T_{1/2}(s)';
ax = gca;
ax.ColorScale = 'log';
[minT, maxT] = bounds(digT.Edges.Weight);
ax.CLim = [minT, maxT];
end
