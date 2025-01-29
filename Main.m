clc
clear all

% Inicializating
Sbase = 100;  % MVA
tol = 0.0001;

% File name
filename = 'dados_sistema13B_EC3_CasoBase.txt';

% Getting the datas 
a = ReadData(filename);
[DBAR, DCIR] = a.getmatriz();       

DCIR(10, :) = [];
%DCIR(3, :) = [];

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

% Print the results
DispResults(FlowP, FlowQ, FlowS, ThetasV, Pgd, Qgd, DBAR, DCIR, Sbase);