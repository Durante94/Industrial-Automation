classdef Job %this class is to define the Jobs attributes and some utilities functions
    
    properties
        numJob; %number of jobs
        direction; %in wich parallel machine this job is planned to go trought M2 or M3
        executionTime; %total time of execution in our system
        executionTimes; %array of times of execution for every machines
        startTime; %array of the times in wich the job starting the process for every machines
        endTime; %array of the times in wich the job ending the process for every machines
        waitingTime; %array of the times that the jobs waited before go into a machine
    end
    
    methods      
        function obj = Job(number, dir, exeTime, array) %constructor
            if nargin>0
                obj.numJob=number;
                obj.direction=dir;
                obj.executionTime=exeTime;
                obj.executionTimes=array;
                obj.startTime=-ones(1,5);
                obj.endTime=zeros(1,5);
                obj.waitingTime=zeros(1,5);
            end
        end
        
        function newObj=Wait(obj, machineNum) %Increment the waiting time on machine            
            obj.waitingTime(machineNum)=obj.waitingTime(machineNum)+1;
            newObj=obj;
        end
        
        function newObj=StartExe(obj, machineNum, t)  %set the starting time of the job in the machine       
            obj.startTime(machineNum)=t;
            newObj=obj;
        end
        
        function newObj=EndExe(obj, machineNum, t)  %set the ending time of the job in the machine
            obj.endTime(machineNum)=t;
            newObj=obj;
        end
        
        function bool=IsStarted(obj, machineNum) %control returning a boolean if the job started in the machine
            bool=obj.startTime(machineNum)>-1;
        end
        
        function bool=IsCompleted(obj, machineNum, t) %control returning a boolean if the job is completed on the machine 
            if(obj.startTime(machineNum)<0)
                bool=false;
            else
                bool=obj.executionTimes(machineNum)==t-obj.startTime(machineNum);
            end
        end
        
        function copy=copyJob(obj) %return a copy of the job
        	copy=Job(obj.numJob, obj.direction, obj.executionTime, obj.executionTimes);
        	copy.startTime=obj.startTime;
            copy.endTime=obj.endTime;
            copy.waitingTime=obj.waitingTime;
        end
    end
end