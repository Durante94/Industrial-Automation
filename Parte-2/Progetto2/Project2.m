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
    else
        if way3(numJob-halfNumJob).numJob>0
            way2(i)=Job(job, true, tmp2, executionTimes);
            i=i+1;
        else
            if tmp2<tmp3
                way2(i)=Job(job, true, tmp2, executionTimes);
                i=i+1;
            else
                way3(j)=Job(job, false, tmp2, executionTimes);
                j=j+1;
            end 
        end
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

i=1; %%indice lungo way2
j=numJob-halfNumJob; %%indice lungo way3
t=0; %time

% Problem Initialization
Machines(1).PushJob(way2(i));
Machines(1).PushJob(way3(j));

i=i+1;
j=j-1;

% Algorithm
while way2(halfNumJob).endTime(numMachines-1)==0 && way3(1).endTime(numMachines-1)==0
	for m=numMachines:-1:1
        % macchina idle
        if Machines(m).startTime>-1 && Machines(m).currentJob == 0 && isempty(Machines(m).bufferJob)
            Machines(m).Idle();
        end
        
        % macchina impegnata
        if Machines(m).currentJob>0 && ~Machines(m).currentJob.IsCompleted(Machines(m).numMachine, t) && Machines(m).startTime == -1
            Machines(m).startTime=t;
        end
        
        % job da iniziare
        if Machines(m).currentJob>0 && Machines(m).currentJob.startTime(m)<0
            Machines(m).currentJob.startTime(m, t);
        end
        
        % job terminato per la macchina
        if Machines(m).currentJob>0 && Machines(m).currentJob.IsCompleted(m, t)
            Machines(m).currentJob.EndExe(m, t);
            
            % behaviour based on the machine we consider
            switch m
                case 1
                    if Machines(m).currentJob.direction==true
                        Machines(2).PushJob(Machines(m).currentJob);
                        % choose a job that have enough time on M1 in order
                        % to not create a buffer on M2
                        for idx=1:length(way2)
                            if(way2(idx).executionTimes(1)>=Machines(m).currentJob.executionTimes(2))
                                Machines(m).PushJob(way2(idx));
                                i=idx;
                                break;
                            end
                        end
                        
                        if i==1
                            way2=way2(2:end);
                        else
                            if i==length(way2)
                                way2=way2(1:end-1);
                            else
                                way2=way2([1:i-1,i+1:end]);
                            end
                        end
                    else
                        Machines(3).PushJob(Machines(m).currentJob);
                        % choose a job that have enough time on M1 in order
                        % to not create a buffer on M3
                        for idx=1:length(way3)
                            if(way3(idx).executionTimes(1)>=Machines(m).currentJob.executionTimes(2))
                                Machines(m).PushJob(way3(idx));
                                j=idx;
                                break;
                            end
                        end
                        
                        if j==1
                            way3=way3(2:end);
                        else
                            if j==length(way3)
                                way3=way3(1:end-1);
                            else
                                way3=way3([1:j-1,j+1:end]);
                            end
                        end
                    end
                case {2,3}
                    Machines(4).PushJob(Machines(m).currentJob);
                case 4
                    Machines(5).PushJob(Machines(m).currentJob);
            end        
            Machines(m).PopJob(t);
        end
    end
	t=t+1;
end
