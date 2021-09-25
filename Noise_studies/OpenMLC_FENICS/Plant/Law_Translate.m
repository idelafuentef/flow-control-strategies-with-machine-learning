addpath(genpath('/home/ifuentef/Documents/flow-control-strategies-with-machine-learning/OpenMLC_FENICS'));

%% Introduce here the winning strategy
LISP_str='(root (* (+ 0.335 (* S8 -0.2831)) (cos (* 8.865 S29))))';
num_probes  = 11;
num_gen     = 5;
num_pool    = 100;
% fileID      = fopen(['./Solution_bashfiles/OpenMLC_' num2str(num_probes) 'probes_' num2str(num_pool) '_' num2str(num_gen) '.sh'],'w');
fileID      = fopen(['./Solution_bashfiles/OpenMLC_CdCl_100_' num2str(num_gen) '.sh'],'w');

%% Translate to formal
simp_str = simplify_my_LISP(LISP_str);
jet = readmylisp_to_formal_MLC(simp_str);

%% Sensors
%Cd,Cl
sensors = {'Cd','Cd_167','Cd_333','Cd_500','Cl','Cl_167','Cl_333','Cl_500'};

% %Velocity probes
% probetags   = {'Probe_u','Probe_v'};
% timetags    = {'','_1_2','_1_4','_3_4'};
% i_aux       = 1;
% for i_tag=1:numel(probetags)
%     for i_time=1:numel(timetags)
%         for i_probe=1:num_probes
%             sensors{i_aux}=[probetags{i_tag} timetags{i_time} '[' num2str(i_probe-1) ']'];
%             i_aux=i_aux+1;
%         end
%     end
% end

%- Apply the sensor name
for s = numel(sensors)-1:-1:0
    jet = strrep(jet,['S' num2str(s)],sensors{s+1}); % replace S# with the corresponding sensor
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

system('chmod +x ./Solution_bashfiles/*');
    