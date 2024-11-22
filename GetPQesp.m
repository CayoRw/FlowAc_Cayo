classdef GetPQesp
    properties
        Pesp
        Qesp
    end
    methods
% Construtor da classe, recebe o BusData e calcula os desvios de potência
        function obj = GetPQesp(BusData)
            %Inicialização
            [NBus, ~] = size(BusData);
            %Escrevem-se os desvios de potência ativa e reativa para todas barras
            %1° Passo: Descobrir os P e Q especificados do sistema
            obj.Pesp = zeros(NBus,1);
            obj.Qesp = zeros(NBus,1);
            for il = 1:NBus
                obj.Pesp(il,1) = BusData(il,8) - BusData(il,2);
                obj.Qesp(il,1) = -BusData(il,3);
            end
        end
% Método para retornar os valores de Pesp e Qesp
        function [Pesp, Qesp] = getPQesp(obj)
            Pesp = obj.Pesp;
            Qesp = obj.Qesp;
        end
    end
end
