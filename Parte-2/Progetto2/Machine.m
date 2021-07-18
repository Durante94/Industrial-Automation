classdef Machine < handle
    
    properties
        numMachine;
        currentJob; %current job under execution
        bufferJob; %fifo array of job that wait for the execution
        idleTime; %how much time the machine was idle
        startTime;
        endTime;
    end
    
    methods
        function obj = Machine(num)
            if nargin>0
                obj.numMachine=num;
                obj.currentJob=Job(0,0,0, []);
                obj.bufferJob=Job.empty;
                obj.idleTime=0;
                obj.startTime=-1;
                obj.endTime=-1;
            end
        end
        
        function obj=Idle(obj)
            obj.idleTime=obj.idleTime+1;
        end
        
        function obj=Starting(obj, t)
            obj.startTime=t;
        end
        
        function obj=Ending(obj, t)
            obj.endTime=t;
        end

        function obj=PushJob(obj, job)
            if obj.currentJob==0
                obj.currentJob=job;
            else
                obj.bufferJob(length(obj.bufferJob)+1)=job;
            end
        end
        
        function obj=PopJob(obj, t)
           if obj.currentJob.IsCompleted(obj.numMachine, t) && ~isempty(obj.bufferJob)
               obj.currentJob = obj.bufferJob(1);
               obj.bufferJob = obj.bufferJob(2:end);               
           end
        end
    end
end