function [ind1,ind2]=v(val_in)
% Given the element number in the distance matrix, it gives the
% corresponding line and column

if val_in < 0 
    error('Valeur négative')
end

y=floor(sqrt(val_in*2)+2);
x=val_in-(y-1)*(y-2)/2;

while (x>=y) || (x<=0)
    if (x>=y)
    y=y+1;
    x=val_in-(y-1)*(y-2)/2;
    end
    if (x<=0)
    y=y-1;
    x=val_in-(y-1)*(y-2)/2;
    end
end

ind1=x;
ind2=y;
