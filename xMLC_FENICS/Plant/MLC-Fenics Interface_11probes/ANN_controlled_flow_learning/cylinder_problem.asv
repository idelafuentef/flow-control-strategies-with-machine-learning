function J_out=cylinder_problem(Arrayb,parameters,visu,ind)
    % cylinder flow stabilization
    % The function cylinder_problem computes the cost of the actuation b for the
    % jets located on the upper and lower sides of the cylinder
    % The input is the string expression of the control law in a cell.
    % Examples : Arrayb = {'0'};
    %            Arrayb = {'cos(10*t)'};
    %            Arrayb = {'a1^2'};
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also read, mat2lisp, simplify_my_LISP.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA
    
    %% Parameters
    ActuationLimit = parameters.ProblemParameters.ActuationLimit;
    ActMin = min(ActuationLimit);
    ActMax = max(ActuationLimit);
    gamma = parameters.ProblemParameters.gamma; %penalization coefficient
    
    %number of evaluation steps ()
    eval_steps=parameters.ProblemParameters.eval_steps;
    subeval_steps=parameters.ProblemParameters.subeval_steps;
    
    %% Control law synthesis
    % bound the actuation
    BoundArrayb = limit_to(Arrayb,ActuationLimit); 
    % control law
    % The i-th control law is the i-th element of Arrayb.
    bx=BoundArrayb{1};

    eval(['b = @(a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21)(' bx ');']);
    %% Interpret individual    
    
    %substitute each sensor by the corresponding variable
    Arrayb=strrep(Arrayb,'a21','Probe_v[10]');
    Arrayb=strrep(Arrayb,'a20','Probe_v[9]');
    Arrayb=strrep(Arrayb,'a19','Probe_v[8]');
    Arrayb=strrep(Arrayb,'a18','Probe_v[7]');
    Arrayb=strrep(Arrayb,'a17','Probe_v[6]');
    Arrayb=strrep(Arrayb,'a16','Probe_v[5]');
    Arrayb=strrep(Arrayb,'a15','Probe_v[4]'); 
    Arrayb=strrep(Arrayb,'a14','Probe_v[3]');  
    Arrayb=strrep(Arrayb,'a13','Probe_v[2]');  
    Arrayb=strrep(Arrayb,'a12','Probe_v[1]');  
    Arrayb=strrep(Arrayb,'a11','Probe_v[0]');  
    
    Arrayb=strrep(Arrayb,'a10','Probe_u[10]');
    Arrayb=strrep(Arrayb,'a9','Probe_u[9]');
    Arrayb=strrep(Arrayb,'a8','Probe_u[8]');
    Arrayb=strrep(Arrayb,'a7','Probe_u[7]');
    Arrayb=strrep(Arrayb,'a6','Probe_u[6]');
    Arrayb=strrep(Arrayb,'a5','Probe_u[5]');
    Arrayb=strrep(Arrayb,'a4','Probe_u[4]'); 
    Arrayb=strrep(Arrayb,'a3','Probe_u[3]');  
    Arrayb=strrep(Arrayb,'a2','Probe_u[2]');  
    Arrayb=strrep(Arrayb,'a1','Probe_u[1]');  
    Arrayb=strrep(Arrayb,'a0','Probe_u[0]');  
    
    Arrayb=strrep(Arrayb,' ','');
    Arrayb=strrep(Arrayb,'.*','*');
    
    %Define jets based on equation
    jet1=[Arrayb{1}];                       
    jet2=['-' Arrayb{1}];
    
    
    fprintf('\n')
    fprintf('(%i) Simulating ...\n',ind)
    
    try
        if contains(jet1,'Probe')==0
            fprintf('(%i) No sensor found! \n',ind)
            error('no sensor')
        end
        %Substitute functions by their python name
        jet1=strrep(jet1,'sin','np.sin');  
        jet2=strrep(jet2,'sin','np.sin');  
        jet1=strrep(jet1,'cos','np.cos');  
        jet2=strrep(jet2,'cos','np.cos');  
        jet1=strrep(jet1,'tanh','np.tanh');  
        jet2=strrep(jet2,'tanh','np.tanh'); 
        jet1=strrep(jet1,'exp','np.exp');  
        jet2=strrep(jet2,'exp','np.exp'); 
        
        %Write batch script
        fileID = fopen(['input' num2str(ind) '.sh'],'w');
        python_input=['python3 perform_learning.py' ' "' jet1 '"' ' "' jet2 '" ' num2str(eval_steps) ' ' num2str(ind) ];
        python_input=strcat(python_input,' > NUL');
        fprintf(fileID,python_input);
        fclose(fileID);
        
        %give execution perimissions and execute batch script
        system('./permission.sh');
        system(['./input' num2str(ind) '.sh']);
        
        
        fprintf('(%i) Simulation finished.\n',ind);
        crashed=0;
    catch err
        crashed=1;
        fprintf('(%i) Simulation crashed.\n',ind)
    end
    
    
    if crashed==1
        J=parameters.BadValue;
    else
        try
            %retrieve resulting data from csv file
            output=table2cell(readtable(['saved_models/test_strategy' num2str(ind) '.csv']));
            
            %compute C_D and C_L based on final region and factorize
            C_D=mean(cell2mat(output(end-subeval_steps:end,3)))*(-20);
            C_L=mean(cell2mat(output(end-subeval_steps:end,4))*(20));
            
            %compute J, based on Rabault reward function (3.18 = 0.159*20)
            J=1+(C_D-3.18)+gamma*abs(C_L);  %3.18 is a proxy value, corresponding to CD when there is no control
           
            fprintf('(%i) C_D = %f\n',ind,C_D)
            fprintf('(%i) C_L = %f\n',ind,C_L)
            fprintf('(%i) J   = %f\n',ind,J)
            %Print python input
            fprintf(['(%i) jet = ' jet1 '\n'],ind);
        catch err
            crashed=1;
            J=parameters.BadValue;  
            fprintf('(%i) Not able to read csv\n',ind)
        end
    end
    
    J_out={J};
end