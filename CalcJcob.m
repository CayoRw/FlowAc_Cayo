classdef CalcJcob
    properties
        ThetasV % Vetor de ângulos e tensões
        Pgd
        Qgd
    end
    methods
        function obj = CalcJcob(BusData, Pesp, Qesp, BBus, tol)
            % Inicialização
            [NBus, ~] = size(BusData);
            DeltaP = zeros(NBus,1);
            DeltaQ = zeros(NBus,1);
            Theta = BusData(:,7);
            V = BusData(:,6);
            obj.Pgd = BusData(:,8);
            obj.Qgd = zeros(NBus,1);
            obj.ThetasV = [Theta; V];
            count = 0;
            posicao1 = (1:NBus).';       % Vetor de 1 a NBus
            posicao2 = (NBus+1:NBus*2).';  % Vetor de NBus a 2xNBus
            Gbus = real(BBus);
            Bbus = imag(BBus);
            max_error = 1000;
            max_count = 1000;
            % Começando o loop do Newton-Raphson
            while (max_error > tol) && (count < max_count)
                a = 0; b=0;
                Theta = [obj.ThetasV(posicao1)];
                V = [obj.ThetasV(posicao2)];

                % Inicializa variáveis de potência
                sP = zeros(NBus,1);
                sQ = zeros(NBus,1);

                % Calcula os desvios de potência ativa e reativa
                for k = 1:NBus
                    for m = 1:NBus
                        sP(k,1)= sP(k,1) +V(m,1)*(Gbus(k,m)*cos(Theta(k,1)-Theta(m,1))+(Bbus(k,m)*sin(Theta(k,1)-Theta(m,1))));
                        sQ(k,1)= sQ(k,1) +V(m,1)*(Gbus(k,m)*sin(Theta(k,1)-Theta(m,1))-(Bbus(k,m)*cos(Theta(k,1)-Theta(m,1))));
                    end
                    DeltaP(k,1) = Pesp(k,1) - V(k,1)*sP(k,1);
                    DeltaQ(k,1) = Qesp(k,1) - V(k,1)*sQ(k,1);
               
                end
                % Descobrindo a máxima variação de delta P para as barras PQ e PV e a máxima variação de delta Q para as barras PQ
                
                for k = 1:NBus
                    if (BusData(k,5)==2 || BusData(k,5)==1) && a<=abs(DeltaP(k,1))
                        a = abs(DeltaP(k,1));
                    end
                    if BusData(k,5)==2 && b<=abs(DeltaQ(k,1))
                        b = abs(DeltaQ(k,1));
                    end
                end
                max_error = max(a,b);
                % Cria a matriz Jacobiana e reseta as variaveis
                Jcob = zeros(NBus*2, NBus*2);
                sH = zeros(NBus,1); sN = zeros(NBus,1);
                sM = zeros(NBus,1); sL = zeros(NBus,1);

                % Preenche a matriz Jacobiana
                for k = 1:NBus*2
                    for m = 1:NBus*2
                        % Construcao da matriz H
                        if k<=NBus && m<=NBus
                            if (k==m) && (BusData(k,5)==0) 
                                Jcob(k,m) = 1000000000;  %1 bilhão
                            elseif(k==m)
                                for i=1:NBus
                                    sH(k,1)= sH(k,1) + V(i,1)*(Gbus(k,i)*sin(Theta(k,1)-Theta(i,1))-Bbus(k,i)*cos(Theta(k,1)-Theta(i,1)));
                                end
                                Jcob(k,m) = -(V(k,1)^2)*Bbus(k,k)-V(k,1)*sH(k,1);
                            elseif(k~=m) && ((BusData(k,5)==0) || (BusData(m,5)==0))
                                Jcob(k,m) = 0;
                            else
                                Jcob(k,m) = V(k,1)*V(m,1)*(Gbus(k,m)*sin(Theta(k,1)-Theta(m,1))-Bbus(k,m)*cos(Theta(k,1)-Theta(m ,1)));
                            end
                        % Construcao da matriz N
                        elseif k<=NBus && m>NBus
                            m2= m-NBus;
                            if (k==m2) && ((BusData(k,5)==0) || (BusData(k,5)==1))
                                Jcob(k,m) = 0;
                            elseif (k==m2) 
                                for i=1:NBus
                                    sN(k,1)= sN(k,1) + V(i,1)*(Gbus(k,i)*cos(Theta(k,1)-Theta(i,1))+Bbus(k,i)*sin(Theta(k,1)-Theta(i,1)));
                                end
                                Jcob(k,m) = V(k,1)*Gbus(k,k)+sN(k,1);
                            elseif (k~=m2) && ((BusData(k,5)==0) || (BusData(m2,5)==0))
                                Jcob(k,m) = 0;
                            else
                                Jcob(k,m) = V(k,1)*(Gbus(k,m2)*cos(Theta(k,1)-Theta(m2,1))+(Bbus(k,m2)*sin(Theta(k,1)-Theta(m2,1))));
                            end
                        % Construcao da matriz M
                        elseif k>NBus && m<=NBus
                            k2 = k- NBus;
                            if (k2 == m) && ((BusData(k2,5)==0) || (BusData(m,5)==1))
                                Jcob(k,m) = 0;
                            elseif (k2==m) 
                                for i=1:NBus
                                    sM(k2,1)= sM(k2,1) + V(i,1)*(Gbus(k2,i)*cos(Theta(k2,1)-Theta(i,1))+Bbus(k2,i)*sin(Theta(k2,1)-Theta(i,1)));
                                end
                                Jcob(k,m) = -(V(k2,1)^2)*Gbus(k2,k2)+V(k2,1)*sM(k2,1);
                            elseif (k2~=m) && ((BusData(k2,5)==0) || (BusData(m,5)==0))
                                Jcob(k,m) = 0;
                            else
                                Jcob(k,m) = -V(k2,1)*V(m,1)*(Gbus(k2,m)*cos(Theta(k2,1)-Theta(m,1))+Bbus(k2,m)*sin(Theta(k2,1)-Theta(m,1)));
                            end
                        % Construcao da matriz L
                        elseif k>NBus && m>NBus
                            k2=k- NBus;
                            m2=m- NBus;
                            if (k==m) && ((BusData(k2,5)==0) || (BusData(k2,5)==1))
                                Jcob(k,m) = 1000000000;
                            elseif (k==m) 
                                for i=1:NBus
                                    sL(k2,1)= sL(k2,1) + V(i,1)*(Gbus(k2,i)*sin(Theta(k2,1)-Theta(i,1))-(Bbus(k2,i)*cos(Theta(k2,1)-Theta(i,1))));
                                end
                                Jcob(k,m) = -V(k2,1)*Bbus(k2,k2)+sL(k2,1);
                            elseif (k~=m) && ((BusData(k2,5)==0) || (BusData(m2,5)==0))
                                Jcob(k,m) = 0;
                            elseif (k~=m) && ((BusData(k2,5)==1) || (BusData(m2,5)==1))
                                if (k2 == BusData(k2,1)) && (BusData(k2,5)==1)
                                    Jcob(k,m2) = 0;
                                end
                                if (m2==BusData(m2,1)) && (BusData(m2,5)==1)
                                    Jcob(k2,m) = 0;
                                end
                            else
                                Jcob(k,m) = V(k2,1)*(Gbus(k2,m2)*sin(Theta(k2,1)-Theta(m2,1))-Bbus(k2,m2)*cos(Theta(k2,1)-Theta(m2,1)));
                            end
                        end
                    end
                end
                % Atualiza as variáveis Theta e V
                DeltasPQ = [DeltaP; DeltaQ];
                Jcob = -1*Jcob;
                DeltaThetasV = (-inv(Jcob))*DeltasPQ;
                obj.ThetasV = obj.ThetasV + DeltaThetasV;
                count = count+1; 
                if (count == max_count-1)
                    disp(sprintf('Cuidado, a Jacob parou com %d iterações com um erro maximo de %d', max_count, max_error))
                    disp (' ')
                end
            end
            if count ~= max_count
                disp(sprintf('Jcob convergiu com %d iterações com uma variação de DeltaPQ máxima de %d', count, max_error))
                disp (' ')
            end
            for i = 1:NBus
                if (BusData(i,5)==0)
                    obj.Pgd(i,1) = -DeltaP(i,1);
                    obj.Qgd(i,1) = -DeltaQ(i,1);
                end
                if (BusData(i,5)==1)
                    obj.Qgd(i,1) = -DeltaQ(i,1);
                end
            end
        end
%Método para retornar as variáveis desejadas
        function [ThetasV, Pgd, Qgd] = getThetasV(obj)
            ThetasV = obj.ThetasV;
            Pgd = obj.Pgd;
            Qgd = obj.Qgd;
        end
    end
end