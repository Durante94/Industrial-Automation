classdef Job
    %JOB Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        numJob;
        direction;
        executionTime;
        executionTimes;
        startTime;
        endTime;
        waitingTime;
    end
    
    methods      
        function obj = Job(number, dir, exeTime, array)
            if nargin>0
                obj.numJob=number;
                obj.direction=dir;
                obj.executionTime=exeTime;
                obj.executionTimes=array;
                obj.startTime=zeros(1,4);
                obj.endTime=zeros(1,4);
                obj.waitingTime=0;
            end
        end
    end
end

