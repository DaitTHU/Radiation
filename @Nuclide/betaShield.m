function [t1, t2] = betaShield(obj, A, m1, m2, D, R1, R, m3)
%{
% AUTHOR: wyp, Dait
% BETASHIELD:
%     to calculate the thikness of two kind of materials for beta shield
% INPUT:
%     obj: beta source, Nuclide object
%     A : the activity of the source (Bq)
%     m1: material 1, shield beta- ray
%     m2: material 2, shield bremsstrahlung photon
%         only the material in database is allowed
%     D : Target Dose (Sv/s)
%     R1: the distance between the shield and the source.
%     R : the distance between target and the source
%     m3: material between the shield and the source, default = vacuum
% OUTPUT:
%     t1: thickness of material 1 (cm)
%     t2: thickness of material 2 (cm)
%}
arguments
    obj (1, 1) Nuclide
    A
    m1 (1, 1) struct
    m2 (1, 1) struct
    D (1, 1)
    R1 (1, 1)
    R (1, 1)
    m3 (1, 1) struct = struct('rho', 0);
end
Emax = Nuclide.Qbetam(obj.AX, 'MeV');
betaInfo = [obj.Decay.beta];
Emean = betaInfo.E * SI.unit2v('keV', 'MeV');
[~, ~, ~, t1, ~, ~] = Material.ESTAR(Emax, m1); % beta range
if isfield(m1, 'composition')
    comp = m1.composition;
    for ii = 1 : height(comp)
        atomweight(ii : 1) = comp(ii, 2) ./ comp(ii, 1) * ...
            Material.element.(Material.element.symbol(comp(ii, 1))).ZPA;
    end
    z_eff = sum(atomweight .* comp(:, 1).^2) / sum(atomweight .* comp(:, 1));
else
    z_eff = m1.Z;
end
F = z_eff * Emean * 1e3;
dotPhi = A ./ (4 * pi * R.^2) .* F .* exp(20 * m3.rho ./ Emax^1.54 * R1);
[~, muen] = Material.Xmu(Emax, Material.compound.air);
d0 = dotPhi .* muen .* Emax * SI.unitv("MeV/g.s");
[mu, ~] = Material.Xmu(Emax, m2);
t2 = max(0, log(d0 ./ D) ./ (mu .* m2.rho));


