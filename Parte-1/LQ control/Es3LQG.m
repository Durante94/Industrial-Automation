clear all;
clc
%%
Ac=[3 0 0
    0 -1 1
    -1 1 0];
Bc=[-1 0
    0 0
    0 1];

Cc=[1 2 3];
Dc=[5, 2];

horizion=100;
sampleT=1;

t=0:sampleT:horizion;
nSamp=length(t)-1;

sysc=ss(Ac,Bc,Cc,Dc);
sysd=c2d(sysc, sampleT);

A=sysd.A;
B=sysd.B;

Q=[10 0 0
   0 1 0
   0 0 0.1];
Qf=Q;
R=0.1;

u=zeros(2, nSamp-1);
y=zeros(1, nSamp-1);

mucsi=[0 0 0];
Qv=[0.1 0 0
    0 0.1 0
    0 0 0.1];
mueta=0;
Rv=0.1;

rng default;
csi=mvnrnd(mucsi, Qv, nSamp)';
eta=mvnrnd(mueta, Rv, nSamp+1)';

[P,K]=p_riccati(A,B,Q,Qf,R,nSamp);
alpha=[0
       0
       0];
sigma0=1;

[Kkalman]=mykalman(A,sysd.C,Qv,Rv,alpha,sigma0,nSamp);

x0=[9 -6 1]';
y0=sysd.C*x0+eta(:,1);
mu0=alpha+Kkalman(:,:,1)*(y0-sysd.C*alpha);
x(:,1)=x0;
mu(:,1)=mu0;

for i=1:nSamp
   u(:,i)=-K(:,:,i)*mu(:,i);
   x(:,i+1)=A*x(:,i)+B*u(:,i)+csi(:,i);
   y(:,i+1)=sysd.C*x(:,i+1)+eta(:,i+1);
   mu(:,i+1)=A*mu(:,i)+B*u(:,i)+...
   Kkalman(:,:,i+1)*(y(:,i+1)-sysd.C*(A*mu(:,i)+B*u(:,i)));
end

subplot(4,1,1);
plot(t(1:nSamp+1),x(1,:));
hold on;
plot(t(1:nSamp+1),mu(1,:));
hold off;
title('State1');
legend('Actual','Kalman estimation');
xlabel('Time');
ylabel('Reaction');

subplot(4,1,2);
plot(t(1:nSamp+1),x(2,:));
hold on;
plot(t(1:nSamp+1),mu(2,:));
hold off;
title('State2');
legend('Actual','Kalman estimation');
xlabel('Time');
ylabel('Temperature');

subplot(4,1,3);
plot(t(1:nSamp+1),x(3,:));
hold on;
plot(t(1:nSamp+1),mu(3,:));
hold off;
title('State2');
legend('Actual','Kalman estimation');
xlabel('Time');
ylabel('Temperature');

subplot(4,1,4);
plot(t(1:nSamp),u);
title('Control');
legend('t');
legend('u');
xlabel('Time');
ylabel('Cooling rate');
