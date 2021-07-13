clc;
clear;
%% Data Import

[num]=xlsread('Execution-Times.xlsx');

%% Data sorting

way2(5)=Job(0,0,0);
way3(5)=Job(0,0,0);

i=1; %%indice lungo way2
j=1; %%indice lungo way3

for job=1:10 %%per ogni job
   tmp2=0; %% costo percorso temporaneo lungo M2
   tmp3=0; %% costo percorso temporaneo lungo M3
   for jobTime=1:4 %% cicliamo fino alla M4 che è il nostro collo di bottiglia
       switch jobTime
            case 2
                tmp2=tmp2+num(jobTime, job);
            case 3
                tmp3=tmp3+num(jobTime, job);
            otherwise
                tmp2=tmp2+num(jobTime, job);
                tmp3=tmp3+num(jobTime, job);
        end
   end
   
   if way2(5).numJob>0
       way3(j)=Job(job, 3, tmp3);
       j=j+1;
   else
       if way3(5).numJob>0
           way2(i)=Job(job, 2, tmp2);
           i=i+1;
       else
           if tmp2<tmp3
               way2(i)=Job(job, 2, tmp2);
               i=i+1;
           else
               way3(j)=Job(job, 3, tmp2);
               j=j+1;
           end 
       end
   end
end

way2
way3

[~, ind]=sort([way2.executionTime]);
orderWay2=way2(ind)

[~, ind]=sort([way3.executionTime]);
orderWay3=way3(ind)