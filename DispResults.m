classdef DispResults
    %DISPRESULTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties

    end
    
    methods
        function obj = DispResults(FlowP, FlowQ, FlowS, ThetasV, PG, QG, BusData, LinData, Sbase)

            [NBus, ~] = size(BusData);
            [NLin, ~] = size(LinData);
            posicao1 = (1:NBus).';       % Vetor de 1 a NBus
            posicao2 = (NBus+1:NBus*2).';  % Vetor de NBus a 2xNBus
            Theta = [ThetasV(posicao1)];
            VBus = [ThetasV(posicao2)];
            tipo = strings(NBus, 1);
            disp(sprintf('Resultados das Barras'));
            disp(sprintf('====================='));
            disp(sprintf('\n'));
            disp(sprintf('Barra Tipo Tensão(pu)  Ângulo(°)  PG (MW) QG (MVar) PL (MW) QL (MVAR) '));
            disp(sprintf('+---+ +--+ +---------+ +--------+ +-----+ +------+ +-----+ +------+ '));
            for ib = 1:NBus
                ang = Theta(ib)*180/pi;
                if BusData(ib,5) == 0
                    tipo(ib,1) = 'SW';
                elseif BusData(ib,5) == 1
                    tipo(ib,1) = 'PV';
                elseif BusData(ib,5) == 2
                    tipo(ib,1) = 'PQ';
                end
                Pg = PG(ib,1)*Sbase;
                Qg = QG(ib,1)*Sbase;
                Pl = BusData(ib,2)*Sbase;
                Ql = BusData(ib,3)*Sbase;
                disp(sprintf('%5d %4s %11.4f %10.4f %7.2f %8.2f %7.2f %8.2f',ib,tipo(ib,1),VBus(ib,1),ang,Pg,Qg,Pl,Ql));  
            end
            disp(sprintf('+---+ +--+ +---------+ +--------+ +-----+ +------+ +-----+ +------+'));
            disp(sprintf('\n'));
            disp(sprintf('Resultados das Linhas'));
            disp(sprintf('====================='));
            disp(sprintf('\n'));
            disp(sprintf(' De  Para Pkm(MW) Qkm(MVar) Pmk(MW)  Qmk(Mvar) Skm(MVA) Smk(MVA) Perda (MW)   Perda (Mvar)'));
            disp(sprintf('+--+ +--+ +------+ +------+ +------+ +------+  +------+ +------+ +----------+ +----------+'));
            for il = 1:NLin
                Pkm = FlowP(il,3)*Sbase;
                Qkm = FlowQ(il,3)*Sbase;
                Pmk = FlowP(il,4)*Sbase;
                Qmk = FlowQ(il,4)*Sbase;
                Skm = FlowS(il,1)*Sbase;
                Smk = FlowS(il,2)*Sbase;
                disp(sprintf('%4d %4d %8.2f %8.2f %8.2f %8.2f  %8.2f %8.2f %12.4f %12.4f', FlowP(il,1), FlowP(il,2), Pkm, Qkm, Pmk, Qmk, Skm , Smk, abs(FlowP(il,5))*Sbase, abs(FlowQ(il,5))*Sbase));
            end
            disp(sprintf('+--+ +--+ +------+ +------+ +------+  +------+  +------+ +------+ +---------+ +----------+'));
        end
    end
end

