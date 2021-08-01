clear;
clc;
%% Data Import from the excel file

[num,numMachines,numJobs]=definitions('Execution-Times.xlsx');

halfNumJob=round(numJobs/2); 

%% Data sorting

way2(halfNumJob) = Job(0,0,0, []); %set an empty array for the way to machine 2
way3(numJobs-halfNumJob) = Job(0,0,0, []); %set an empty array for the way to machine 3

i=1; %%index along way2
j=1; %%index along way3

for job=1:numJobs %%for each job
	executionTimes=zeros(1,5); 
	tmp2=0; %% cost computed along M2
	tmp3=0; %% cost computed along M3
    for jobTime=1:numMachines %for each machines
        switch jobTime
            case 2 %case of increment time for way 2
                tmp2=tmp2+num(jobTime, job);
            case 3 %case of increment time for way 3
                tmp3=tmp3+num(jobTime, job);
            otherwise %case of increment of total time of every path
                tmp2=tmp2+num(jobTime, job);
                tmp3=tmp3+num(jobTime, job);
        end
        executionTimes(jobTime)=num(jobTime, job); %set an array of execution times for every machine
    end
	
    if way2(halfNumJob).numJob>0 %if way 2 is full 
        way3(j)=Job(job, false, tmp3, executionTimes); %store the job in way 3
        j=j+1;
    elseif way3(numJobs-halfNumJob).numJob>0 %otherwise if way 3 is full 
        way2(i)=Job(job, true, tmp2, executionTimes); %store in way 2
        i=i+1;
    elseif tmp2<tmp3 %if the execution time of job is faster in way 2
        way2(i)=Job(job, true, tmp2, executionTimes); %it's stored in way 2
        i=i+1;
    else
        way3(j)=Job(job, false, tmp2, executionTimes);%otherwise it's stored in way 3
        j=j+1;
    end 
end

[~, ind]=sort([way2.executionTime]); %ascending sorting way2 
way2=way2(ind);
[~, ind]=sort([way3.executionTime]); %ascending sorting way3 
way3=way3(ind);

%% Machines creation
Machines(numMachines)=Machine(0);
for m=1:5
    Machines(m)=Machine(m);
end

%% Executions

t=0; %set start time

% Problem Initialization
Machines(1)=Machines(1).PushJob(way2(1)); %push the job from way 2 to M1
Machines(1)=Machines(1).PushJob(way3(numJobs-halfNumJob)); %push the job from way 3 to M1

way2=way2(2:end);
way3=way3(1:end-1);

listCompletedJob(numJobs)=Job(0,0,0, []);% list of the completed job in order of completion
index=0; %set index of list above

% Algorithm
while listCompletedJob(numJobs).numJob==0
    for m=numMachines:-1:1
        % macchina idle
        if Machines(m).startTime>-1 && Machines(m).currentJob.numJob == 0 && isempty(Machines(m).bufferJob) && Machines(m).endTime<0
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
                    
                    if Machines(m).currentJob.direction==true % if the job is planned to go in M2
                        Machines(2)=Machines(2).PushJob(Machines(m).currentJob.copyJob()); %push to M2
                        % choose a job that have the execution time on M1 that end at least when M2 is idle in order
                        % to not create a buffer on M2
                        for idx=1:length(way2) 
                            if(way2(idx).executionTimes(1)>=Machines(m).currentJob.executionTimes(2) || idx==length(way2))
                                Machines(m)=Machines(m).PushJob(way2(idx));
                                i=idx;
                                break;
                            end
                        end
                        
                        if length(way2)==1 %if it is the last job then empty the array
                            way2=[];
                        elseif i==1 %if not pop the first out
                            way2=way2(2:end);
                        elseif i==length(way2) %if is the last trim it out
                            way2=way2(1:end-1);
                        elseif i>0 %otherwise remove the choosen one
                            way2=way2([1:i-1,i+1:end]);
                        end
                    else
                        Machines(3)=Machines(3).PushJob(Machines(m).currentJob.copyJob());
                        % choose a job that have the execution time on M1 that end at least when M3 is idle in order
                        % to not create a buffer on M3
                        for idx=1:length(way3)
                            if(way3(idx).executionTimes(1)>=Machines(m).currentJob.executionTimes(3) || idx==length(way3))
                                Machines(m)=Machines(m).PushJob(way3(idx));
                                j=idx;
                                break;
                            end
                        end
                        
                        if length(way3)==1 %if it is the last job then empty the array
                            way3=[];
                        elseif j==1 %if not pop the first out
                            way3=way3(2:end);
                        elseif j==length(way3) %if is the last trim it out
                            way3=way3(1:end-1);
                        elseif j>0 %otherwise remove the choosen one
                            way3=way3([1:j-1,j+1:end]);
                        end
                    end
                case {2, 3} 
                    Machines(4)=Machines(4).PushJob(Machines(m).currentJob.copyJob());
                case 4
                    Machines(5)=Machines(5).PushJob(Machines(m).currentJob.copyJob());
                case 5
                    index=index+1;
                    listCompletedJob(index)=Machines(m).currentJob.copyJob();
                    
                    if index==numJobs %if the completed job was the last one set the correct end time for every machines
                        oppositeWay=~listCompletedJob(index).direction;
                        for mPos=1:length(listCompletedJob(index).endTime)  %set the finish time for every machine                        
                            Machines(mPos)=Machines(mPos).Ending(listCompletedJob(index).endTime(mPos));
                        end
                        for jobPos=index-1:-1:1 
                            if listCompletedJob(jobPos).direction==oppositeWay
                                if oppositeWay
                                    mPos=2;
                                else
                                    mPos=3;
                                end
                                Machines(mPos)=Machines(mPos).Ending(listCompletedJob(jobPos).endTime(mPos));
                                break;
                            end
                        end
                    end
            end        
            Machines(m)=Machines(m).PopJob(); %remove the completed job from execution on the current machine
        end
        
        % Update of the waiting time of the Jobs for every machine
        for idx=1:length(Machines(m).bufferJob)
            Machines(m).bufferJob(idx)=Machines(m).bufferJob(idx).Wait(m);
        end
        if m==1
            for idx=1:length(way2)
                way2(idx)=way2(idx).Wait(1);
            end
            for idx=1:length(way3)
                way3(idx)=way3(idx).Wait(1);
            end
        end
    end
    
    t=t+1;
end

for tab_job = listCompletedJob %display all the values stored about the jobs
    disp (tab_job);
end


%% Plotting

clf;
close all;

% Creation of the matrix that we're going
% to plot in the Gantt chart
ganttMatrix = zeros(numMachines*2, numJobs);
labels=cell(numMachines*2, 1);

for job=listCompletedJob
    tmp=zeros(1,numMachines*2);
    for i=1:length(job.waitingTime)   
        tmp(1,2*i-1)=job.waitingTime(i);
        tmp(1,2*i)=job.endTime(i)-job.startTime(i)+1;

        if isempty(labels{2*i})
            labels{2*i-1}="";
            labels{2*i}="Execution time in Machine"+i;
        end
    end
    
    ganttMatrix(job.numJob,:)=tmp;
end

H = barh(1:numJobs,ganttMatrix,'stacked');
set(H(1:2:numMachines*2),'Visible','off');
title('Gantt chart');
xlabel('Processing time');
ylabel('Job schedule');
legend(labels, 'Location', 'northwest');