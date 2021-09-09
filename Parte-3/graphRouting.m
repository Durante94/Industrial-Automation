function[]=graphRouting(s_old,t_old,w1_old,w2_old,p1_old,p2_old,pvs,names)
    [s,t,w1,w2,p1,p2,names ]=graphRoutingPreprocessing(s_old,t_old,w1_old,w2_old,p1_old,p2_old,names,[1,5;6,7;1,7]);
    count = 1;
    nodetable=table(names,'VariableNames',{'Name'});
    figure
    route2graph(s,t,w1(count,:),w2(count,:),p1(count,:),p2(count,:),nodetable,count,pvs);
    hb1 = uicontrol('Style', 'PushButton', 'String', 'Next', ...
      'Callback', @NextBtnCB);
    hb2 = uicontrol('Style', 'PushButton', 'String', 'Prev', ...
      'Callback', @StoreBtnCB);
    set(hb2, 'Visible', 'Off')
    if count==size(w1, 1)
        set(hb1, 'Visible', 'Off')
    end
    hb1.Position(2) = hb2.Position(2)+1.1*hb2.Position(4);
    function NextBtnCB(src, evnt)
        set(hb2, 'Visible', 'On')
        if count<size(w1, 1)
            count=count+1;
            route2graph(s,t,w1(count,:),w2(count,:),p1(count,:),p2(count,:),nodetable,count,pvs);
            if count==size(w1, 1)               
                set(hb1, 'Visible', 'Off')
            end
        end
    end
    function StoreBtnCB(src, evnt)
        set(hb1, 'Visible', 'On')
        if count>1
            count=count-1;
            route2graph(s,t,w1(count,:),w2(count,:),p1(count,:),p2(count,:),nodetable,count,pvs);            
            if count==1
                set(hb2, 'Visible', 'Off')
            end
        end
    end    
end