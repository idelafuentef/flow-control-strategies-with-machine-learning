function val_out=u(ind1,ind2)
% Given the column and line in the distance matrix, it gives the
% corresponding element number
% First element must be lower than the second element.
if ind1 >= ind2
    error('wrong pair of individuals')
else
    val_out = ind1+(ind2-1)*(ind2-2)/2;
end
