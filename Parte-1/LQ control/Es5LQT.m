clear all;
clc;
%%
Ac=[-0.1 0 0
    0 -0.1 1
    -0.1 0 1];
Bc=[1 0
    2 0
    0 1];

C=eye(3);
D=zeros(1);

horizon=20;
sampleT=0.5;
t=0:sampleT:horizon;
nSamp=length(t)-1;

z=[3*sin(1:nSamp+1)
   -5*sin(2*(1:nSamp+1))
   sin(1:nSamp+1)];

sysC=ss(Ac,Bc,C,D);
sysD=c2d(sysC, sampleT);

A=sysD.A;
B=sysD.B;
Q=[1000 0 0
   0 1000 0
   0 0 10000000];
Qf=Q;
R=[0.01 0
   0 0.0001];

[P, K]=p_riccati(A,B,Q,Qf,R,nSamp);

[g, Lg]=Lg_xLQT(A, B, sysD.C, Q, Qf, R, nSamp, P, z);

x(:,1)=[5 -12 9.5]';
u=zeros(2, nSamp-1);

for i=1:nSamp
    u(:,i)=-K(:,:,i)*x(:,i)+Lg(:,:,i)*g(:,:,i);
    x(:,i+1)=A*x(:,i)+B*u(:,i);
end

subplot(5,1,1);
plot(t(1:nSamp+1), x(1,:));
hold on;
plot(t(1:nSamp+1), z(1,:));
hold off;
xlabel('Time');
ylabel('x1');
title('State1');
legend('x1','z1');

subplot(5,1,2);
plot(t(1:nSamp+1), x(2,:));
hold on;
plot(t(1:nSamp+1), z(2,:));
hold off;
xlabel('Time');
ylabel('x2');
title('State2');
legend('x2','z2');

subplot(5,1,3);
plot(t(1:nSamp+1), x(3,:));
hold on;
plot(t(1:nSamp+1), z(3,:));
hold off;
xlabel('Time');
ylabel('x3');
title('State3');
legend('x3','z3');

subplot(5,1,4);
plot(t(1:nSamp), u(1,:));
xlabel('Time');
ylabel('u1');
title('Control1');
legend('u1');

subplot(5,1,5);
plot(t(1:nSamp), u(2,:));
xlabel('Time');
ylabel('u2');
title('Control2');
legend('u2');