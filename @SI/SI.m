classdef SI
    % designed by Dait
    properties (Constant = true)
        unit = SI.unitDict()

        %% exact constants defined by SI
        c = 299792458; % m/s
        h = 6.62607015e-34; % Js
        e = 1.602176634e-19; % C
        kB = 1.380649e-23; % J/K
        NA = 6.02214076e23; % mol-1

        %% exact constants combinition
        hc = SI.h * SI.c; % Jm
        hbarc = SI.hc / (2 * pi); % Jm

        %% exact constants derivated by SI
        hbar = SI.h / (2 * pi); % Js
        R = SI.kB * SI.NA; % J/Kmol
        F = SI.NA * SI.e; % C/mol
        sigma = 2 * pi^5 * SI.kB^4 / ...
            (15 * SI.h^3 * SI.c^2); % W/m2K4
        Wienconst = SI.h * SI.c / (SI.kB * ...
            fzero(@(x) x - 5 * (1 - exp(-x)), 5)); % mK
        c1 = 2 * pi * SI.h * SI.c^2; % Wm2
        c2 = SI.hc / SI.kB; % mk

        %% useful constants
        G = 6.67430e-11; % m3/kgs2
        g = 9.8067; % m/s2
        T0 = 273.15; % K
        V0 = 2.2414e-2; % m3
        Mair = 2.8971e-2; % kg
        epsilon0 = 8.8541878128e-12; % F/m
        mu0 = 1.25663706212e-6; % H/m
        me = 9.1093837015e-31; % kg
        mp = 1.67262192369e-27; % kg
        mn = 1.67492749804e-27; % kg

        ke = 1 / (4 * pi * SI.epsilon0);
        km = SI.mu0 / (4 * pi);
        alpha = SI.e^2 / (2 * SI.epsilon0 * SI.hc);
        alphainv = 1 / SI.alpha;

        mp_me = SI.mp / SI.me;
        e_me = SI.e / SI.me;
        lambdae = SI.h / (SI.me * SI.c);
        % lambdabare = SI.lambdae / (2 * pi);
        re = SI.alpha * SI.lambdae / (2 * pi); % classical elctron radius
        sigmae = 8 * pi / 3 * SI.re^2;
        a0 = SI.re / SI.alpha^2;
        Rinf = SI.alpha^2 / (2 * SI.lambdae); % m-1
        muB = SI.e_me * SI.hbar / 2; % J/T
    end
    methods (Static = true, Access = protected)
        unit = unitDict()
    end
    methods (Static = true)
        %% unit value
        value = unitv(expr)
        factor = unit2v(old_expr, new_expr)
        %% physic process
        f = Maxwellpdf(T, m, v)
        v = Maxwellv(T, m, type)
        [hv_, E] = Compton(hv, theta, m, options)
    end
end
