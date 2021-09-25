function f=testt(t,T)
%TESTT program crashes when t>T 
%
%   F=TESTT(t,T)
%
%   Adding this to a function to integrate in ODExxx allows to trigger an error 
%   when t>T. Calling this function with t=TOC allows to stop integration
%   after T seconds in real time. Usually used inside a TRY/CATCH sequence.
    if t>T
        fprintf('Crash provided by testt. Consider augmenting the allowed evauation time if the occurence is high.m\n');
        crash % variable is not defined, hence produces an error
    else
        f=0;
    end
end


















































