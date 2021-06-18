function [m,J]=show_ind(mlc,n,N)
% SHOW_IND display selected individual (MLC2 Toolbox)
%
%   IND_OBJ=MLC_OBJ.SHOW_IND(n,N) returns the object corresponding to
%       the individual as per index in the MLCtable. Additionaly calls the evaluation function avec
%       N as fourth argument, which can be used to implement graphic functions.
%
    if nargin<3
        fig=1;
    end
    eval(['heval=@' mlc.parameters.evaluation_function ';']);
            f=heval;
     
     m=mlc.table.individuals(n);        
    J=feval(f,m,mlc.parameters,1,fig);
end


