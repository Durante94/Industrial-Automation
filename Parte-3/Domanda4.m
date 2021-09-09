clear;
clc;

ema_num_columns = 4;

totale_old=table2array(readtable('TABELLE EROGATO.xlsx','Range','AZ2:BQ366'));
punto_vendita=table2array(readtable('TABELLE EROGATO.xlsx','Range','AZ1:BQ1'));
prodotti=["B95","B98","Dieseltech";
    "B95","B98","Dieseltech";
    "B95","B98","Dieseltech";
    "B95","B98","Dieseltech";
    "B95","B98","Dieseltech";
    "B95","B98","Dieseltech"];
price=zeros(size(prodotti,1),size(prodotti,2));%,size(totale,1));
[row,col]= find(prodotti=="B95");
price(row,col,:)=1.25;
[row,col]=find(prodotti=="B98");
price(row,col,:)=1.3;
[row,col]=find(prodotti=="Dieseltech");
price(row,col,:)=1.2;

totale=avoidCriticities(totale_old);

final_result=cell(3,size(prodotti,1)*size(prodotti,2));
index_pv=1;
for pv=1:size(prodotti,1)
    figure
    costo_autobotte = 0.5*punto_vendita(index_pv);
    
    index_pv_old = index_pv;    
    index_pv = index_pv+sum(price(pv,:)~=0);
   
    for product = index_pv_old:index_pv-1
        d=totale(:,product);
 
        matrice=zeros(size(totale,1),size(totale,1)+1);    
        for i=1:size(totale,1)
            for j=i+1:(size(totale,1)+1)            
                index = 1;
                giacenze = 0;
                lotto = d(i);
                for k=i+1:j-1
                    giacenze = giacenze+d(k)*index;
                    lotto = lotto+d(k);
                    index = index+1;
                end
                costo_giacenza = giacenze * 0.03 / 365 * price(pv,product+1-index_pv_old);                        
                costo_trasporto = ceil(lotto/39000)*costo_autobotte;
                matrice(i,j)= costo_giacenza+costo_trasporto;
            end
        end
        s=[];
        for i=1:size(totale,1)
            for j=i+1:(size(totale,1)+1)
                s= [s [i;j;matrice(i,j)]];
            end
        end
        G = digraph(s(1,:),s(2,:),s(3,:));
        [P,d] = shortestpath(G,1,size(totale,1)+1);
        subplot(5,ema_num_columns,(product+1-index_pv_old)*ema_num_columns+1);
        p = plot(G);
        highlight(p,P,'EdgeColor','r','LineWidth',2.2,'NodeColor','r')
        title(prodotti(pv,product+1-index_pv_old)+"        C: "+d);
        final_result{1,(pv-1)*size(prodotti,2)+product+1-index_pv_old}=P;
        final_result{2,(pv-1)*size(prodotti,2)+product+1-index_pv_old}=d;
        final_result{3,(pv-1)*size(prodotti,2)+product+1-index_pv_old}=size(P,2)-1;
        fprintf(sprintf("Stazione n* %i - Type %s\n", punto_vendita(index_pv_old), prodotti(pv,product+1-index_pv_old)));
        fprintf(sprintf("Numero ordini - %i\n", size(P,2)-1));
        fprintf("---------------\n");
    end
    trend=zeros(size(totale,1)+1,size(prodotti,2));
    time=ones(size(totale,1)+1,size(prodotti,2));
    time(1,:)=0;
    num_to_search=index_pv-index_pv_old;   
    for product=1:num_to_search
        P=final_result{1,(pv-1)*size(prodotti,2)+product};        
        index=3;
        for i=1:size(P,2)-1
            order=0;
            for j=P(1,i):P(1,i+1)-1
                if (j==size(totale,1)+1)
                    continue;
                end
                order=order+totale(j,product);
            end
            if order >0
                trend(index,product)=trend(index-1,product)+order;
                time(index,product)=time(index-1,product);
                index = index+1;
            end
            for j=P(1,i):P(1,i+1)-1
                 if (j==size(totale,1)+1)
                    continue;
                 end               
                trend(index,product)=trend(index-1,product)-totale(j,product);                
                time(index,product)=time(index-1,product)+1;
                index = index+1;
            end
        end        
    end       
    for i=1:num_to_search
        for j=size(time,1):-1:1
            if time(j,i)>0
                if j==size(time,1)
                    break
                end
                for k=j+1:size(time,1)
                    time(k,i)=time(k-1,i);
                    trend(k,i)=trend(k-1,i);
                end
                break
            end
        end
    end
    subplot(5,ema_num_columns,1:ema_num_columns);
    title("Livello magazzino "+punto_vendita(index_pv_old));
    hold on
    for i=1:num_to_search
        plot(time(:,i)',trend(:,i)');
        legend(prodotti(pv,:))
    end
    hold off
    storage=zeros(num_to_search,size(totale,1));
    transport=zeros(num_to_search,size(totale,1));

    for p=1:num_to_search        
        for j=2:size(time,1)
            if (time(j,p)==time(j-1,p)) && (time(j,p)<=size(totale,1))
                transport(p,time(j,p))=trend(j,p);                
                continue
            end            
            if time(j,p)<2
                continue
            end            
            storage(p,time(j,p)-1)=trend(j,p);            
        end
    end
    transport_cost=zeros(1,size(totale,1));
    storage_cost=zeros(1,size(totale,1));
    for i=1:size(transport,2)
        transport_cost(i)=sum(ceil(transport(:,i)/39000))*costo_autobotte;
        storage_cost(i)=price(pv,:)*storage(:,i)*0.03 / 365 ;
    end
    subplot(5,ema_num_columns,4*ema_num_columns+1:5*ema_num_columns);
    title("Istogramma costi")
    yyaxis left
    bar((1:size(totale,1))-0.2,transport_cost,'BarWidth', 0.4)
    yyaxis right
    bar((1:size(totale,1))+0.2,storage_cost','BarWidth', 0.4)
    legend('Transport','Storage');
    for i=1:num_to_search
        ax_func=subplot(5,ema_num_columns,i*ema_num_columns+2:(i+1)*ema_num_columns);
        transport_cost_prod=ceil(transport(i,:)/39000)*costo_autobotte;
        storage_cost_prod=price(pv,i)*storage(i,:)*0.03 / 365 ;
        integral = transport_cost_prod+storage_cost_prod;    
        for j=2:size(totale,1)
            integral(j)=integral(j)+integral(j-1);
        end  
        ylabels{1}='Transport';
        ylabels{2}='Storage';
        ylabels{3}='Total';
        x_to_plot=1:size(totale,1);
        [ax,hlines] =plotyyy(x_to_plot,transport(i,:),x_to_plot,storage(i,:),x_to_plot,integral, ylabels,get(findall(ax_func,'type','axes'),'position'));
     end
% end
end

cost=zeros(1,size(prodotti,1));
orders=zeros(1,size(prodotti,1));
cost_tot=zeros(size(prodotti,2),size(prodotti,1));
orders_tot=zeros(size(prodotti,2),size(prodotti,1));
for pv=1:size(prodotti,1)
    num_to_search=sum(price(pv,:)~=0);   
    for product = 1:num_to_search
        cost(1,pv)=cost(1,pv)+final_result{2,(pv-1)*size(prodotti,2)+product}/num_to_search;
        orders(1,pv)=orders(1,pv)+final_result{3,(pv-1)*size(prodotti,2)+product}/num_to_search;
        cost_tot(product,pv)=final_result{2,(pv-1)*size(prodotti,2)+product};
        orders_tot(product,pv)=final_result{3,(pv-1)*size(prodotti,2)+product};
    end
end
figure;
indexs=1:3:18;
subplot(2,2,1)
yyaxis left
plot(cost);
yyaxis right
plot(orders);
xticks(1:6)
xticklabels(punto_vendita(indexs))
title("1")
legend("mean cost","mean orders");
subplot(2,2,3)
yyaxis left
plot(cost_tot');
yyaxis right
plot(orders_tot');
xticks(1:6)
xticklabels(punto_vendita(indexs))
title("2")
legend("cost B95","cost B98","cost Dieseltech","orders B95","orders B98","orders Dieseltech");
cost=zeros(1,size(prodotti,2));
orders=zeros(1,size(prodotti,2));
for pv=1:size(prodotti,2)
    num_to_search=sum(price(:,pv)~=0);   
    for product = 1:num_to_search
        cost(1,pv)=cost(1,pv)+final_result{2,(product-1)*size(prodotti,2)+pv}/num_to_search;
        orders(1,pv)=orders(1,pv)+final_result{3,(product-1)*size(prodotti,2)+pv}/num_to_search;
    end
end
subplot(2,2,2);
yyaxis left
plot(cost);
yyaxis right
plot(orders);
title("3")
xticks(1:3)
xticklabels(prodotti(1,1:3))
legend("mean cost","mean orders");
subplot(2,2,4);
yyaxis left
plot(cost_tot);
yyaxis right
plot(orders_tot);
title("4")
xticks(1:3)
xticklabels(prodotti(1,1:3))
legend("cost 484","cost 489","cost 501","cost 502","cost 503","cost 504","orders 484","orders 489","orders 501","orders 502","orders 503","orders 504");