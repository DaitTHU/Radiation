function XMU = getXmu(Z, options)
%{
% AUTHOR: Dait, wyp
% GETXMU:
%     X-Ray Mass Attenuation Coefficients
% INPUT:
%     Z: number of p
%     options:
%         loadPath: path of Xmu.mat
%         saveXmu: whether to save Xmu.mat or not
%         saveXmu: path to save Xmu.mat
% OUTPUT:
%     xmu (M x 3 double) = [E (MeV), mu/rho (cm2/g), mu_en/rho (cm2/g)]
% REF:
%     https://physics.nist.gov/PhysRefData/XrayMassCoef/tab3.html
%}
arguments
    Z (1, 1) {mustBeInteger, mustBePositive}
    options.loadPath (1, 1) string = ""
    options.saveXmu (1, 1) logical = false
    options.savePath (1, 1) string = ""
end
try
    if options.loadPath == ""
        options.loadPath = "@Material\data\Xmu\Xmu" + int2str(Z) + ".mat";
    end
    XMU = importdata(options.loadPath);
    return
catch % .mat not exist
end
%% read web html and get ascii table
opt = weboptions('Timeout', 20);
table = split(string(webread( ...
    "https://physics.nist.gov/PhysRefData/XrayMassCoef/ElemTab/z" + ...
    num2str(Z, '%0.2u') + ".html", opt)), "ASCII format");
tables = splitlines(table(2)); % ascii table, don't use strsplit(..., '\r')
%% cut off the useless rows
beginline = find(contains(tables, "1.00000E-03"), 1); % Z = 14, 2 empty lines
endline = find(contains(tables, "</PRE></TD>"), 1) - 1; % Z = 2, 14 uesless line
tabless = split(tables(beginline : endline) + " "); % Z = 39, ends without " "
%% deal with absorption edge
edge = startsWith(tabless(:, 1), lettersPattern);
XMU = str2double(tabless(:, (1 : 3) + any(edge) + (Z == 1))); % Z = 1, begins with " "
XMU(edge, 1) = XMU(edge, 1) * 1.0001; % absorption edge is the same E as above
% save
if options.saveXmu
    if options.savePath == ""
        options.savePath = "@Material\data\Xmu\Xmu" + int2str(Z);
    end
    save(options.savePath, "XMU")
end
end
