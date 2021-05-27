clear;
clc;
%%
Ac=[-0.1 0 0
    0 -0.1 1
    -0.1 0 1];
Bc=[1 0
    2 0
    0 1];
C=eye(3);
D=zeros(3, 2);

Q=[0.1 0 0
   0 0.1 0
   0 0 0.1];
R=0.001;

horizon=50;
sampleT=0.5;
t=0:sampleT:horizon;
nSamples=length(t)-1;

sysc=ss(Ac,Bc,C,D);
sysd=c2d(sysc,sampleT);

A=sysd.A;
B=sysd.B;

x(:,1)=[15, -6, 4.6]';
u=zeros(2,nSamples);

[K,P,e]=dlqr(A,B,Q,R);

for i=1:nSamples
   u(:,i)=-K*x(:,i);
   x(:,i+1)=A*x(:,i)+B*u(:,i);
end

plot(t(1,:),x(1,:));
hold on;
plot(t(1,:), x(2,:));
hold on;
plot(t(1,:), x(3,:));
hold off;