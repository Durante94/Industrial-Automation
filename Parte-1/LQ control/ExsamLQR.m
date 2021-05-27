clear all;
clc;
%%
A=[3 0 0
   0 -1 1
   -1 1 0];
B=[-1 0
    0 0
    0 1];
C=eye(3);
D=zeros(3,2);

Q=[100 0 0
   0 0.1 0
   0 0 0.01];
R=1;

horizon=20;
sampleT=0.1;
t=0:sampleT:horizon;
nSamples=length(t)-1;

sysc=ss(A,B,C,D);
sysd=c2d(sysc,sampleT);

A=sysd.A;
B=sysd.B;

x(:,1)=[20 -15 6.6]';
u=zeros(2, nSamples);

[K,P,e]=dlqr(A,B,Q,R);

for i=1:nSamples
   u(:,i)=-K*x(:,i);
   x(:,i+1)=A*x(:,i)+B*u(:,i);
end

plot(t, x(1,:));
hold on;
plot(t, x(2,:));
hold on;
plot(t, x(3,:));
hold off;