classdef ReadData
    properties
        DBAR
        DCIR
    end
    methods
        function obj = ReadData(filename)
            
            fid = fopen(filename, 'r');
            if fid == -1
                error('Não foi possível abrir o arquivo.');
            end
            
            % Inicializando variáveis para armazenar dados
            obj.DBAR = {};
            obj.DCIR = {};
            secao_atual = '';
            
            % Lendo o arquivo linha por linha
            while ~feof(fid)
                linha = strtrim(fgetl(fid)); % Lê a linha e remove espaços em branco nas extremidades
                
                % Identificando as seções
                if strcmp(linha, 'DBAR')
                    secao_atual = 'DBAR';
                    continue;
                elseif strcmp(linha, 'DCIR')
                    secao_atual = 'DCIR';
                    continue;
                elseif startsWith(linha, '####')
                    secao_atual = ''; % Fim da seção
                    continue;
                elseif startsWith(linha, 'OBS')
                    break; % Ignora os comentários a partir daqui
                end
                
                % Processa a linha dependendo da seção atual
                if strcmp(secao_atual, 'DBAR')
                    obj.DBAR = [obj.DBAR; strsplit(linha)];
                elseif strcmp(secao_atual, 'DCIR')
                    obj.DCIR = [obj.DCIR; strsplit(linha)];
                end
            end
            
            % Fechando o arquivo
            fclose(fid);

            % Removendo as duas primeiras linhas de DBAR e DCIR
            if size(obj.DBAR, 1) > 2
                obj.DBAR(1:2, :) = [];
            end
            if size(obj.DCIR, 1) > 2
                obj.DCIR(1:2, :) = [];
            end
        % Substituindo os valores na matriz DBAR
        obj.DBAR = strrep(strrep(strrep(obj.DBAR, 'SW', '0'), 'PV', '1'), 'PQ', '2');
        
        % Substituindo os valores na matriz DCIR
        obj.DCIR = strrep(strrep(obj.DCIR, 'L', '1'), 'D', '0');
        
        % Convertendo as matrizes para double
        obj.DBAR = str2double(obj.DBAR);
        obj.DCIR = str2double(obj.DCIR);
        end

        function [DBAR, DCIR] = getmatriz(obj)
            % Método para retornar as matrizes DBAR, DCIR e a tolerância
            DBAR = obj.DBAR;
            DCIR = obj.DCIR;
        end
    end
end
