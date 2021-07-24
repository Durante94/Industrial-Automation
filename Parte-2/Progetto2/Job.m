classdef Job
    
    properties
        numJob;
        direction; %in wich parallel machine this job is planned to go
        executionTime; %total time of execution in our system
        executionTimes; %array of times of execution for every machines
        startTime; %array of the times in wich the job starting the process for every machines
        endTime; %array of the times in wich the job ending the process for every machines
        waitingTime; %total waiting time
    end
    
    methods      
        function obj = Job(number, dir, exeTime, array)
            if nargin>0
                obj.numJob=number;
                obj.direction=dir;
                obj.executionTime=exeTime;
                obj.executionTimes=array;
                obj.startTime=-ones(1,4);
                obj.endTime=zeros(1,4);
                obj.waitingTime=0;
            end
        end
        
        function newObj=Wait(obj)
            obj.waitingTime=obj.waitingTime+1;
            newObj=obj;
        end
        
        function newObj=StartExe(obj, machineNum, t)
            tmp=machineNum;
            if tmp>2
            	tmp=machineNum-1;
            end
            
            obj.startTime(tmp)=t;
            newObj=obj;
        end
        
        function newObj=EndExe(obj, machineNum, t)
            tmp=machineNum;
            if tmp>2
            	tmp=machineNum-1;
            end
            
            obj.endTime(tmp)=t;
            newObj=obj;
        end
        
        function bool=IsStarted(obj, machineNum)
            tmp=machineNum;
            if tmp>2
            	tmp=machineNum-1;
            end
            
            bool=obj.startTime(tmp)>-1;
        end
        
        function bool=IsCompleted(obj, machineNum, t)
            tmp=machineNum;
            if tmp>2
            	tmp=machineNum-1;
            end
            
            if(obj.startTime(tmp)<0)
                bool=false;
            else
                bool=obj.executionTimes(machineNum)==t-obj.startTime(tmp);
            end
        end
        
        function copy=copyJob(obj)
        	copy=Job(obj.numJob, obj.direction, obj.executionTime, obj.executionTimes);
        	copy.startTime=obj.startTime;
            copy.endTime=obj.endTime;
            copy.waitingTime=obj.waitingTime;
        end
    end
end