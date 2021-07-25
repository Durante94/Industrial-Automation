clear;
clc;
%%
A=[1 1
   0 1];
B=[0 1
   1 0];
C=eye(2);
D=zeros(2);

Q=[0.00001 0
   0 10000];
R=0.01;

horizon=20;
sampleT=0.5;
t=0:sampleT:horizon;
nSamples=length(t)-1;

sysc=ss(A,B,C,D);
sysd=c2d(sysc,sampleT);

A=sysd.A;
B=sysd.B;

[K,P,e]=dlqr(A,B,Q,R);

x(:,1)=[-15, 26]';
u=zeros(2,nSamples);

for i=1:nSamples
    u(:,i)=-K*x(:,i);
    x(:,i+1)=A*x(:,i)+B*u(:,i);
end

plot(t, x(1,:));
hold on;
plot(t, x(2,:));
hold off;