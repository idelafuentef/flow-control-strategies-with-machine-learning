clear;clc;

%% Introduce here the winning strategy
jet='(s(12) - s(2))';
num_probes  = 11;
num_gen     = 15;
fileID      = fopen(['./Solution_bashfiles/input_' num2str(num_probes) 'probes_100_' num2str(num_gen) '.sh'],'w');

%% Sensors

%Velocity probes
probetags   = {'Probe_u','Probe_v'};
timetags    = {'','_1_2','_1_4','_3_4'};
i_aux       = 1;
for i_tag=1:numel(probetags)
    for i_time=1:numel(timetags)
        for i_probe=1:num_probes
            sensors{i_aux}=[probetags{i_tag} timetags{i_time} '[' num2str(i_probe-1) ']'];
            i_aux=i_aux+1;
        end
    end
end

%- Apply the sensor name
for s = numel(sensors):-1:1
    jet = strrep(jet,['s(' num2str(s) ')'],sensors{s}); 
end
jet   = strrep(jet,' ','');   % Eliminate spaces
jet   = strrep(jet,'.*','*'); % Eliminate . in operations (avoid python cracks)

%% Operations
operations = {'+','-','*','/','sin','cos','log','exp','tanh','mod','^'};
for o = 5:numel(operations)
    switch operations{o}
        case {'cos','sin','log','exp','tanh','mod'}
        jet = strrep(jet,operations{o},['np.' operations{o}]);
        case '^'
        jet = strrep(jet,operations{o},'**');
        otherwise 
        error('No operation defined'); 
    end
end


%-Define jets based on equation: custom scaling of 0.01 is applied.
jet = ['0.01*(' jet ')'];

jet1 = jet; jet2 = ['-' jet];
python_input = ['python3 ./perform_learning.py' ' "' jet1 '"' ' "' jet2 '" ' num2str(12000) ' ' num2str(num_gen) ];
fprintf(fileID,python_input);
fclose(fileID);
    