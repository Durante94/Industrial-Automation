classdef Machine  %this class is to define the Machines attributes and some utilities functions
    
    properties
        numMachine; %number of machines
        currentJob; %current job under execution
        bufferJob; %fifo array of job that wait for the execution
        idleTime; %how much time the machine was idle
        startTime; %the time of start
        endTime; %ending time
    end
    
    methods
        function obj = Machine(num) %Costructor
            if nargin>0
                obj.numMachine=num;
                obj.currentJob=Job(0,0,0, []);
                obj.bufferJob=Job.empty;
                obj.idleTime=0;
                obj.startTime=-1;
                obj.endTime=-1;
            end
        end
        
        function newObj=Idle(obj) %Increment Idle time
            obj.idleTime=obj.idleTime+1;
            newObj=obj;
        end
        
        function newObj=Starting(obj, t) %set start time of machine
            obj.startTime=t;
            newObj=obj;
        end
        
        function newObj=Ending(obj, t) %set ending time of machine
            obj.endTime=t;
            newObj=obj;
        end

        function newObj=PushJob(obj, job) %set a job for the execution or add it in a buffer
            if obj.currentJob.numJob==0
                obj.currentJob=job;
            else
                obj.bufferJob(length(obj.bufferJob)+1)=job;
            end
            newObj=obj;
        end
        
        function newObj=PopJob(obj) %remove the current Job and replace it with the first inserted in the Buffer if it exist, otherwise we create a default null job 
           if ~isempty(obj.bufferJob)
               obj.currentJob = obj.bufferJob(1).copyJob();
               obj.bufferJob = obj.bufferJob(2:end);               
           else
               obj.currentJob=Job(0,0,0, []);
           end
           newObj=obj;
        end
        
        function copyM=copyMachine(obj) %copy the object of the machine with proprieties
            copyM=Machine(obj.numMachine);
            copyM.currentJob=obj.currentJob.copyJob();
            copyM.bufferJob=obj.bufferJob;
            copyM.idleTime=obj.idleTime;
            copyM.startTime=obj.startTime;
            copyM.endTime=obj.endTime;
        end
    end
end