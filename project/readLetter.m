function letter=readLetter(snap, i1)
load NewTemplates 
snap=imresize(snap,[42 24]);
comp=[ ];
if (i1==1)
    for n=1:(length(NewTemplates)-1)
        sem=corr2(NewTemplates{1,n},snap); 
        comp=[comp sem];
    end
    vd=find(comp==max(comp)); 
    %******************************
    
    if  vd>=1 && vd<=9
        letter='DHAKA';
    elseif  vd==10||vd==11
        letter='DHA';
    elseif  vd==12||vd==13
        letter='KA';    
      elseif  vd>=14&&vd<=72
        letter='CHATTA';    
    elseif vd>=73&&vd<=94
        letter='CHA ';    
    elseif vd>=95&&vd<=104
        letter='TTA';
    elseif vd>=105&&vd<=111
        letter=' ME';
    elseif vd>=112&&vd<=118
        letter='TRO ';
    elseif vd>=119&&vd<=191
        letter=' METRO ';
    elseif vd==192
        letter='CHO';
    elseif vd>=193&&vd<=198
        letter='KHA ';
    elseif vd==199 
        letter='GHA ';
    elseif vd>=200&&vd<=256
        letter='GA ';
    elseif vd>=457&&vd<=565
        letter='1';
    elseif vd>=566&&vd<=628
        letter='2';
    elseif vd>=629&&vd<=665
        letter='3';
    elseif vd>=666&&vd<=709
        letter='4';
    elseif vd>=710&&vd<=748
        letter='5';
    elseif vd>=749&&vd<=790 
        letter='6';
    elseif vd>=791&&vd<=819
        letter='7';
    elseif vd>=820&&vd<=842
        letter='8';
    elseif vd>=843&&vd<=867
        letter='9';
    elseif vd>=868&&vd<=894
        letter='0';
    else 
        letter='';
    end
end
end