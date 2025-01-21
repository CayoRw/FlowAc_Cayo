classdef CalcFlow
    properties
        FlowP
        FlowQ
        FlowS
    end
    methods
        function obj = CalcFlow(BusData, LinData, ThetasV)
             % Inicialização
            [NBus, ~] = size(BusData);
            [NLin, ~] = size(LinData);
            obj.FlowP = zeros(NLin,5);
            obj.FlowQ = zeros(NLin,5);
            obj.FlowS = zeros(NLin,2);
            posicao1 = (1:NBus).';  % Vetor de 1 a NBus
            posicao2 = (NBus+1:NBus*2).';  % Vetor de NBus a 2xNBus
            theta = [ThetasV(posicao1)];
            VBus = [ThetasV(posicao2)];
            for il = 1:NLin
                k = LinData(il,1);
                m = LinData(il,2);
                r = LinData(il,4);
                x = LinData(il,5);
                bkm_sh = LinData(il,6)/2;
                gkm = r / (r^2 + x^2);
                bkm =  - x / (r^2 + x^2);
                %ykm = 1 / (r + 1i*x);
                %ykm2 = gkm + 1i*bkm;
                %teste = ykm - ykm2;        
                %disp(teste);   % Estava verificando se o bkm e o gkm foram calculados certos  -> (se teste = 0)
                akm = LinData(il,7);
                phi = (LinData(il,8)*pi/180);
                Vk = VBus(k,1);
                Vm = VBus(m,1);
                % Os calculos de Pkm, Qkm, Pmk e Qmk foram feitos  de acordo com o Slide 34 do Fernando: 01 - Módulo 01 - Fluxo de Carga - Revisão 01 - Modelagem de equipamentos de SEP
                Pkm = (akm * Vk)^2 * gkm - (akm * Vk) * Vm * gkm * cos(theta(k,1)-theta(m,1) + phi) - (akm * Vk) * Vm * bkm * sin(theta(k,1)-theta(m,1) + phi);
                Qkm = -(akm * Vk)^2 * (bkm + bkm_sh) + (akm * Vk) * Vm * bkm * cos(theta(k,1)-theta(m,1) + phi) - (akm * Vk) * Vm * gkm * sin(theta(k,1)-theta(m,1) + phi);
                Pmk = (Vm)^2 * gkm - (akm * Vk) * Vm * gkm * cos(theta(m,1)-theta(k,1) - phi) - (akm * Vk) * Vm * bkm * sin(theta(m,1)-theta(k,1) - phi);
                Qmk = -(Vm)^2 * (bkm + bkm_sh) + (akm * Vk) * Vm * bkm * cos(theta(m,1)-theta(k,1) - phi) - (akm * Vk) * Vm * gkm * sin(theta(m,1)-theta(k,1) - phi);

%{
                Maneira 'errada' feita pelo Warley
                Vk = VBus(ibf,1)*(cos(Theta(ibf,1)) + 1i*sin(Theta(ibf,1)));
                Vm = VBus(ibt,1)*(cos(Theta(ibt,1)) + 1i*sin(Theta(ibt,1)));
                Vp = tap*exp(-1i*phi)*Vk;
                Ikm = -tap*Imk*exp(1i*phi) + Vk*bsh;
                Imk = y*(Vm -Vp) + Vm*bsh;
                Ikm = -tap*Imk*exp(1i*phi) + Vk*bsh;
                Smk = Vm*conj(Imk);
                Skm = Vk*conj(Ikm);
%}
               
                % Fluxo de potência ativa / perdas ativas 
                obj.FlowP(il,1) = k;
                obj.FlowP(il,2) = m;
                obj.FlowP(il,3) = Pkm;
                obj.FlowP(il,4) = Pmk;
                obj.FlowP(il,5) = obj.FlowP(il,3) + obj.FlowP(il,4);
                % Fluxo de potência reativa / perdas reativas 
                obj.FlowQ(il,1) = k;
                obj.FlowQ(il,2) = m;
                obj.FlowQ(il,3) = Qkm;
                obj.FlowQ(il,4) = Qmk;
                obj.FlowQ(il,5) = obj.FlowQ(il,3) + obj.FlowQ(il,4);
                % Armazenando Skm e Smk
                obj.FlowS(il,1) = sqrt(obj.FlowP(il,3) ^ 2 + obj.FlowQ(il,3) ^ 2);
                obj.FlowS(il,2) = sqrt(obj.FlowP(il,4) ^ 2 + obj.FlowQ(il,4) ^ 2);
            end
        end
        function [FlowP, FlowQ, FlowS] = getFlows(obj)
            FlowP = obj.FlowP;
            FlowQ = obj.FlowQ;
            FlowS = obj.FlowS;
        end
    end
end