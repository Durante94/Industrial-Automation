clear;
clc;

%% Parameters

%import data, P is the processing times transposed
[P,numMachines,numJobs]=definitions('Execution-Times.xlsx');

% Defining the jobs
J = 1:numJobs;

% Defining the machines
M = 1:numMachines;

% Big-M coefficient
m = 1000;

%% Variables

prob = optimproblem;

S = optimvar('S', numMachines, numJobs, 'lowerbound',0);%starting times
C = optimvar('C', numMachines, numJobs, 'lowerbound',0);%completion times
X = optimvar('X', numMachines, numJobs, numJobs, 'Type', 'integer', 'lowerbound',0, 'upperbound', 1);%binary variables
Y = optimvar('Y', numMachines, numJobs, 'Type', 'integer', 'lowerbound',0, 'upperbound', 1);%binary variables, indicate 1 if the machine is used for the job i, otherwise 0
Cmax=optimvar('Cmax', 1, 'lowerbound',0);

%% Objective function

prob.Objective = Cmax;

%% Constraints

% Completion time definition

count = 1;
completionTime = optimconstr(numJobs*numMachines);

for i=1:numMachines
    for j=1:numJobs
        completionTime(count) = C(i,j) == S(i,j) + P(i,j);
        count = count + 1;
    end
end

prob.Constraints.completionTime = completionTime;

% one machine must execute only one job at a time

count = 1;
bigM = optimconstr (numJobs*numJobs*numMachines);

for k=1:numMachines   
    for i=1:numJobs
        for j=1:numJobs
            if i~=j
                bigM(count) = S(k,j) >= C(k,i) - m*(1-X(k,i,j));
                bigM(count+1) = S(k,i) >= C(k,j) - m*(X(k,i,j));
                count = count+2;
            end
        end
    end
end

prob.Constraints.bigM = bigM;

% M1 before M2 and M3

count=1;
machine1before2_3constr=optimconstr(numJobs*2);

for i=1:numJobs
    machine1before2_3constr(count) = S(2,i) >= C(1,i);
    machine1before2_3constr(count) = S(3,i) >= C(1,i);
    count = count+2;
end

prob.Constraints.machine1before2_3constr = machine1before2_3constr;

% M2 and M3 before M4

count=1;
machine2_3before4constr=optimconstr(numJobs*2);

for i=1:numJobs
    machine2_3before4constr(count) = S(4,i) >= C(2,i);
    machine2_3before4constr(count) = S(4,i) >= C(3,i);
    count = count+2;
end

prob.Constraints.machine2_3before4constr = machine2_3before4constr;

% M4 before M5

count=1;
machine4before5constr=optimconstr(numJobs);

for i=1:numJobs
    machine4before5constr(count) = S(5,i) >= C(4,i);
    count = count+1;
end

prob.Constraints.machine4before5constr = machine4before5constr;

% Force the job to pass through M1, M2 or M3, M4 and M5

count = 1;
choosepathconstr = optimconstr(numJobs*(numMachines-1));

for i=1:numJobs
    choosepathconstr(count) = Y(1,i) == 1;
    choosepathconstr(count+1) = Y(2,i) + Y(3,i) == 1;
    choosepathconstr(count+2) = Y(4,i) == 1;
    choosepathconstr(count+3) = Y(5,i) == 1;
    count = count+numMachines-1;
end

prob.Constraints.choosepathconstr = choosepathconstr;

count = 1;
pathconstr = optimconstr(numJobs*4);

for i=1:numJobs
    pathconstr(count) = S(4,i) >= (S(2,i) + C(2,i)) - m*(1 - Y(2,i));
    pathconstr(count+1) = S(4,i) >= (S(3,i) + C(3,i)) - m*(1 - Y(3,i));
    pathconstr(count+1) = S(2,i) >= (S(1,i) + C(1,i)) - m*(1 - Y(2,i));
    pathconstr(count+1) = S(3,i) >= (S(1,i) + C(1,i)) - m*(1 - Y(3,i));
    count = count+4;
end

prob.Constraints.pathconstr = pathconstr;

%Compute Cmax

count=1;
cmaxconstr=optimconstr(numJobs);

for i=1:numJobs
    cmaxconstr(count)=Cmax>=C(5,i);
    count=count+1;
end

prob.Constraints.cmaxconstr=cmaxconstr;

%% Solution

show(prob);
[sol, cost, exit_flag, output] = solve(prob);
disp(sol);
disp("Cmax is " + cost);
disp(output);
disp(exit_flag);

%% Plotting

clf;
close all;

% Creation of the matrix that we're going
% to plot in the Gantt chart
ganttMatrix = zeros(numMachines*2, numJobs);
labels=cell(numMachines*2, 1);

for job=1:numJobs
    tmp=zeros(1,numMachines*2);
    for i=1:numMachines   
        if sol.Y(i,job) > 0.5
            prevMachine = i - 1;
            if i==1
                tmp(1,2*i-1)=sol.S(i,job);
            else
                if i==3 || (i==4 && sol.Y(3,job) < 0.5)
                    prevMachine = prevMachine - 1;
                end
                tmp(1,2*i-1)=sol.S(i,job)-sol.C(prevMachine,job);
            end
            tmp(1,2*i)=sol.C(i,job)-sol.S(i,job);
        else
            tmp(1,2*i-1)=0;
            tmp(1,2*i)=0;
        end

        if isempty(labels{2*i})
            labels{2*i-1}="";
            labels{2*i}="Execution time in Machine"+i;
        end
    end
    
    ganttMatrix(job,:)=tmp;
end

H = barh(1:numJobs,ganttMatrix,'stacked');
set(H(1:2:numMachines*2),'Visible','off');
title('Gantt chart');
xlabel('Processing time');
ylabel('Job schedule');
legend(labels, 'Location', 'northwest');