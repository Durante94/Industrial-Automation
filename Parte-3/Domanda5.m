clear;
clc;

r=60;
multiplier=1000;
capacity=[10 11];
OD = [0 1 2 2 2 1;
    1 0 1 2 2 2
    2 1 0 1 2 2
    2 2 1 0 1 2
    2 2 2 1 0 1
    1 2 2 2 1 0]*r;

erogato = [];
erogato(:,1)=table2array(readtable('TABELLE EROGATO.xlsx','Range','AZ2:AZ9'));
erogato(:,2)=table2array(readtable('TABELLE EROGATO.xlsx','Range','BC2:BC9'));
erogato(:,3)=table2array(readtable('TABELLE EROGATO.xlsx','Range','BF2:BF9'));
erogato(:,4)=table2array(readtable('TABELLE EROGATO.xlsx','Range','BI2:BI9'));
erogato(:,5)=table2array(readtable('TABELLE EROGATO.xlsx','Range','BL2:BL9'));
erogato(:,6)=table2array(readtable('TABELLE EROGATO.xlsx','Range','BO2:BO9'));
magazzino=[150,4630,10,1500,300,700];

OD=reshape(OD',1,[]);
erogato=avoidCriticities(erogato);
capacity=capacity*multiplier;

%%
s_cost=ones(1,size(erogato,1)*size(erogato,2))*0.03/365*1.3;
y_cost=zeros(1,size(OD,2)*size(erogato,1));
for i=1:size(erogato,1)
    for j=1:size(OD,2)
        y_cost(1,(i-1)*size(OD,2)+j)=(OD(1,j)+2*r)*0.5;
    end
end
f=[s_cost, zeros(1,2*size(erogato,1)*size(OD,2)), y_cost];

%%
lb=zeros(1,size(erogato,1)*(size(erogato,2)+2*size(OD,2))+size(y_cost,2));
ub=Inf*ones(1,size(erogato,1)*(size(erogato,2)+2*size(OD,2))+size(y_cost,2));
intcon=size(erogato,1)*size(erogato,2)+1:size(ub,2);

%%
A1=zeros(size(erogato,1)*size(OD,2),size(ub,2));
b1=zeros(size(erogato,1)*size(OD,2),1);
for i=1:size(erogato,1)
    for j=1:size(OD,2)
        A1((i-1)*size(OD,2)+j,size(erogato,1)*size(erogato,2)+(i-1)*size(OD,2)+j)=1;
        A1((i-1)*size(OD,2)+j,size(erogato,1)*(size(erogato,2)+2*size(OD,2))+(i-1)*size(OD,2)+j)=-1;
    end
end


A2=zeros(size(erogato,1)*size(OD,2),size(ub,2));
b2=zeros(size(erogato,1)*size(OD,2),1);
for i=1:size(erogato,1)
    for j=1:size(OD,2)
        A2((i-1)*size(OD,2)+j,size(erogato,1)*(size(erogato,2)+size(OD,2))+(i-1)*size(OD,2)+j)=1;
        A2((i-1)*size(OD,2)+j,size(erogato,1)*(size(erogato,2)+2*size(OD,2))+(i-1)*size(OD,2)+j)=-1;
    end
end

%%
Aeq1=zeros(size(erogato,2),size(ub,2));
beq1=zeros(size(erogato,2),1);
for m=1:size(erogato,2)
    Aeq1(m,size(erogato,2)*size(erogato,1)-(m-1))=1;    
end
%you can delete the following
beq1=ones(size(erogato,2),1)*min(capacity);

%%
Aeq2=zeros(size(erogato,2)*(size(erogato,1)-1),size(ub,2));
beq2=zeros(size(erogato,2)*(size(erogato,1)-1),1);
for i=2:size(erogato,1)
    for m=1:size(erogato,2)
        Aeq2((i-2)*size(erogato,2)+m,(i-1)*size(erogato,2)+m)=1;
        Aeq2((i-2)*size(erogato,2)+m,(i-2)*size(erogato,2)+m)=-1;
        for j=1:size(erogato,2)
            Aeq2((i-2)*size(erogato,2)+m,size(erogato,1)*size(erogato,2)+(i-1)*size(OD,2)+j+(m-1)*size(erogato,2))=-capacity(1);
            Aeq2((i-2)*size(erogato,2)+m,size(erogato,1)*(size(erogato,2)+size(OD,2))+(i-1)*size(OD,2)+m+(j-1)*size(erogato,2))=-capacity(2);
        end            
        beq2((i-2)*size(erogato,2)+m,1)=-erogato(i,m);
    end    
end

%%
% sm1-Sj q11j +q21j =-d1 V m
Aeq3=zeros(size(erogato,2),size(ub,2));
beq3=zeros(size(erogato,2),1);
for m=1:size(erogato,2)
        Aeq3(m,m)=1;        
        for j=1:size(erogato,2)
            Aeq3(m,size(erogato,1)*size(erogato,2)+j+(m-1)*size(erogato,2))=-capacity(1);
            Aeq3(m,size(erogato,1)*(size(erogato,2)+size(OD,2))+m+(j-1)*size(erogato,2))=-capacity(2);
        end            
        beq3(m,1)=-erogato(1,m)+magazzino(1,m);
end    

%%
Aeq=[Aeq2
    Aeq3];
beq=[beq2
    beq3];
A=[Aeq1
    A1
    A2];
b=[beq1
    b1
    b2];
[x,fval,exitflag,output]=intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);

x=x';

%% plot path day by day
q1_t=x(1,size(s_cost,2)+1:size(s_cost,2)+size(erogato,1)*size(OD,2));
q2_t=x(1,size(s_cost,2)+size(erogato,1)*size(OD,2)+1:size(s_cost,2)+2*size(erogato,1)*size(OD,2));

q1=zeros(size(erogato,1),size(OD,2));
q2=zeros(size(erogato,1),size(OD,2));
s=zeros(1,size(erogato,2)+size(OD,2));
t=zeros(1,size(erogato,2)+size(OD,2));
w1=zeros(size(erogato,1),size(erogato,2)+size(OD,2));
w2=zeros(size(erogato,1),size(erogato,2)+size(OD,2));
p1=zeros(size(erogato,1),size(erogato,2)+size(OD,2));
p2=zeros(size(erogato,1),size(erogato,2)+size(OD,2));
index=size(erogato,2)+1;
for i=1:size(erogato,2)
    for j=1:size(erogato,2)
        if i==j
            continue;
        end
        s(:,index)=i;
        t(:,index)=j;
        index = index+1;
    end
end
for i=1:size(erogato,2)
    t(:,i)=i;
    s(:,size(s,2)-size(erogato,2)+i)=i;
end
for i=1:size(erogato,1)
    q1(i,:)=round(q1_t(1,(i-1)*size(OD,2)+1:i*size(OD,2)));    
    q2(i,:)=round(q2_t(1,(i-1)*size(OD,2)+1:i*size(OD,2)));
    column_index=size(erogato,2)+1;
    for j=1:size(erogato,2)
        temp1=q1(i,(j-1)*size(erogato,2)+1:j*(size(erogato,2)));        
        temp2=q2(i,(j-1)*size(erogato,2)+1:j*(size(erogato,2)));        
        for k=1:size(erogato,2)
            if j==k
                continue
            end
%             w1(i,column_index)=temp1(k);
            if temp1(k)>0
                p1(i,column_index)=1;
            end
            w2(i,column_index)=temp2(k);
            column_index = column_index+1;
        end
        w1(i,j)=sum(temp1);
        p1(i,j) = w1(i,j)>0;
        w2(i,j)=sum(temp2);
    end    
%     p1(i,:)=w1(i,:)>0;
    p2(i,:)=w2(i,:)>0;
    for j=1:size(erogato,2)
        ind=j:size(erogato,2):size(q1,2);        
        p1(i,size(p1,2)-size(erogato,2)+j)=sum(q1(i,ind))>0;
        p2(i,size(p2,2)-size(erogato,2)+j)=sum(q2(i,ind))>0;
    end
end
graphRouting(s,t,w1,w2,p1,p2,size(erogato,2),["DEPOSITO";"484";"489";"501";"502";"503";"504"])

%%
storage_tab=x(1,1:size(erogato,1)*size(erogato,2));
storage_plot=cell(2,size(erogato,2));
q1_t=round(q1_t);
q2_t=round(q2_t);
for i=1:size(erogato,2)
    time =[0, 1];
    storage=[magazzino(1,i), magazzino(1,i)];    
    for j=1:size(erogato,1)
        order=0;
        for k=1:size(erogato,2)
            order=order+capacity(1,1)*q1_t(1,(j-1)*size(OD,2)+(i-1)*size(erogato,2)+k)+capacity(1,2)*q2_t(1,(j-1)*size(OD,2)+(k-1)*size(erogato,2)+i);            
        end
        last =time(1,end);
        if order >0            
            time=[time last];
            storage=[storage storage(1,end)+order];
        end          
        time=[time last+1];
        storage=[storage storage_tab(1,(j-1)*size(erogato,2)+i)];
    end
    storage_plot{1,i}=time;
    storage_plot{2,i}=storage;
end
figure
hold on
for i=1:size(erogato,2)
    plot(storage_plot{1,i},storage_plot{2,i});
end
title("Livello magazzino");
legend("484","489","501","502","503","504");
%%
transport_cost=zeros(1,size(erogato,1));
storage_cost=zeros(1,size(erogato,1));
total_y=x(size(erogato,1)*(size(erogato,2)+2*size(OD,2))+1:end);
for i=1:size(erogato,1)
    storage_cost(1,i)=sum(storage_tab(1,(i-1)*size(erogato,2)+1:i*size(erogato,2)))*0.03/365*1.3;
    transport_cost(1,i)=total_y(1,(i-1)*size(OD,2)+1:i*size(OD,2))*y_cost(1,1:size(OD,2))';
end
figure
title("Istogramma costi")
yyaxis left
bar((1:size(erogato,1))-0.2,transport_cost','BarWidth', 0.4)
yyaxis right
bar((1:size(erogato,1))+0.2,storage_cost','BarWidth', 0.4)
legend('Transport','Storage');

%%
figure;
ax_func=subplot(1,1,1);
ylabels{1}='Transport scale';
ylabels{2}='Storage scale';
ylabels{3}='Total scale';
x_to_plot=1:size(erogato,1);
integral = transport_cost+storage_cost;
for i=2:size(erogato,1)
    integral(i)=integral(i)+integral(i-1);
end
[ax,hlines] =plotyyy(x_to_plot,transport_cost,x_to_plot,storage_cost,x_to_plot,integral, ylabels,get(findall(ax_func,'type','axes'),'position'));
%legend(hlines, 'Transport cost','Storage cost','Total cost')
xlim([0.5, size(erogato,1)+0.5])
title("Costi comparazione")