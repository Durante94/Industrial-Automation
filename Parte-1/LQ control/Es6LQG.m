clear all;
clc
%%
Ac=[-0.1 0 0
    0 -0.1 1
    -0.1 0 1];
Bc=[1 0
    2 0
    0 1];

Q=eye(3);
Qf=Q;
R=0.01;

sampleT=0.5;
horizon=60;
t=0:sampleT:horizon;
nSample=length(t)-1;

mucsi=[0 0 0];
mueta=[0 0 0];

Qv=diag([0.1 0.1 0.1]);
Rv=diag([0.01 0.01 0.01]);

alpha=[0 0 0]';
sigma0=eye(3);

sysc=ss(Ac, Bc, eye(3), zeros(1));
sysd=c2d(sysc,sampleT);

A=sysd.A;
B=sysd.B;

rng default;
csi=mvnrnd(mucsi, Qv, nSample)';
eta=mvnrnd(mueta, Rv, nSample+1)';

[P, K]=p_riccati(A, B, Q, Qf, R, nSample);

[kKalman]=mykalman(A, sysd.C, Qv, Rv, alpha, sigma0, nSample);

x(:,1)=[20, -31.6, 15]';
u=zeros(2, nSample);
y(:,1)=sysd.C*x(:,1)+eta(:,1);
mu(:,1)=alpha+kKalman(:,:,1)*(y(:,1)-sysd.C*alpha);

for i=1:nSample
   u(:,i)=-K(:,:,i)*mu(:,i);
   x(:,i+1)=A*x(:,i)+B*u(:,i)+csi(:,i);
   y(:,i+1)=sysd.C*x(:,i+1)+eta(:,i+1);
   mu(:,i+1)=A*mu(:,i)+B*u(:,i)+kKalman(:,:,i)*(y(:,i)-sysd.C*(A*mu(:,i)+B*u(:,i)));
end

subplot(5,1,1);
plot(t(1:nSample+1),x(1,:));
hold on;
plot(t(1:nSample+1),mu(1,:));
hold off;
title('State1');
legend('Actual','Kalman estimation');
xlabel('Time');
ylabel('Reaction');

subplot(5,1,2);
plot(t(1:nSample+1),x(2,:));
hold on;
plot(t(1:nSample+1),mu(2,:));
hold off;
title('State2');
legend('Actual','Kalman estimation');
xlabel('Time');
ylabel('Temperature');

subplot(5,1,3);
plot(t(1:nSample+1),x(3,:));
hold on;
plot(t(1:nSample+1),mu(3,:));
hold off;
title('State3');
legend('Actual','Kalman estimation');
xlabel('Time');
ylabel('Temperature');

subplot(5,1,4);
plot(t(1:nSample),u(1,:));
title('Control');
legend('u');
xlabel('Time');
ylabel('Cooling rate');

subplot(5,1,5);
plot(t(1:nSample),u(2,:));
title('Control');
legend('u');
xlabel('Time');
ylabel('Cooling rate');
