function newstr=mat_substitute(mystr,numsensors)
    newstr=mystr;
    for i=1:numsensors/2
        newstr=strrep(newstr,['Probe_u[' num2str(numsensors/2-i) ']'],['Probe_u(' num2str(numsensors/2-i+1) ')']);
        newstr=strrep(newstr,['Probe_v[' num2str(numsensors/2-i) ']'],['Probe_v(' num2str(numsensors/2-i+1) ')']);
    end
end