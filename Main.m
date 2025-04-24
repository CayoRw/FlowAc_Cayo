%Follow me on GitHub: www.github.com/CayoRw

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

% If you want to control the voltage limits based on ONS recommended phase-to-phase voltages at 60Hz
% If you dont, just ignore
% Example of default base voltages for each bus:
VBaseBar = [500; 500; 500; 500; 500; 500; 500; 138; 138; 138; 138; 138; 138]; % KV

%DCIR(10, :) = []; %Use this if you want to remove a circuit. %If you dont, just ignore

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
DispResults(FlowP, FlowQ, FlowS, ThetasV, Pgd, Qgd, DBAR, DCIR, Sbase, VBaseBar);

%You can read it all on www.github.com/CayoRw/FlowAc_Cayo
