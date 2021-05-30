clear all;
clc;
%%
A=[1 1
   0 1];
B=[0 1
   1 0];
C=eye(2);
D=zeros(1);

Q=[100 0
   0 1];
R=0.01;
Qf=Q;

horizon=10;
sampleT=0.5;
t=0:sampleT:horizon;
nSamples=length(t)-1;

sysc=ss(A,B,C,D);
sysd=c2d(sysc, sampleT);

A=sysd.A;
B=sysd.B;
C=sysd.C;

x(:,1)=[56.3, -33.15]';
u=zeros(2, nSamples);

[P, K]=pk_riccati_output(A, B, C, Q, Qf, R, nSamples);

z=[5*sin(t(1:nSamples+1))
   -3*sin(3*t(1:nSamples+1))];

[g, Lg]=Lg_xLQT(A,B,C,Q,Qf,R,nSamples,P,z);

for i=1:nSamples
   u(:,i)=-K(:,:,i)*x(:,i)+Lg(:,:,i)*g(:,:,i);
   x(:,i+1)=A*x(:,i)+B*u(:,i);
end

subplot(4,1,1);
plot(t(1:nSamples+1), x(1,:));
hold on;
plot(t(1:nSamples+1), z(1,:));
hold off;
title('Stato 1');
xlabel('Tempo');
ylabel('Input 1');
legend('x1', 'z1');

subplot(4,1,2);
plot(t(1:nSamples+1), x(2,:));
hold on;
plot(t(1:nSamples+1), z(2,:));
hold off;
title('Stato 2');
xlabel('Tempo');
ylabel('Input 2');
legend('x2', 'z2');

subplot(4,1,3);
plot(t(1:nSamples), u(1,:));
title('Controllo 1');
xlabel('Tempo');
ylabel('Controllo 1');
legend('u1');

subplot(4,1,4);
plot(t(1:nSamples), u(2,:));
title('Controllo 2');
xlabel('Tempo');
ylabel('Controllo 2');
legend('u2');