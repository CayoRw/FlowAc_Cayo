classdef DispResults
    %DISPRESULTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties

    end
    
    methods
        function obj = DispResults(FlowP, FlowQ, FlowS, ThetasV, PG, QG, BusData, LinData, Sbase, VBaseBar)

            [NBus, ~] = size(BusData);
            [NLin, ~] = size(LinData);
            posicao1 = (1:NBus).';       % Vetor de 1 a NBus
            posicao2 = (NBus+1:NBus*2).';  % Vetor de NBus a 2xNBus
            Theta = [ThetasV(posicao1)];
            VBus = [ThetasV(posicao2)];
            tipo = strings(NBus, 1);
            % If VBaseBar is empty, fill it with 230 V for all buses
            if isempty(VBaseBar)
                VBaseBar = 230 * ones(NBus, 1);
            end
            Tpg = 0;
            Tpl = 0;
            Tqg = 0;
            Tql = 0;
            Tp = 0;
            Tq = 0;
            disp(sprintf('Resultados das Barras'));
            disp(sprintf('====================='));
            disp(sprintf('Barra Tipo  Tensão(pu)  Lim   Ângulo(°)  PG(MW)  QG(MVar) CGMax  PL(MW)  QL(MVAR) '));
            disp(sprintf('+---+ +--+ +---------+ +---+ +--------+ +------+ +------+ +----+ +-----+ +------+ '));
            for ib = 1:NBus
                CGMax = ('     ');
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
                Cg = BusData(ib,11)*Sbase;
                Sg = sqrt(Pg^2 + Qg^2);
                if(BusData(ib,5)==0)||(BusData(ib,5)==1)
                    if Pg > Cg
                        CGMax = (' ****');
                        %pgString = sprintf('%7.2f', Pg); % Adiciona asteriscos como destaque
                    else
                        CGMax = ('     ');
                        %pgString = sprintf('%7.2f', Pg);
                    end
                end
                Vbase = VBaseBar(ib,1);
                Vbus =  VBus(ib,1);
                Status = obj.VLim(Vbase, Vbus);
                Tql = Tql + Ql;
                Tqg = Tqg + Qg;
                Tpl = Tpl + Pl;
                Tpg = Pg + Tpg;
                disp(sprintf('%5d %4s %11.4f %5s %10.4f %8.2f %8.2f %5s %7.2f %8.2f',ib,tipo(ib,1),VBus(ib,1),Status,ang, Pg ,Qg,CGMax,Pl,Ql));  
            end
            disp(sprintf('+---+ +--+ +---------+ +---+ +--------+ +------+ +------+ +----+ +-----+ +------+ '));
            disp(sprintf('Total: ................................ %8.2f %8.2f ...... %7.2f %8.2f', Tpg, Tqg, Tpl, Tql));
            disp(sprintf('+---+ +--+ +---------+ +---+ +--------+ +------+ +------+ +----+ +-----+ +------+ '))
            disp(sprintf('\n'));
            disp(sprintf('Resultados das Linhas'));
            disp(sprintf('====================='));
            disp(sprintf(' De  Para Pkm(MW) Qkm(MVar) Skm(MVA) Lim(%%) Pmk(MW) Qmk(Mvar) Smk(MVA) Lim(%%) Perda(MW)  Perda(Mvar)'));
            disp(sprintf('+--+ +--+ +------+ +------+ +------+ +----+ +------+ +------+  +------+ +---+ +---------+ +---------+'));
            for il = 1:NLin
                Pkm = FlowP(il,3)*Sbase;
                Qkm = FlowQ(il,3)*Sbase;
                Pmk = FlowP(il,4)*Sbase;
                Qmk = FlowQ(il,4)*Sbase;
                Skm = FlowS(il,1)*Sbase;
                Smk = FlowS(il,2)*Sbase;
                if abs(Skm) > (LinData(il,10)*Sbase)
                    Lim = ' ****';
                else
                    Lim  = '     ';
                end
                if abs(Smk) > (LinData(il,10)*Sbase)
                    Lim2 = ' ****';
                else
                    Lim2  = '     ';
                end
                Tp = Tp + FlowP(il,5)*Sbase;
                Tq = Tq + FlowQ(il,5)*Sbase;
                Lim = abs(Skm/(LinData(il,10)*Sbase) * 100);
                Lim2 = abs(Skm/(LinData(il,10)*Sbase) * 100);
                disp(sprintf('%4d %4d %8.2f %8.2f %8.2f %5.1f %8.2f %8.2f  %8.2f %5.1f %11.4f %11.4f', FlowP(il,1), FlowP(il,2), Pkm, Qkm, Skm, Lim, Pmk, Qmk, Smk, Lim2, FlowP(il,5)*Sbase, FlowQ(il,5)*Sbase));
            end
            disp(sprintf('+--+ +--+ +------+ +------+ +------+ +----+ +------+ +------+  +------+ +---+ +---------+ +---------+'));
            disp(sprintf('Total: ..................................................................... %11.6f %11.6f', Tp, Tq));
            disp(sprintf('+--+ +--+ +------+ +------+ +------+ +----+ +------+ +------+  +------+ +---+ +---------+ +---------+'));
        end

        function Status = VLim(obj, Vbase, Vpu)
            if Vbase < 440 
                if Vpu >=0.95 && Vpu <=1.05
                    Status = '    ';
                elseif Vpu >= 0.9 && Vpu <= 1.05
                    Status = 'Cont';
                else 
                    Status = ' ****';
                end
            elseif Vbase >= 440 && Vbase < 500 
                if Vpu >=0.95 && Vpu <=1.046
                    Status = '    ';
                elseif Vpu >= 0.9 && Vpu <= 1.046
                    Status = ' Cont';
                else 
                    Status = ' ****';
                end
            elseif Vbase >= 500 && Vbase < 525 
                if Vpu >=1 && Vpu <=1.1
                    Status = '    ';
                elseif Vpu >= 0.95 && Vpu <= 1.1
                    Status = ' Cont';
                else 
                    Status = ' ****';
                end
            elseif Vbase >= 525 && Vbase < 765 
                if Vpu >=0.95 && Vpu <=1.048
                    Status = '    ';
                elseif Vpu >= 0.90 && Vpu <= 1.048
                    Status = ' Cont';
                else 
                    Status = ' ****';
                end
            elseif Vbase >= 765
                if Vpu >=0.90 && Vpu <=1.046
                    Status = '    ';
                else 
                    Status = ' ****';
                end
            end
        end
    end
end