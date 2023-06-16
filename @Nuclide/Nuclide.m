classdef Nuclide
    % designed by Dait
    properties
        Z, A, N, AX
        Decay
    end
    methods
        function obj = Nuclide(AX)
            % constructor
            arguments
                AX (1, 1) string
            end
            [obj.Z, obj.A, obj.N] = Nuclide.atomicNum(AX);
            obj.AX = string(obj.A) + Material.element.symbol(obj.Z);
            obj.Decay = obj.getDecay();
        end
        Decay = getDecay(obj, options)
        [I, T, AXs, nuclei] = decayChain(obj, options)
        [t, n, AXs] = decayDynamic(obj, tspan, n0, options)
        [t1, t2] = betaShield(obj, A, m1, m2, D, d, R, m3)
        dotD = Lovinger(obj, A, medium, d, unit)
    end
    methods (Static = true)
        [Z, A, N, X] = atomicNum(AX)
        % nuclide data
        T = Thalf(AX, unit)
        Q = Qalpha(AX, unit)
        Q = Talpha(AX, unit)
        Q = Qbetam(AX, unit)
        Q = Qbetap(AX, unit)
        Q = QEC(AX, unit)
        E = SBE(AX, unit)
        m = mass(AX, unit)
        % Rn: potential alpha energy and others
        ep = PAE(N_RnDP, A_Rn)
        cp = PAEC(c_RnDP, A_Rn)
        P = PAEE(t, c_RnDP, A_Rn)
        ceq = EEC(c_RnDP, A_Rn)
    end
    methods (Static = true, Access = private)
        AX = AXstr(A, Z)
    end
end

