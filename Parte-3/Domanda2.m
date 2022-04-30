clear;
clc;
X=[40 30 50 80;
    50 25 75 100];
%% Current situation
subplot(2,2,1);
hold on
plot(reshape(X',1,[]),'Marker','o');
set(gca,'xtick',[0:4:12])
title('Current situation');
grid on
%% Year average
mean=zeros(1,2);
X_norm=zeros(2,4);
for i=1:2
    mean(i)=sum(X(i,:))/4; %computing the mean of the i-th year
    X_norm(i,:)=X(i,:)/mean(i); % dividing every season import by the mean of the year
end
%% Seasonal Indexes
Ind_stag=zeros(1,4);
for i=1:4
    Ind_stag(i)=sum(X_norm(:,i))/2; % 2 is the horizon (year) considered
end
subplot(2,2,3);
plot(Ind_stag);
set(gca,'xtick',[0:4:12]);
title('Seasonal Indexes');
grid on
%% Deseasonalizing Data
X_destag=zeros(2,4);
for i=1:2
    for j=1:4
        X_destag(i,j)=X(i,j)/Ind_stag(j);% smoothig by dividing the data with the respectively seasonal index
    end
end
%% Identification of the function interpolationg the historical series
X_destag_row = reshape(X_destag,1,[]);
subplot(2,2,2);
hold on;
plot(X_destag_row,'Marker','o');
params=polyfit(1:8,X_destag_row,1); % Identification
tModelled=polyval(params,1:12); % Evaluation of the previous function in all the season point needed
plot(1:12,tModelled);
trend_anno3=tModelled(9:12); % Regression for the 3rd year
set(gca,'xtick',[0:4:12])
title('Identified function')
grid on
%% Forecast 3rd year
for i=1:4
   X(3,i)=trend_anno3(i)*Ind_stag(i);
end
%% Final Plot
subplot(2,2,4);
hold on
plot(reshape(X',1,[]),'Marker','o');
plot(1:12,tModelled);
set(gca,'xtick',[0:4:12])
title('Prediction')
grid on