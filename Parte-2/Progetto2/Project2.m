clear;
clc;
%% Data Import

[num]=xlsread('Execution-Times.xlsx');

dim=size(num);

numMachines=dim(1);
numJob=dim(2);

halfNumJob=round(numJob/2);

%% Data sorting

way2(halfNumJob) = Job(0,0,0, []);
way3(numJob-halfNumJob) = Job(0,0,0, []);

i=1; %%indice lungo way2
j=1; %%indice lungo way3

for job=1:numJob %%per ogni job
	executionTimes=zeros(1,5); 
	tmp2=0; %% costo percorso temporaneo lungo M2
	tmp3=0; %% costo percorso temporaneo lungo M3
    for jobTime=1:numMachines
        switch jobTime
            case 2
                tmp2=tmp2+num(jobTime, job);
            case 3
                tmp3=tmp3+num(jobTime, job);
            otherwise
                tmp2=tmp2+num(jobTime, job);
                tmp3=tmp3+num(jobTime, job);
        end
        executionTimes(jobTime)=num(jobTime, job);
    end
	
    if way2(halfNumJob).numJob>0
        way3(j)=Job(job, false, tmp3, executionTimes);
        j=j+1;
    elseif way3(numJob-halfNumJob).numJob>0
        way2(i)=Job(job, true, tmp2, executionTimes);
        i=i+1;
    elseif tmp2<tmp3
        way2(i)=Job(job, true, tmp2, executionTimes);
        i=i+1;
    else
        way3(j)=Job(job, false, tmp2, executionTimes);
        j=j+1;
    end 
end

% way2
% way3

[~, ind]=sort([way2.executionTime]);
way2=way2(ind);
% orderWay2=way2(ind)

[~, ind]=sort([way3.executionTime]);
way3=way3(ind);
% orderWay3=way3(ind)


%% Machines creation
Machines(numMachines)=Machine(0);
for m=1:5
    Machines(m)=Machine(m);
end

%% Executions

t=0; %time

% Problem Initialization
Machines(1)=Machines(1).PushJob(way2(1));
Machines(1)=Machines(1).PushJob(way3(numJob-halfNumJob));

way2=way2(2:end);
way3=way3(1:end-1);

listCompletedJob(numJob)=Job(0,0,0, []);% listo of the completed job in order of completion
index=1; % index of list above

% Algorithm
while listCompletedJob(numJob).numJob==0
    for m=numMachines:-1:1
        % macchina idle
        if Machines(m).startTime>-1 && Machines(m).currentJob.numJob == 0 && isempty(Machines(m).bufferJob) && Machines(m).endTime==0
            Machines(m)=Machines(m).Idle();
        end
        
        % macchina impegnata
        if Machines(m).currentJob.numJob>0 && ~Machines(m).currentJob.IsCompleted(Machines(m).numMachine, t) && Machines(m).startTime == -1
            Machines(m)=Machines(m).Starting(t);
        end
        
        % job da iniziare
        if Machines(m).currentJob.numJob>0 && ~Machines(m).currentJob.IsStarted(m)
            Machines(m).currentJob=Machines(m).currentJob.StartExe(m, t);
        end
        
        % job terminato per la macchina
        if Machines(m).currentJob.numJob>0 && Machines(m).currentJob.IsCompleted(m, t)
            Machines(m).currentJob=Machines(m).currentJob.EndExe(m, t);
                        
            % behaviour based on the machine we consider
            switch m
                case 1
                    j=-1;
                    i=-1;
                    if isempty(way2) && isempty(way3) && ~isempty(Machines(m).bufferJob) && Machines(m).currentJob.numJob==0 % if non job could be appended on the first machine the M1 end his execution
                        Machines(m)=Machines(m).Ending(t);
                    elseif Machines(m).currentJob.direction==true % if job 
                        Machines(2)=Machines(2).PushJob(Machines(m).currentJob.copyJob());
                        % choose a job that have enough time on M1 in order
                        % to not create a buffer on M2
                        for idx=1:length(way2)
                            if(way2(idx).executionTimes(1)>=Machines(m).currentJob.executionTimes(2) || idx==length(way2))
                                Machines(m)=Machines(m).PushJob(way2(idx));
                                i=idx;
                                break;
                            end
                        end
                        
                        if length(way2)==1
                            way2=[];
                        elseif i==1
                            way2=way2(2:end);
                        elseif i==length(way2)
                            way2=way2(1:end-1);
                        elseif i>0
                            way2=way2([1:i-1,i+1:end]);
                        end
                    else
                        Machines(3)=Machines(3).PushJob(Machines(m).currentJob.copyJob());
                        % choose a job that have enough time on M1 in order
                        % to not create a buffer on M3
                        for idx=1:length(way3)
                            if(way3(idx).executionTimes(1)>=Machines(m).currentJob.executionTimes(3) || idx==length(way3))
                                Machines(m)=Machines(m).PushJob(way3(idx));
                                j=idx;
                                break;
                            end
                        end
                        
                        if length(way3)==1
                            way3=[];
                        elseif j==1
                            way3=way3(2:end);
                        elseif j==length(way3)
                            way3=way3(1:end-1);
                        elseif j>0
                            way3=way3([1:j-1,j+1:end]);
                        end
                    end
                case 2
                    Machines(4)=Machines(4).PushJob(Machines(m).currentJob.copyJob());
                    if isempty(Machines(m).bufferJob) && Machines(1).endTime>0
                        Machines(m)=Machines(m).Ending(t);
                    end
                case 3
                    Machines(4)=Machines(4).PushJob(Machines(m).currentJob.copyJob());
                    if isempty(Machines(m).bufferJob) && Machines(1).endTime>0
                        Machines(m)=Machines(m).Ending(t);
                    end
                case 4
                    Machines(5)=Machines(5).PushJob(Machines(m).currentJob.copyJob());
                    if isempty(Machines(m).bufferJob) && Machines(2).endTime>0 && Machines(3).endTime>0
                        Machines(m)=Machines(m).Ending(t);
                    end
                case 5
                    listCompletedJob(index)=Machines(m).currentJob.copyJob();
                    index=index+1;
                    
                    if isempty(Machines(m).bufferJob) && Machines(4).endTime>0
                        Machines(m)=Machines(m).Ending(t);
                    end
            end        
            Machines(m)=Machines(m).PopJob();
        end
        
        % Update of the waiting time of the Jobs for every machine
        if m>1
            for idx=1:length(Machines(m).bufferJob)
                Machines(m).bufferJob(idx)=Machines(m).bufferJob(idx).Wait();
            end
        end
    end
    t=t+1;
end