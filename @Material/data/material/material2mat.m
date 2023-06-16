clear
% AUTHOR: wyp, Dait

name = string(readcell('material.xlsx', 'Range', 'A1:A279'));
fullname = string(readcell('material.xlsx', 'Range', 'B1:B279'));

element.symbol = [
    "H", "He", ...
    "Li", "Be", "B", "C", "N", "O", "F", "Ne", ...
    "Na", "Mg", "Al", "Si", "P", "S", "Cl", "Ar", ...
    "K", "Ca", "Sc", "Ti", "V", "Cr", "Mn", "Fe", "Co", "Ni", "Cu", "Zn", "Ga", "Ge", "As", "Se", "Br", "Kr", ...
    "Rb", "Sr", "Y", "Zr", "Nb", "Mo", "Tc", "Ru", "Rh", "Pd", "Ag", "Cd", "In", "Sn", "Sb", "Te", "I", "Xe", ...
    "Cs", "Ba", "La", "Ce", "Pr", "Nd", "Pm", "Sm", "Eu", "Gd", "Tb", "Dy", "Ho", "Er", "Tm", "Yb", "Lu", "Hf", "Ta", "W", "Re", "Os", "Ir", "Pt", "Au", "Hg", "Tl", "Pb", "Bi", "Po", "At", "Rn", ...
    "Fr", "Ra", "Ac", "Th", "Pa", "U", "Np", "Pu", "Am", "Cm", "Bk", "Cf", "Es", "Fm", "Md", "No", "Lr", "Rf", "Db", "Sg", "Bh", "Hs", "Mt", "Ds", "Rg", "Cn", "Nh", "Fl", "Mc", "Lv", "Ts", "Og"
    ]';

%% fullname, Z, I, rho
bar = waitbar(0);
for ii = 1 : 98
    urldata = string(webread( ...
        "https://physics.nist.gov/cgi-bin/Star/compos.pl?mode=text&matno=" + num2str(ii, '%0.3u')));
    urldatas = splitlines(extractBetween(urldata, '<pre>', '</pre>'));
    element.(name(ii)) = struct( ...
        'fullname', fullname(ii), ...
        'Z', ii, ...
        'I', str2double(extractAfter(urldatas(5), regexpPattern('= '))), ...
        'rho', str2double(extractAfter(urldatas(4), regexpPattern('= '))));
    waitbar(ii / 98)
end
element.graphite = struct('fullname', 'Graphite', 'Z', 6, 'I', 78, 'rho', 1.7);

for ii = 99 : 278
    urldata = string(webread( ...
        "https://physics.nist.gov/cgi-bin/Star/compos.pl?mode=text&matno=" + num2str(ii, '%0.3u')));
    urldatas = splitlines(extractBetween(urldata, '<pre>', '</pre>'));
    compound.(name(ii)) = struct( ...
        'fullname', fullname(ii), ...
        'I', str2double(extractAfter(urldatas(5), regexpPattern('= '))), ...
        'rho', str2double(extractAfter(urldatas(4), regexpPattern('= '))), ...
        'composition', str2double(extract(string(urldatas(13 : end - 1)), ...
        regexpPattern('[0-9\.]+'))));
    waitbar((ii - 98) / (278 - 98))
end
close(bar)

%% Xmu
csvdata = string(readcell('element.csv'));
for ii = 2 : height(csvdata)
    load("..\Xmu\Xmu" + csvdata(ii, 1))
    element.(csvdata(ii, 2)).ZPA = str2double(csvdata(ii, 4));
    element.(csvdata(ii, 2)).Xmu = Xmu;
end
element.graphite.Xmu = element.C.Xmu;
% element.C.Xmu(:, 2 : 3) = element.C.Xmu(:, 2 : 3);

xlsxdata = string(readcell('compound_mixture.xlsx'));
for ii = 2 : height(xlsxdata)
    if ~isfield(compound, xlsxdata(ii, 1))
        compound.(xlsxdata(ii, 1)) = struct( ...
            'fullname', xlsxdata(ii, 2), ...
            'I', xlsxdata(ii, 4), ...
            'rho', xlsxdata(ii, 5), ...
            'composition', str2double(split(split(erase(replace( ...
            xlsxdata(ii, 6), ': ', ':'), regexpPattern('^ *'))), ':')));
    end
    compound.(xlsxdata(ii, 1)).ZPA = str2double(xlsxdata(ii, 3));
end

%% estar
name = string(readcell('material.xlsx', 'Range', 'C1:C279'));

for ii = 1 : 99
    stardata = fileread(['..\STAR\estar_data\', int2str(ii), '.txt']);
    stardata_ = split(string(extractBefore(stardata, '<hr>')));
    element.(string(name(ii))).ESTAR = str2double( ...
        reshape(stardata_(2 : end - 1), 7, [])');
end

for ii = 100 : 279
    stardata = fileread(['..\STAR\estar_data\', int2str(ii), '.txt']);
    stardata_ = split(string(extractBefore(stardata, '<hr>')));
    compound.(string(name(ii))).ESTAR = str2double( ...
        reshape(stardata_(2 : end - 1), 7, [])');
end

%% pstar
name = string(readcell('material.xlsx', 'Range', 'E1:E75'));
for ii = [1 : 8, 10 : 27]
    stardata = fileread(['..\STAR\pstar_data\', int2str(ii), '.txt']);
    stardata_ = split(string(extractBefore(stardata, '<hr>')));
    element.(string(name(ii))).PSTAR = str2double( ...
        reshape(stardata_(2 : end - 1), 7, [])');
end

for ii = 28 : 75
    stardata = fileread(['..\STAR\pstar_data\', int2str(ii), '.txt']);
    stardata_ = split(string(extractBefore(stardata, '<hr>')));
    compound.(string(name(ii))).PSTAR = str2double( ...
        reshape(stardata_(2 : end - 1), 7, [])');
end

%% astar
name = string(readcell('material.xlsx', 'Range', 'G1:G74'));
for ii = 1 : 26
    stardata = fileread(['..\STAR\astar_data\', int2str(ii), '.txt']);
    stardata_ = split(string(extractBefore(stardata, '<hr>')));
    element.(name(ii)).ASTAR = str2double( ...
        reshape(stardata_(2 : end - 1), 7, [])');
end

for ii = 27 : 74
    stardata = fileread(['..\STAR\astar_data\', int2str(ii), '.txt']);
    stardata_ = split(string(extractBefore(stardata, '<hr>')));
    compound.(name(ii)).ASTAR = str2double( ...
        reshape(stardata_(2 : end - 1), 7, [])');
end

element.name = 'element';
compound.name = 'compound';

save element element
save compound compound

