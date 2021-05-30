clc;
clear;
%%

Ac=[3 0 0
   0 -1 1
   -1 2 0];
Bc=[1 0 
   0 0
   0 1];

Q=[10 0 0
    0 0.001 0
    0 0 0.01];
R=[100 0
    0 1];

sampleTime=0.1;

sysc=ss(Ac,Bc, eye(3), zeros(3,2));
sysd=c2d(sysc, sampleTime);

Ad=sysd.A;
Bd=sysd.B;

t=0:sampleTime:100;
nSample=length(t)-1;

x(:,1)=[10 -5 3]';
u=zeros(2, nSample);

[K, P, e]=dlqr(Ad, Bd, Q, R);

for i=1:nSample
    u(:,i)=-K*x(:,i);
    x(:,i+1)=Ad*x(:,i)+Bd*u(:,i);
end

plot(t(1:nSample+1),x(1,:));
hold on;
plot(t(1:nSample+1),x(2,:));
hold on;
plot(t(1:nSample+1),x(3,:));
hold off;