classdef MakeYBus
    properties
        BBus
    end

    methods
        function obj = MakeYBus(BusData, LinData)
            % Construtor da classe que cria a matriz YBus a partir de BusData e LinData
            [NBus, ~] = size(BusData);
            [NLin, ~] = size(LinData);

            % Inicialização da matriz de susceptância
            obj.BBus = zeros(NBus, NBus);

            % Preenchendo a matriz de susceptância
            for il = 1:NLin
                k = LinData(il, 1);
                m = LinData(il, 2);
                ykm = 1 / (LinData(il, 4) + LinData(il, 5) * 1i);
                bkmsh = (LinData(il, 6) * 1i)/2;
                tap = LinData(il, 7);
                phi = -(LinData(il, 8) * pi / 180);
                % Atualiza os valores na matriz BBus
                obj.BBus(k, k) = obj.BBus(k, k) + (tap^2) * ykm + bkmsh;
                obj.BBus(k, m) = obj.BBus(k, m) -tap * ykm * exp(1i * phi);
                obj.BBus(m, k) = obj.BBus(m, k) -tap * ykm * exp(-1i * phi);
                obj.BBus(m, m) = obj.BBus(m, m) + ykm + bkmsh;
            end

            % Considerando os shunts de barra
            for il = 1:NBus
                k = BusData(il,1);
                bshk = BusData(il, 4);
                if bshk ~= 0
                    obj.BBus(k, k) = obj.BBus(k, k) + 1i*bshk;
                end
            end
        end
        
        function BBus = getBBus(obj)
            % Método para retornar a matriz BBus
            BBus = obj.BBus;
        end
    end
end