classdef Job
    
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
        
        function obj=Wait(obj)
            obj.waitingTime=obj.waitingTime+1;
        end
        
        function obj=StartExe(obj, machineNum, t)
            tmp=machineNum;
            if tmp>2
            	tmp=machineNum-1;
            end
            
            obj.startTime(tmp)=t;
        end
        
        function obj=EndExe(obj, machineNum, t)
            tmp=machineNum;
            if tmp>2
            	tmp=machineNum-1;
            end
            
            obj.endTime(tmp)=t;
        end
        
        function bool=IsCompleted(obj, machineNum, t)
            tmp=machineNum;
            if tmp>2
            	tmp=machineNum-1;
            end
            
            bool=obj.executionTimes(tmp)==t-obj.startTime(tmp);
        end
    end
end

