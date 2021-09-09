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
%     s_old=s;
%     t_old=t;
%     w1_old=w1;
%     w2_old=w2;
%     p1_old=p1;
%     p2_old=p2;
%     
%     for ch=1:size(changes,1)
%         change_deposit_with=changes(ch,2);
%         deposit=changes(ch,1);
%         for i=1:size(s,2)
%             found = false;
%             if s(i)==deposit
%                 found=true;
%                 temp_s=change_deposit_with;
%                 temp_t=t(i);
%                 if temp_t==change_deposit_with
%                     temp_t=deposit;
%                 end
%             elseif s(i)==change_deposit_with
%                 found=true;
%                 temp_s=deposit;
%                 temp_t=t(i);
%                 if temp_t==deposit
%                     temp_t=change_deposit_with;
%                 end
%             end
%             if found==false
%                 if t(i)==deposit
%                     found=true;
%                     temp_t=change_deposit_with;
%                     temp_s=s(i);
%                     if temp_s==change_deposit_with
%                         temp_s=deposit;
%                     end
%                 elseif t(i)==change_deposit_with
%                     found=true;
%                     temp_t=deposit;
%                     temp_s=s(i);
%                     if temp_s==deposit
%                         temp_s=change_deposit_with;
%                     end
%                 end
%             end
%             if found==true
%                 for j=i+1:size(s,2)
%                     if s(j)==temp_s && t(j)==temp_t
%                         temp=s(i);
%                         s(i)=s(j);
%                         s(j)=temp;
% 
%                         temp=t(i);
%                         t(i)=t(j);
%                         t(j)=temp;
% 
% %                         temp=w1(:,i);
% %                         w1(:,i)=w1(:,j);
% %                         w1(:,j)=temp;
% % 
% %                         temp=w2(:,i);
% %                         w2(:,i)=w2(:,j);
% %                         w2(:,j)=temp;
% % 
% %                         temp=p1(:,i);
% %                         p1(:,i)=p1(:,j);
% %                         p1(:,j)=temp;
% % 
% %                         temp=p2(:,i);
% %                         p2(:,i)=p2(:,j);
% %                         p2(:,j)=temp;
% % 
%                         break
%                     end
%                 end
%             end
%         end
%         temp=names(deposit);
%         names(deposit)=names(change_deposit_with);
%         names(change_deposit_with)=temp;
%     end
%     for i=1:size(s,2)
%         for j=1:size(s,2)
%             if s(i)==s_old(j) && t(i)==t_old(j)
%                 w1(:,i)=w1_old(:,j);
%                 w2(:,i)=w2_old(:,j);
%                 p1(:,i)=p1_old(:,j);
%                 p2(:,i)=p2_old(:,j);
%                 break
%             end
%         end
%     end
end