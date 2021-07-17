clc;
clear;
%% Data Import

[num]=xlsread('Execution-Times.xlsx');

%% Data sorting

way2(5)=Job(0,0,0, []);
way3(5)=Job(0,0,0, []);

i=1; %%indice lungo way2
j=1; %%indice lungo way3

for job=1:10 %%per ogni job
	executionTimes=zeros(1,5); 
	tmp2=0; %% costo percorso temporaneo lungo M2
	tmp3=0; %% costo percorso temporaneo lungo M3
	for jobTime=1:5 %% cicliamo fino alla M4 che è il nostro collo di bottiglia
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
	
	if way2(5).numJob>0
        way3(j)=Job(job, 3, tmp3, executionTimes);
        j=j+1;
    else
        if way3(5).numJob>0
            way2(i)=Job(job, 2, tmp2, executionTimes);
            i=i+1;
        else
            if tmp2<tmp3
                way2(i)=Job(job, 2, tmp2, executionTimes);
                i=i+1;
            else
                way3(j)=Job(job, 3, tmp2, executionTimes);
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
Machines(5)=Machine(0);
for m=1:5
    Machines(m)=Machine(m);
end

%% Executions

i=1; %%indice lungo way2
j=5; %%indice lungo way3
t=0; %time

while way2(5).endTime(4)==0 && way3(1).endTime(4)==0
	for m=5:-1:1
        a
    end
	t=t+1;
end