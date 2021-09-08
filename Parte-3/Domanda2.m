clear;
clc;
X=[40 30 50 80;
    50 25 75 100];
%% Situazione iniziale
subplot(2,2,1);
hold on
plot(reshape(X',1,[]),'Marker','o');
set(gca,'xtick',[0:4:12])
grid on
%% Media annuale
mean=zeros(1,2);
X_norm=zeros(2,4);
for i=1:2
    mean(i)=sum(X(i,:))/4;
    X_norm(i,:)=X(i,:)/mean(i);
end
%% Indici stagionali
Ind_stag=zeros(1,4);
for i=1:4
    Ind_stag(i)=sum(X_norm(:,i))/2;
end
subplot(2,2,3);
plot(Ind_stag);
set(gca,'xtick',[0:4:12]);
grid on
%% X destagionalizzata
X_destag=zeros(2,4);
for i=1:2
    for j=1:4
        X_destag(i,j)=X(i,j)/Ind_stag(j);
    end
end
%% Regressione
X_destag_row = reshape(X_destag,1,[]);
subplot(2,2,2);
hold on;
plot(X_destag_row,'Marker','o');
params=polyfit(1:8,X_destag_row,1);
tModelled=polyval(params,1:12);
plot(1:12,tModelled);
trend_anno3=tModelled(9:12);
set(gca,'xtick',[0:4:12])
grid on
%% Previsione anno 3
for i=1:4
   X(3,i)=trend_anno3(i)*Ind_stag(i);
end
%% Plot finale
subplot(2,2,4);
hold on
plot(reshape(X',1,[]),'Marker','o');
plot(1:12,tModelled);
set(gca,'xtick',[0:4:12])
grid on