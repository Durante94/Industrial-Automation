clear all;
clc;
%%
Ac=[-0.1 0 0
    0 -0.1 1
    -0.1 0 1];
Bc=[1 0
    2 0
    0 1];

horizon=100;
sampleT=1;
t=0:sampleT:horizon;
nSamp=length(t)-1;

sysC=ss(Ac, Bc, eye(3), zeros(1));
sysd=c2d(sysC, sampleT);

A=sysd.A;
B=sysd.B;

Q=eye(3);
R=100;

[K, P, e]=dlqr(A, B, Q, R);

x(:,1)=[100, 25, -63]';
u=zeros(2, nSamp);

for i=1:nSamp
    u(:,i)=-K*x(:,i);
    x(:,i+1)=A*x(:,i)+B*u(:,i);
end

plot(t(1:nSamp+1),x(1,:));
hold on;
plot(t(1:nSamp+1),x(2,:));
hold on;
plot(t(1:nSamp+1), x(3,:));
hold off;