function[s,t,w1,w2,p1,p2,names]=graphRoutingPreprocessing(s,t,w1_old,w2_old,p1_old,p2_old,names,changes)        
    s=s+1;
    t=t+1;
    names_old=names;
    for ch=1:size(changes,1)
        temp=names(changes(ch,1));
        names(changes(ch,1))=names(changes(ch,2));
        names(changes(ch,2))=temp;
    end
    w1=zeros(size(w1_old));
    w2=zeros(size(w2_old));
    p1=zeros(size(p1_old));
    p2=zeros(size(p2_old));
    for i=1:size(w1_old,1)
        for j=1:size(w1_old,2)
            if w1_old(i,j)>0
                for k=1:size(names,1)
                    if names(k,1)==names_old(s(1,j),1)
                        s_index=k;
                    end
                    if names(k,1)==names_old(t(1,j),1)
                        t_index=k;
                    end
                end                
                for k=1:size(w1_old,2)
                    if s(1,k)==s_index && t(1,k)==t_index
                        w1(i,k)=w1_old(i,j);
                        break
                    end
                end
            end        
            %%
            if w2_old(i,j)>0
                for k=1:size(names,1)
                    if names(k,1)==names_old(s(1,j),1)
                        s_index=k;
                    end
                    if names(k,1)==names_old(t(1,j),1)
                        t_index=k;
                    end
                end                
                for k=1:size(w1_old,2)
                    if s(1,k)==s_index && t(1,k)==t_index
                        w2(i,k)=w2_old(i,j);
                        break
                    end
                end
            end   
            %%
             if p1_old(i,j)>0
                for k=1:size(names,1)
                    if names(k,1)==names_old(s(1,j),1)
                        s_index=k;
                    end
                    if names(k,1)==names_old(t(1,j),1)
                        t_index=k;
                    end
                end                
                for k=1:size(w1_old,2)
                    if s(1,k)==s_index && t(1,k)==t_index
                        p1(i,k)=p1_old(i,j);
                        break
                    end
                end
            end        
            %%
            if p2_old(i,j)>0
                for k=1:size(names,1)
                    if names(k,1)==names_old(s(1,j),1)
                        s_index=k;
                    end
                    if names(k,1)==names_old(t(1,j),1)
                        t_index=k;
                    end
                end                
                for k=1:size(w1_old,2)
                    if s(1,k)==s_index && t(1,k)==t_index
                        p2(i,k)=p2_old(i,j);
                        break
                    end
                end
            end   
            
        end
    end
end