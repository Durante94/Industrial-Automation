clear;
clc;

%% Parameters

%import data, P is the processing times transposed
[P,numMachines,numJobs]=definitions('Execution-Times.xlsx');

% % Defining the processing times
% P=P';

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
bigM = optimconstr (1);

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
machine1before2constr=optimconstr(1);

for i=1:numJobs
    for j=1:numJobs
        if i~=j
            machine1before2constr(count) = S(2,j) >= C(1,i);
            count = count+1;
        end
    end
end

prob.Constraints.machine1before2constr = machine1before2constr;

count=1;
machine1before3constr=optimconstr(1);

for i=1:numJobs
    for j=1:numJobs
        if i~=j
            machine1before3constr(count) = S(3,j) >= C(1,i);
            count = count+1;
        end
    end
end

prob.Constraints.machine1before3constr = machine1before3constr;

% M2 and M3 before M4

count=1;
machine2_3before4constr=optimconstr(1);

for i=1:numJobs
    for j=1:numJobs
        if i~=j
            machine2_3before4constr(count) = S(4,j) >= C(2,i);
            machine2_3before4constr(count) = S(4,j) >= C(3,i);
            count = count+2;
        end
    end
end

prob.Constraints.machine2_3before4constr = machine2_3before4constr;

count=1;
machine4before5constr=optimconstr(1);

for i=1:numJobs
    for j=1:numJobs
        if i~=j
            machine4before5constr(count) = S(5,j) >= C(4,i);
            count = count+1;
        end
    end
end

prob.Constraints.machine4before5constr = machine4before5constr;

%Compute Cmax

count=1;
cmaxconstr=optimconstr(1);

for i=1:numJobs
    cmaxconstr(count)=Cmax>=C(5,i);
    count=count+1;
end

prob.Constraints.cmaxconstr=cmaxconstr;

%% Solution

show(prob);
[sol, cost, output] = solve(prob);
disp(sol);
disp("The cost is " + cost);
disp(output);

