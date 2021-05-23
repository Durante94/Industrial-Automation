clear all;
clc;
%%
Ac=[1 1
    0 1];
Bc=[0 1
   1 0];

Q=[0.0001 0
   0 0.00001];
R=0.001;

horizon=20;
sampleT=0.2;
t=0:sampleT:horizon;
nSample=length(t)-1;

sysc=ss(Ac,Bc, eye(2), zeros(1));
sysd=c2d(sysc, sampleT);

A=sysd.A;
B=sysd.B;

x(:,1)=[64
        -26];
u=zeros(2, nSample);

[K,P,e]=dlqr(A,B,Q,R);

for i=1:nSample
   u(:,i)=-K*x(:,i);
   x(:,i+1)=A*x(:,i)+B*u(:,i);
end

plot(t(1:nSample+1),x(1,:));
hold on;
plot(t(1:nSample+1),x(2,:));
hold off;