clear all;
clc;

%% 5)	Show examples with noise on the system, and on the measure of the state, 
%       also taken into account an output y=Cx where C may also be a singular matrix or rectangular.

% Continuous time system

Ac = [-0.1 -0.12
    -0.3 -0.012];
Bc = [0 
    -0.07];  

% C as a singular matrix
% C = [3 6
%      1 2];
% D = zeros(2, 1);

% C as a rectangular matrix
C = [10 1];
D = zeros(1, 1);


horizon = 100;
sampleTime = 0.1;
t = 0:sampleTime:horizon;
N = length(t)-1;
sysc = ss(Ac,Bc,C,D);
sysd = c2d(sysc,sampleTime);

Ad = sysd.A;
Bd = sysd.B;

Q = [1000 0
     0 0.0001];
Qf = Q; % cost of the state
R = 0.01; % cost of the control
u = zeros(1,N-1);
y = zeros(1,N-1); % y when C is rectangular
% y = zeros(2,N-1); % y when C is singular

mucsi = [0 0]; % mean noise of input
Qv = [0.1 0
      0 0.1]; % covariance noise of input
mueta = 0; % mean noise of output
Rv = 0.1; % covariance noise of output
rng default  % For reproducibility
csi = mvnrnd(mucsi,Qv,N)'; % generates random input noise
eta = mvnrnd(mueta,Rv,N+1)'; % generates random output noise

% P and K matrices obtained from the Riccati equation
[P, K] = p_riccati(Ad, Bd, Q, Qf, R, N);
alfa = [0 0]'; % mean initial state
sigma0 = [1 0
          0 1]; % covariance initial state
      
% K of Kalman matrix obtained from this function
[Kkalman] = mykalman(Ad,C,Qv,Rv,alfa,sigma0,N);
x0 = [10 -2]';
y0 = C*x0+eta(:,1);
mu0 = alfa+Kkalman(:,:,1)*(y0-C*alfa);
x(:,1) = x0;
mu(:,1) = mu0;

for i=1:N
    % Optimal control
    u(:,i) = -K(:,:,i)*mu(:,i);
    
    % Next input
    x(:,i+1) = Ad*x(:,i) + Bd*u(:,i)+csi(:,i);
    
    % Next output
    y(:,i+1) = C*x(:,i+1) + eta(:,i+1);
    
    % Next Kalman computation
    mu(:,i+1) = Ad*mu(:,i) + Bd*u(:,i)+...
    Kkalman(:,:,i+1)*(y(:,i+1) - C*(Ad*mu(:,i) + Bd*u(:,i)));
    
end

% Plot of the Kalman estimation

subplot(3,1,1);
plot(t(1:N+1),x(1,:));
hold on;
plot(t(1:N+1),mu(1,:));
hold off;
title('State1');
legend('Actual','Kalman estimation');
xlabel('Time');
ylabel('Reaction');

subplot(3,1,2);
plot(t(1:N+1),x(2,:));
hold on;
plot(t(1:N+1),mu(2,:));
hold off;
title('State2');
legend('Actual','Kalman estimation');
xlabel('Time');
ylabel('Temperature');

subplot(3,1,3);
plot(t(1:N),u);
title('Control');
legend('u');
xlabel('Time');
ylabel('Cooling rate');
