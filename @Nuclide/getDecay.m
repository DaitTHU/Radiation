function Decay = getDecay(obj, options)
%{
% AUTHOR: Dait
% GETDECAY:
%     decay info
% INPUT:
%     obj: Nuclide (e.g. "222Rn")
%     options:
%         loadDpath: path of decay.mat
%         readHTML: whether to read HTML.mat (or url) or not
%         loadHpath: path of HTML.mat
%         saveDecay: whether to save decay.mat or not
%         saveDpath: path to save decay.mat
%         saveHTML: whether to save HTML.mat or not
%         saveHpath: path to save HTML.mat
% OUTPUT:
%     Decay:
%         Elevel (keV)
%         Jpi
%         Thalf (s)
%         mode: alpha, beta-, beta+, epsilon (EC), IT, beta-n, beat+p, epsilonp
%         Intensity: 0 - 1 (100%)
%         GSGSQ (keV)
%         daughter: "AX" (string)
%         beta:
%             E (keV): mean beta- energy
%             I: total beta- intensity
%             D (MeV/Bqs): mean beta- dose
%         gamma (M x 3 double):
%             E (keV): gamma energy
%             I : intensity
%             D (MeV/Bqs): dose
% REF:
%     https://www.nndc.bnl.gov/nudat3/DecayRadiationServlet?nuc=148Pr&unc=NDS
%}
arguments
    obj (1, 1) Nuclide
    options.loadDpath (1, 1) string = ""
    options.readHTML (1, 1) logical = false
    options.loadHpath (1, 1) string = ""
    options.saveDecay (1, 1) logical = false
    options.saveDpath (1, 1) string = ""
    options.saveHTML (1, 1) logical = false
    options.saveHpath (1, 1) string = ""
end
try % .mat exists, read .mat
    if options.loadDpath == ""
        options.loadDpath = "@Nuclide\data\decay\decay" + obj.AX + ".mat";
    end
    Decay = importdata(options.loadDpath);
    return
catch % .mat not exist, deal with HTML
    if ~options.readHTML
        return
    end
    try
        if options.loadHpath == ""
            options.loadHpath = "@Nuclide\data\decayHTML\decayTHML" + obj.AX + ".mat";
        end
        HTMLdata = importdata(options.loadHpath);
    catch % .mat not exist, read HTML
        webopt = weboptions('Timeout', 20);
        HTMLdata = string(webread( ...
            "https://www.nndc.bnl.gov/nudat3/DecayRadiationServlet?nuc=" + ...
            obj.AX + "&unc=NDS", webopt));
        if options.saveHTML
            if options.saveHpath == ""
                options.saveHpath = "@Nuclide\data\decayHTML\decayTHML" + obj.AX;
            end
            save(options.saveHpath, "HTMLdata")
        end
    end
end
% no decay info
if contains(HTMLdata, [...
        "No datasets were found within the specified search parameters", ...
        "No datasets were found since nucleus is stable"])
    Decay = struct([]);
    return
end
Thalf_unit = struct( ...
    'symbol', ["ns", "us", "ms", "s", "m", "h", "d", "y"], ...
    'value', [1e-9, 1e-6, 1e-3, 1, 60, 3600, 86400, 31556925.2522]);
%% decay data: E_level (keV), Jpi, half-life (s), mode & intensity, GS-GS Q (keV)
% tables: N x 1 string
tables = split(HTMLdata, '<table');
% decay_tables: n x 1 string
decay_index = 2 + find(contains(tables, 'Dataset'));
% decay_tabless: n x M string
decay_tables = reshape(split(erase(tables(decay_index), '<br>'), 'd><td'), ...
    numel(decay_index), []);

Decay = struct;
for ii = 1 : numel(decay_index)
    % decay E_level
    Decay(ii).Elevel = str2double(extract(extract( ...
        decay_tables(ii, 3), regexpPattern('&nbsp;[^\n\r]+<i>')), ...
        regexpPattern('[0-9.E\+\-]+')));

    % decay J^pi
    Decay(ii).Jpi = erase(extract( ...
        decay_tables(ii, 4), regexpPattern('&nbsp;[^\n\r]+&nbsp;')), ...
        ["(", ")", "&nbsp;"]);

    % decay half life
    dThalf = extract(replace(replace(erase(erase(extract( ...
        decay_tables(ii, 5), regexpPattern('&nbsp;[^\n\r]*&nbsp;')), ...
        regexpPattern('<i>[^\n\r]*</i>')), ...
        regexpPattern('</?sup>')), "&times;10", "E"), "&micro;", "u"), ...
        regexpPattern('[0-9\+\-E\.]+ [a-z]+'));
    Decay(ii).Thalf = str2double(extract(dThalf, regexpPattern('[0-9\+\-E\.]+'))) .* ...
        Thalf_unit.value(Thalf_unit.symbol == extract(dThalf, regexpPattern('[a-z]+')));

    % decay mode & intensity
    dmode = erase(extract( ...
        decay_tables(ii, 6), regexpPattern('&nbsp;.+&nbsp;')), ...
        ["&nbsp;", regexpPattern('<i>.*?</i>'), ...
        regexpPattern('</?sup>'), regexpPattern('[&;:% ]')]);
    Decay(ii).mode = extract(dmode, regexpPattern('[a-zA-Z]{2,}[\-\+]?[a-z]*'));
    try
        Decay(ii).Intensity = str2double(extract(dmode, regexpPattern('[0-9.]+[E\+\-]*[0-9]*'))) / 100;
    catch
        Decay(ii).Intensity = NaN;
    end

    % dacay GS-GS Q
    Decay(ii).GSGSQ = str2double(erase(extract(erase(extract( ...
        decay_tables(ii, 7), regexpPattern('&nbsp[^ <]+<i>')), ...
        '&nbsp;'), regexpPattern('.+')), '<i>'));

    % decay daughter nucleus
    switch Decay(ii).mode
        case "beta-" % (705)
            Decay(ii).daughter = Nuclide.AXstr(obj.A, obj.Z + 1);
        case {"epsilon", "beta+"} % (692, 48)
            Decay(ii).daughter = Nuclide.AXstr(obj.A, obj.Z - 1);
        case "alpha" % (597)
            Decay(ii).daughter = Nuclide.AXstr(obj.A - 4, obj.Z - 2);
        case "IT" % isometric transition, (354)
            Decay(ii).daughter = obj.AX;
        case "beta-n" % (5)
            Decay(ii).daughter = Nuclide.AXstr(obj.A - 1, obj.Z + 1);
        case {"beta+p", "epsilonp"} % (1, 1)
            Decay(ii).daughter = Nuclide.AXstr(obj.A - 1, obj.Z - 2);
        otherwise
            Decay(ii).daughter = "";
    end
end

%% beta: energy (keV), intensity , dose (MeV/Bqs)
beta_index = find(contains(tables, 'Mean') & contains(tables, 'dose'));
if beta_index > 0
    beta_tables = reshape(split(tables(beta_index), '</table>'), ...
        numel(beta_index), []);
    beta_tabless = reshape(split(beta_tables(:, 2), '<i>'), ...
        numel(beta_index), []);
end
Beta = struct;
for ii = 1 : numel(beta_index)
    Beta.E = str2double(extractBetween( ...
        beta_tabless(ii, 1), 'energy:', 'keV'));
    Beta.I = str2double(extractBetween( ...
        beta_tabless(ii, 2), 'intensity:', '%')) / 100;
    Beta.D = str2double(extractBetween( ...
        beta_tabless(ii, 3), 'dose:', 'MeV/Bq-s'));
    Decay(find(decay_index < beta_index(ii), 1, "last")).beta = Beta;
end

%% gamma
gamma_index = 1 + find(contains(tables, 'Gamma and X-ray radiation'));
gamma_tables = tables(gamma_index);
for ii = 1 : numel(gamma_index)
    EID = zeros(1, 3); jj = 1;
    for gamma_table = split(gamma_tables(ii), '<tr><td')'
        gamma_intensity = str2double(erase(extract(gamma_table, regexpPattern('[0-9\.]+ %')), ' %'));
        if gamma_intensity > 0
            gamma_line = split(gamma_table, '</td><td');
            EID(jj, 1) = str2double(erase(extract( ...
                gamma_line(2), regexpPattern('&nbsp;[&lteasymp;]*[0-9\.E\+\-]+')), ...
                ["&nbsp;", "&lt;", "&le;", "&asymp;"]));
            EID(jj, 2) = gamma_intensity / 100;
            try
                EID(jj, 3) = str2double(erase(extract( ...
                    gamma_line(4), regexpPattern('&nbsp;[0-9\.E\+\-]+')), '&nbsp;'));
            catch
                EID(jj, 3) = NaN;
            end
            jj = jj + 1;
        end
    end
    Decay(find(decay_index < gamma_index(ii), 1, "last")).gamma = EID;
end
if options.saveDecay
    if options.saveDpath == ""
        options.saveDpath = "@Nuclide\data\decay\decay" + obj.AX;
    end
    save(options.saveDpath, "Decay")
end
end
