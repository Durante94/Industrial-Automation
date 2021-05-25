clear all;
clc;
%%
A=[1 1
   0 1];
B=[0 1
   1 0];
C=[1 0
   1 0];
D=zeros(1);

Q=[10 0
   0.01 0];
Qf=Q;
R=[10 0
   0 0.001];

horizon=100;
sampleT=0.5;
t=0:sampleT:horizon;
nSamples=length(t)-1;

mucsi=[0 0];
mueta=[0 0];
Qv=[1000 0
    0 0.0001];
Rv=[0.5 0
    0 0.5];

alpha=[0 0]';
sigma0=[1 0
        0 1];

sysc=ss(A,B,C,D);
sysd=c2d(sysc, sampleT);

A=sysd.A;
B=sysd.B;

rng default;
csi=mvnrnd(mucsi,Qv,nSamples)';
eta=mvnrnd(mueta,Rv,nSamples+1)';

[P,K]=p_riccati(A,B,Q,Qf,R,nSamples);

[kKalman]=mykalman(A,C,Qv,Rv,alpha,sigma0,nSamples);

x(:,1)=[33 -14]';
y(:,1)=C*x(:,1)+eta(:,1);
mu(:,1)=alpha+kKalman(:,:,1)*(y(:,1)-C*alpha);
u=zeros(2,nSamples);

for i=1:nSamples
    u(:,i)=-K(:,:,i)*mu(:,i);
    x(:,i+1)=A*x(:,i)+B*u(:,i)+csi(:,i);
    y(:,i+1)=C*x(:,i+1)+eta(:,i+1);
    mu(:,i+1)=A*mu(:,i)+B*u(:,i)+kKalman(:,:,1)*(y(:,1)-C*(A*mu(:,i)+B*u(:,i)));
end

subplot(4,1,1);
plot(t(1:nSamples+1),x(1,:));
hold on;
plot(t(1:nSamples+1),mu(1,:));
hold off;
title('State1');
legend('Actual','Kalman estimation');
xlabel('Time');
ylabel('Reaction');

subplot(4,1,2);
plot(t(1:nSamples+1),x(2,:));
hold on;
plot(t(1:nSamples+1),mu(2,:));
hold off;
title('State2');
legend('Actual','Kalman estimation');
xlabel('Time');
ylabel('Temperature');

subplot(4,1,3);
plot(t(1:nSamples),u(1,:));
title('Control');
legend('u');
xlabel('Time');
ylabel('Cooling rate');

subplot(4,1,4);
plot(t(1:nSamples),u(2,:));
title('Control');
legend('u');
xlabel('Time');
ylabel('Cooling rate');