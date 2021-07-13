classdef Job
    %JOB Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        numJob;
        direction;
        executionTime;
    end
    
    methods      
        function obj = Job(number, dir, exeTime)
            if nargin>0
                obj.numJob=number;
                obj.direction=dir;
                obj.executionTime=exeTime;
            end
        end
    end
end

