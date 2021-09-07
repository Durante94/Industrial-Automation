clc;
clear;
%% Data

X=[15 13 17 14 18 12 20 16 18 17];
Y=[16 14 18 15 19 14 22 16 20 18];
n=length(X);

%% Regression
sumY=0;
sumX=0;
sumXY=0;
sumX2=0;
sumY2=0;

% Computation of the sum of the samples values
for i=1:n
    sumY=sumY+Y(i);
    sumX=sumX+X(i);
    sumXY=sumXY+X(i)*Y(i);
    sumX2=sumX2+X(i)^2;
    sumY2=sumY2+Y(i)^2;
end

%Coefficients of our regression straight line
a0=(sumY*sumX2-sumX*sumXY)/(n*sumX2-sumX^2);
a1=(n*sumXY-sumX*sumY)/(n*sumX2-sumX^2);

c=(sumX*sumY2-sumY*sumXY)/(n*sumY2-sumY^2);
d=(n*sumXY-sumX*sumY)/(n*sumY2-sumY^2);

r=(a1*d)^0.5;

fprintf("Regrssion line: y = %d X + %d ", a1, a0);
%% Plotting
x=10:25;
plot(x, a1*x+a0);
hold on;
for i=1:n
    plot(X(i), Y(i), '--gs');
    hold on;
end
hold off;
