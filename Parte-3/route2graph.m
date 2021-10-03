function[]=route2graph(s,t,w1,w2,p1,p2,nodetable,count,pvs)
    subplot(1,2,1)
    G1=digraph(s,t,w1,nodetable);    
    h1 = plot(G1,'EdgeLabel',G1.Edges.Weight,'LineStyle','-.','NodeFontSize',12);
    title("Viaggi con serbatoio1 pieno - Giorno: "+count);
    subplot(1,2,2)
    G2=digraph(s,t,w2,nodetable);   
    h2 = plot(G2,'EdgeLabel',G2.Edges.Weight,'LineStyle','-.','NodeFontSize',12);
    title("Viaggi con serbatoio2 pieno - Giorno: "+count);
    for i=1:size(s,2)
        if p1(i)>0
            P=[];
            if i<=pvs
                P=[1,i+1];        
            elseif i>size(s,2)-pvs
                P=[i-(size(s,2)-pvs)+1, 1];
            else
                j=floor((i-pvs-1)/(pvs-1))+1;
                k=(i-pvs)-(j-1)*(pvs-1);
                if k>=j
                    k=k+1;
                end
                P=[j+1 k+1];
            end
            highlight(h1,P,'EdgeColor','r','LineWidth',2.2,'EdgeLabel','r','LineStyle','-','ArrowSize',15,'EdgeFontSize',12)    
        end
        if p2(i)>0
            P=[];
            if i<=pvs
                P=[1,i+1];        
            elseif i>size(s,2)-pvs
                P=[i-(size(s,2)-pvs)+1, 1];
            else
                j=floor((i-pvs-1)/(pvs-1))+1;
                k=(i-pvs)-(j-1)*(pvs-1);
                if k>=j
                    k=k+1;
                end
                P=[j+1 k+1];
            end
            highlight(h2,P,'EdgeColor','r','LineWidth',2.2,'EdgeLabel','r','LineStyle','-','ArrowSize',15,'EdgeFontSize',12)    
        end
    end
end