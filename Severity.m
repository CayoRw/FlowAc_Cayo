classdef Severity
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Sum
        Qtd
    end
    
    methods
        function obj = Severity(DBAR, DCIR, FlowS, Sbase)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            [NBus, ~] = size(DBAR);
            [NLin, ~] = size(DCIR);
            obj.Qtd = 0;
            obj.Sum = 0;
            for il = 1:NLin
                flowp =  FlowS(il,1);
                limflow = DCIR(il,10);
                Value = obj.Verify(flowp,limflow);
                if Value ~= 0
                    obj.Qtd = obj.Qtd  + 1;
                end
                obj.Sum = obj.Sum + Value;
            end
        end
        
        function OverL = Verify(obj,Pij,PijMax)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            if (Pij<=PijMax)
                OverL = 0;
            else
                %OverL = (Pij - (PijMax*0.85))/(PijMax*0.85);
                OverL = (Pij - PijMax)/PijMax;
            end
        end
        function [Sum,Qtd] = getSum(obj)
            Sum = obj.Sum;
            Qtd = obj.Qtd;
        end
    end
end

