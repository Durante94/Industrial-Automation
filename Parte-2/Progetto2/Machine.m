classdef Machine
    %MACHINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        numMachine;
        currentJob;
        bufferJob;
        idleTime;
        startTime;
        endTime;
    end
    
    methods
        function obj = Machine(num)
            if nargin>0
                obj.numMachine=num;
                obj.currentJob=0;
                obj.bufferJob=zeros(1,10);
                obj.idleTime=0;
                obj.startTime=0;
                obj.endTime=0;
            end
        end
        
    end
end

