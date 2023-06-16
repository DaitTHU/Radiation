classdef Material
    properties (Constant = true)
        element = importdata("@Material\data\material\element.mat")
        compound = importdata("@Material\data\material\compound.mat")
    end
    methods (Static = true)
        search(query)
        [mu, muen] = Xmu(E, Z, fraction)
        [Sc, Sr, St, Rc, Y, Erho] = ESTAR(T, Z, fraction)
        [Se, Sn, St, Rc, Rp, detour] = PSTAR(T, Z, fraction)
        [Se, Sn, St, Rc, Rp, detour] = ASTAR(T, Z, fraction)
        w = wRn(E)
        fx = Fexpose(E)
        [t1, t2] = betaShield(A, Emax, Emean, m1, m2, D, d, R, m3)
        dotD = Lovinger(A, medium, d, unit)
    end
    methods (Static = true, Access = protected)
        XMU = getXmu(Z, options)
    end
end
