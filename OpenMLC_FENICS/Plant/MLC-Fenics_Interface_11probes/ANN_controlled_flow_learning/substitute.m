function newstr=substitute(mystr,numsensors)
    newstr=mystr;
    for i=1:numsensors/2
        newstr=strrep(newstr,['S' num2str(numsensors-i)],['Probe_v[' num2str(numsensors/2-i) ']']);
    end
    
    for i=1:numsensors/2
        newstr=strrep(newstr,['S' num2str(numsensors/2-i)],['Probe_u[' num2str(numsensors/2-i) ']']);
    end

end