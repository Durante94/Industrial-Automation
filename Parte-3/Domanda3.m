clear;
clc;

costo_ordiazione=80;
prezzo = 25;
costo_mantenimento=prezzo*0.18/6;
d=[80,100,50,60];

f=[prezzo, prezzo, prezzo, prezzo, ...
    costo_mantenimento, costo_mantenimento, costo_mantenimento,costo_mantenimento,...
    costo_ordiazione,costo_ordiazione,costo_ordiazione,costo_ordiazione];
intcon =[9 10 11 12];
A=[1 0 0 0      0 0 0 0     -(80+100+50+60) 0 0 0;
      0 1 0 0      0 0 0 0      0 -(100+50+60) 0 0;
      0 0 1 0      0 0 0 0      0 0 -(50+60) 0;
      0 0 0 1      0 0 0 0      0 0 0 -(60)];
B=[0;0;0;0];
Aeq=[-1 0 0 0      1 0 0 0      0 0 0 0
         0 -1 0 0      -1 1 0 0      0 0 0 0
         0 0 -1 0      0 -1 1 0      0 0 0 0
         0 0 0 -1      0 0 -1 1      0 0 0 0
         0 0 0 0      0 0 0 1      0 0 0 0]; 
Beq=[-80;-100;-50;-60;0];
lb=[0 0 0 0      0 0 0 0      0 0 0 0];
ub=[Inf Inf Inf Inf      Inf Inf Inf Inf      1 1 1 1];

[x,fval,exitflag,output] = intlinprog(f,intcon,A,B,Aeq,Beq,lb,ub);

x=x';

q=round(x(1:4));
s=round(x(5:8));
y=round(x(9:12));

start=[];
target=[];
weight=[];

for i=1:4
    start = [start i+1];
    target= [target 5+i];
    weight = [weight d(i)];
    if y(i)==1
        start = [start 1];
        target = [target i+1];
        weight = [weight q(i)];               
    else
        start = [start i];
        target = [target i+1];
        weight = [weight s(i-1)];        
    end        
end

figure
G=digraph(start,target,weight,["DEPOSITO","1","2","3","4","1-fin","2-fin","3-fin","4-fin"]);    
h=plot(G,'EdgeLabel',G.Edges.Weight,'LineWidth',2.2,'LineStyle','-','ArrowSize',12,'EdgeFontSize',12,'NodeFontSize',12);
layout(h,'layered','Direction','down','Sources',[1],'Sinks',[6:9])