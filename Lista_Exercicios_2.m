clc
clear all

% Inicializating
Sbase = 100;  % MVA
tol = 0.0001;

% File name
filename = 'dados_sistema6B_ATIV.txt';

% Getting the datas 
a = ReadData(filename);
[DBAR_real, DCIR_real,NBus,NLin] = a.getmatriz(); 

% Combinações de exclusão:
exclusions = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, [1, 2], [1, 7], [1, 10], [7, 9], [4, 8, 9], [1, 7, 11];                      
};
%size(exclusions)
Ranking = zeros (numel(exclusions), 2);                        % Criação do ranking

for i = 1:numel(exclusions)
    DBAR = DBAR_real;
    DCIR = DCIR_real;

    % Obter as linhas a serem excluídas
    linhas_excluidas = exclusions{i};
    % Remover as linhas especificadas no DCIR
    DCIR(linhas_excluidas, :) = [];
    
    % Getting the YBus
    b = MakeYBus(DBAR,DCIR);
    BBus = b.getBBus();              
    
    % Getting the Pesp and Qesp
    c = GetPQesp(DBAR);
    [Pesp, Qesp] = c.getPQesp();           
    
    % Throughout Newtom Rapson, calculating the Thetas V vector 
    d = CalcJcob(DBAR,Pesp,Qesp,BBus,tol);
    [ThetasV, Pgd, Qgd] = d.getThetasV();
     
    % Calc Flow
    e = CalcFlow(DBAR, DCIR, ThetasV);
    [FlowP, FlowQ, FlowS] = e.getFlows();
    
    %DispResults(FlowP, FlowQ, FlowS, ThetasV, Pgd, Qgd, DBAR, DCIR, Sbase);

    f = Severity(DBAR, DCIR, FlowS, Sbase);
    [SumOverload,count] = f.getSum();
    
    Ranking(i,1) = SumOverload;
    Ranking(i,2) = count;
    lost_circuit = mat2str(exclusions{i});

    disp(sprintf('Relatório curto n°:%2d da perda %2s. Valor da contingencia: %5f. Qtd: %2f',i, lost_circuit, Ranking(i,1), Ranking(i,2)));
    disp(sprintf('\n'));
    
    %Print the results
    %DispResults(FlowP, FlowQ, FlowS, ThetasV, Pgd, Qgd, DBAR, DCIR, Sbase);
end

DispRanking(Ranking,DBAR_real,DCIR_real,exclusions);
