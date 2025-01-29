classdef Teste
    %TESTE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        function obj = Teste(inputArg1,inputArg2)
            %TESTE Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;


% Verificar todas as linhas excluídas
%    for linha = linhas_excluidas
%        if DBAR(linha, 5) == 0
%            % Procurar o próximo número 1 na quinta coluna
%            for j = linha+1:size(DBAR, 1)
%                if DBAR(j, 5) == 1
%                    % Trocar o 1 por 0
%                    DBAR(j, 5) = 0;
%                    break; % Encerrar o laço após fazer a troca
%                end
%            end
%        end
%    end


        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

