clc;
clear;
%%

Ac=[3 0 -1
    0 -1 1
    -1 1 0];
Bc=[-1 0
    0 0
    0 -1];

sampleTime=0.1;

Cc=eye(3);
Dc=zeros(3,2);

sys=ss(Ac, Bc, Cc, Dc);
sysd=c2d(sys, sampleTime);

A=sysd.A;
B=sysd.B;

Q=[100 0 0
    0 10 0
    0 0 1000];
Qf=Q;

R=0.0001;

horizon=50;
t=0:sampleTime:horizon;

nSample=length(t)-1;

[P, K]=pk_riccati_output(A,B,sysd.C, Q,Qf,R,nSample);

z=[sin(1:nSample+1)
   5*sin(1:nSample+1)
   -2*sin(1:nSample+1)];

[g, Lg]=Lg_xLQT(A,B,sys.C,Q,Qf,R,nSample,P,z);

x(:,1)=[-5
       2
       6];
u=zeros(2, nSample-1);

for i=1:nSample
   u(:,i)=-K(:,:,i)*x(:,i)+Lg(:,:,i)*g(:,:,i+1);
   x(:,i+1)=A*x(:,i)+B*u(:,i);
end

subplot(4,1,1)
plot(t(1:nSample+1),x(1,:));
hold on;
plot(t(1:nSample+1),z(1,:));
title('State1');
legend('x1','z1');
xlabel('Time');
ylabel('Reaction');

subplot(4,1,2)
plot(t(1:nSample+1),x(2,:));
hold on;
plot(t(1:nSample+1),z(2,:));
title('State2');
legend('x2','z2');
xlabel('Time');
ylabel('Reaction');

subplot(4,1,3)
plot(t(1:nSample+1),x(3,:));
hold on;
plot(t(1:nSample+1),z(3,:));
title('State3');
legend('x3','z3');
xlabel('Time');
ylabel('Reaction');

subplot(4,1,4)
plot(t(1:nSample),u);
title('Control');
legend('u');
xlabel('Time');
ylabel('Control');