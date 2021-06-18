function [J,sys]=Cylinder_problem(ind,gen_param,i,fig)
    
    verb=gen_param.verbose;
    gamma_J=gen_param.problem_variables.gamma;                  %Relative weight of lift coefficient with respect to drag


    %% Interpret individual 
    
    
    %number of evaluation steps (from GP_cylinder)
    eval_steps=gen_param.problem_variables.eval_steps;
    subeval_steps=gen_param.problem_variables.subeval_steps;
    
    m=simplify_my_LISP(ind.value);
    m=readmylisp_to_formal_MLC(m);
    
    %substitute each sensor by the corresponding variable
    m=strrep(m,'S0','Probe_u[0]');  
    m=strrep(m,'S1','Probe_u[1]');  
    m=strrep(m,'S2','Probe_u[2]');  
    m=strrep(m,'S3','Probe_u[3]');  
    m=strrep(m,'S4','Probe_u[4]');  
    
    m=strrep(m,'S5','Probe_v[0]');  
    m=strrep(m,'S6','Probe_v[1]'); 
    m=strrep(m,'S7','Probe_v[2]');
    m=strrep(m,'S8','Probe_v[3]');
    m=strrep(m,'S9','Probe_v[4]');
    
    m=strrep(m,' ','');
    m=strrep(m,'.*','*');
    
    %Define jets based on equation
    jet1=[m];                       
    jet2=['-' m];
    
    
    if verb
        fprintf('(%i) Simulating ...\n',i)
    end
    
    try
        m_matlab=strrep(m,'Probe_u[0]','Probe_u(1)');
        m_matlab=strrep(m_matlab,'Probe_u[1]','Probe_u(2)');
        m_matlab=strrep(m_matlab,'Probe_u[2]','Probe_u(3)');
        m_matlab=strrep(m_matlab,'Probe_u[3]','Probe_u(4)');
        m_matlab=strrep(m_matlab,'Probe_u[4]','Probe_u(5)');
        
        m_matlab=strrep(m_matlab,'Probe_v[0]','Probe_v(1)');
        m_matlab=strrep(m_matlab,'Probe_u[1]','Probe_v(2)');
        m_matlab=strrep(m_matlab,'Probe_u[2]','Probe_v(3)');
        m_matlab=strrep(m_matlab,'Probe_u[3]','Probe_v(4)');
        m_matlab=strrep(m_matlab,'Probe_u[4]','Probe_v(5)');
        
        jet1_mat=m_matlab;
        jet2_mat=['-' m_matlab];
        
        %Impose a representative value for the variables to check for jet
        %limits (based on solver limits of jet<0.01)
        Probe_u=ones(5,1)*10;
        Probe_v=ones(5,1)*10;
        
        disp(jet1)
        disp(jet2)
        if abs(eval(jet1_mat)*0.01)>0.01 || abs(eval(jet2_mat)*0.01)>0.01
            disp('Over the limits')
            error('aa')
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
        fileID = fopen(['input' num2str(i) '.sh'],'w');
        python_input=['python3 perform_learning.py' ' "' jet1 '"' ' "' jet2 '" ' num2str(eval_steps) ' ' num2str(i) ];
        python_input=strcat(python_input,' > NUL');
        fprintf(fileID,python_input);
        fclose(fileID);
        
        %give execution perimissions and execute batch script
        system('./permission.sh');
        system(['./input' num2str(i) '.sh']);
        
        
        if strncmp(lastwarn,'Failure',7)
            warning('reset')
            sys.crashed=1;
        else
            sys.crashed=0;
        end
        
        if verb
            fprintf('(%i) Simulation finished.\n',i);
        end
    catch err    
        sys=[];
        sys.crashed=1;
        if verb
            fprintf('(%i) Simulation crashed.\n',i)
        end
    end
    crashed=sys.crashed;
    if crashed==1
        J=gen_param.badvalue;
        if verb>1;fprintf('(%i) Bad fitness: sim crashed\n',i);end     
    else
        try
            %retrieve resulting data from csv file
            output=table2cell(readtable(['saved_models/test_strategy' num2str(i) '.csv']));
            
            %compute C_D and C_L based on final region and factorize
            C_D=mean(cell2mat(output(end-subeval_steps:end,3)))*(-20);
            C_L=mean(cell2mat(output(end-subeval_steps:end,4))*(20));
            
            %compute J, based on Rabault reward function (3.18 = 0.159*20)
            J=1+(C_D-3.18)+gamma_J*abs(C_L);  %3.18 is a proxy value, corresponding to CD when there is no control
            if verb==4
                fprintf(['C_D = ' num2str(C_D) '\n'])
                fprintf(['C_L = ' num2str(C_L) '\n'])
                fprintf(['J = ' num2str(J) '\n'])
            end
            %Print python input
            fprintf(['jet 1 = ' jet1 '\n']);
            fprintf(['jet 2 = ' jet2 '\n']);
        catch err    
            sys=[];
            sys.crashed=1;
            J=gen_param.badvalue;  
            fprintf('(%i) Not able to read csv\n',i)
        end
    end
end