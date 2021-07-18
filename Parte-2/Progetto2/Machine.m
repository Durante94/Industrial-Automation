classdef Machine
    
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
                obj.bufferJob=[];
                obj.idleTime=0;
                obj.startTime=0;
                obj.endTime=0;
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

        function obj=PushJob(obj, jobNum)
            if obj.currentJob==0
                obj.currentJob=jobNum;
            else
                obj.bufferJob(length(obj.bufferJob))=jobNum;
            end
        end
        
        function obj=PopJob(obj)
           if obj.currentJob==0 && ~isempty(obj.bufferJob)
               obj.currentJob=obj.bufferJob(1);
               obj.bufferJob(1:end-1) = obj.bufferJob(2:end);
           end
        end
    end
end

