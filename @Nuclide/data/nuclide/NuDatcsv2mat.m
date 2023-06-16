clear
% AUTHOR: Dait, wyp

%% half-life
HLdata = readmatrix("halfLife.csv"); % s
halfLife = NaN(max(HLdata(:, 1 : 2)));
% neutron half-life
halfLife_n = HLdata(1, 3);
for ii = 2 : height(HLdata)
    if isnan(HLdata(ii, 3)) % i.e. STABLE
        halfLife(HLdata(ii, 1), HLdata(ii, 2)) = Inf;
    else
        halfLife(HLdata(ii, 1), HLdata(ii, 2)) = HLdata(ii, 3);
    end
end
save halfLife.mat halfLife % halfLife_n

%% BE/A: Binding Energy per nucleon
SBEdata = readmatrix("SBE.csv"); % keV
% maxA x maxZ NaN matrix
BEPA = NaN(max(SBEdata(:, 1 : 2)));
for ii = 2 : height(SBEdata)
    BEPA(SBEdata(ii, 1), SBEdata(ii, 2)) = SBEdata(ii, 3);
end
save SBE.mat BEPA

%% Q_alpha
QAdata = readmatrix("Qalpha.csv"); % keV
QA = NaN(max(QAdata(:, 1 : 2)));
for ii = 1 : height(QAdata)
    QA(QAdata(ii, 1), QAdata(ii, 2)) = QAdata(ii, 3);
end
save Qalpha.mat QA

%% Q_beta-
QBMdata = readmatrix("Qbetam.csv"); % keV
QBM = NaN(max(QBMdata(:, 1 : 2)));
% neutron beta decay
Qbetam_n = QBMdata(1, 3);
for ii = 2 : height(QBMdata)
    QBM(QBMdata(ii, 1), QBMdata(ii, 2)) = QBMdata(ii, 3);
end
save Qbetam.mat QBM

%% Q_beta+
QBPdata = readmatrix("Qbetap.csv"); % keV
QBP = NaN(max(QBPdata(:, 1 : 2)));
for ii = 1 : height(QBPdata)
    QBP(QBPdata(ii, 1), QBPdata(ii, 2)) = QBPdata(ii, 3);
end
save Qbetap.mat QBP

%% Q_EC
QECdata = readmatrix("QEC.csv"); % keV
QE = NaN(max(QECdata(:, 1 : 2)));
for ii = 1 : height(QECdata)
    QE(QECdata(ii, 1), QECdata(ii, 2)) = QECdata(ii, 3);
end
save QEC.mat QE



