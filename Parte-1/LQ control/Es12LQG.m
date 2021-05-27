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

Q=[0.01 0 0
   0 10 0
   0 0 1];
R=0.01;
Qf=Q;

horizon=100;
sampleT=1;
t=0:sampleT:horizon;
nSamples=length(t)-1;

mucsi=[0.1 0.1 0.1];
mueta=0;

Qv=[0.1 0 0
    0 0.1 0
    0 0 0.1];
Rv=0.1;

alpha=[0 0.6 0.3]';
sigma0=[0.1 0 0
        0 0.1 0
        0 0 0.1];

sysc=ss(A,B,C,D);
sysd=c2d(sysc,sampleT);

A=sysd.A;
B=sysd.B;

rng default;
csi=mvnrnd(mucsi, Qv, nSamples)';
eta=mvnrnd(mueta, Rv, nSamples)';

[P,K]=p_riccati(A,B,Q,Qf,R,nSamples);

[kKalman]=mykalman(A,C,Qv,Rv,alpha,sigma0,nSamples);

u=zeros(2, nSamples);
y=zeros(3, nSamples+1);
x(:,1)=[10 -15 6]';
y(:,1)=C*x(:,1)+eta(:,1);
mu(:,1)=alpha+kKalman(:,:,1)*(y(:,1)-C*alpha);

for i=1:nSamples
   u(:,i)=-K(:,:,i)*mu(:,i);
   x(:,i+1)=A*x(:,i)+B*u(:,i)+csi(:,i);
   y(:,i+1)=C*x(:,i+1)+eta(:,i);
   mu(:,i+1)=A*mu(:,i)+B*u(:,i)+kKalman(:,:,i)*(y(:,i)-C*(A*mu(:,i)+B*u(:,i)));
end

subplot(3,1,1);
plot(t(1:nSamples+1),x(1,:));
hold on;
plot(t(1:nSamples+1),mu(1,:));
hold off;
title('State1');
legend('Actual','Kalman estimation');
xlabel('Time');
ylabel('Reaction');

subplot(3,1,2);
plot(t(1:nSamples+1),x(2,:));
hold on;
plot(t(1:nSamples+1),mu(2,:));
hold off;
title('State2');
legend('Actual','Kalman estimation');
xlabel('Time');
ylabel('Temperature');

subplot(3,1,3);
plot(t(1:nSamples),u);
title('Control');
legend('u');
xlabel('Time');
ylabel('Cooling rate');
