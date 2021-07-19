classdef Machine
    
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
        
        function newObj=Idle(obj)
            obj.idleTime=obj.idleTime+1;
            newObj=obj;
        end
        
        function newObj=Starting(obj, t)
            obj.startTime=t;
            newObj=obj;
        end
        
        function newObj=Ending(obj, t)
            obj.endTime=t;
            newObj=obj;
        end

        function newObj=PushJob(obj, job)
            if obj.currentJob.numJob==0
                obj.currentJob=job;
            else
                obj.bufferJob(length(obj.bufferJob)+1)=job;
            end
            newObj=obj;
        end
        
        function newObj=PopJob(obj, t)
           if obj.currentJob.IsCompleted(obj.numMachine, t) && ~isempty(obj.bufferJob)
               obj.currentJob = obj.bufferJob(1);
               obj.bufferJob = obj.bufferJob(2:end);               
           end
           newObj=obj;
        end
    end
end