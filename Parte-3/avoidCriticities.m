function[totale]=avoidCriticities(totale_old)
    totale = totale_old;
    totale(isnan(totale_old))=0;
    totale(totale_old<0)=abs(totale_old(totale_old<0));
end