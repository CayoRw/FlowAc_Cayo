classdef DispRanking
    %DISPRANKING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        function obj = DispRanking(Ranking,DBAR,DCIR,exclusions)
            [NBus, ~] = size(DBAR);
            [NLin, ~] = size(DCIR);
            [~, NExc] = size(exclusions);

            [~, idx] = sort(Ranking(:,1), 'descend');

            Ranking = Ranking(idx, :);
            exclusions = exclusions(idx);
            %DCIR_ranking = DCIR;
            disp(sprintf('Resultados do ranking de severidade de cada contingência:'));
            disp(sprintf('========================================================='));
            disp(sprintf(' IDENTIFICACAO DA CONTINGENCIA       |   CONTINGÊNCIA  '));
            disp(sprintf(' Perda do(s) circuito(s)             |   Qtd.Violacoes  Indice'));
            disp(sprintf('+----------------------+.............|...+-----------+ +------+'));
            for il = 1:NExc
                exclusionStr = mat2str(exclusions{il}); 
                %disp(sprintf('%4d %4d %8d             |   %13d %8.4f', DCIR_ranking(il,1), DCIR_ranking(il,2), DCIR_ranking(il,3), Ranking(il,2), Ranking(il,1)));
                disp(sprintf('%24s             |   %13d %8.4f', exclusionStr, Ranking(il,2), Ranking(il,1)));
            end
            disp(sprintf('+----------------------+.............|...+-----------+ +------+'));
        end
    end
end

