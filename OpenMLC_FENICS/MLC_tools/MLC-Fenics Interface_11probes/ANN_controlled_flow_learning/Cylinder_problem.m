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
    m=substitute(m,gen_param.sensors);
    
    m=strrep(m,'S21','Probe_v[10]');
    m=strrep(m,'S20','Probe_v[9]');
    m=strrep(m,'S19','Probe_v[8]');
    m=strrep(m,'S18','Probe_v[7]');
    m=strrep(m,'S17','Probe_v[6]');
    m=strrep(m,'S16','Probe_v[5]');
    m=strrep(m,'S15','Probe_v[4]');
    m=strrep(m,'S14','Probe_v[3]');
    m=strrep(m,'S13','Probe_v[2]');
    m=strrep(m,'S12','Probe_v[1]');
    m=strrep(m,'S11','Probe_v[0]');
    
    m=strrep(m,'S10','Probe_u[10]');
    m=strrep(m,'S9','Probe_u[9]');
    m=strrep(m,'S8','Probe_u[8]');
    m=strrep(m,'S7','Probe_u[7]');
    m=strrep(m,'S6','Probe_u[6]');
    m=strrep(m,'S5','Probe_u[5]');
    m=strrep(m,'S4','Probe_u[4]');
    m=strrep(m,'S3','Probe_u[3]');
    m=strrep(m,'S2','Probe_u[2]');
    m=strrep(m,'S1','Probe_u[1]');
    m=strrep(m,'S0','Probe_u[0]');
    
    m=strrep(m,' ','');
    m=strrep(m,'.*','*');
    
    %Define jets based on equation
    jet1=[m];                       
    jet2=['-' m];
    
    
    if verb
        fprintf('(%i) Simulating ...\n',i)
    end
    
    try
        m_matlab=m;
        m_matlab=mat_substitute(m_matlab,gen_param.sensors);
        m_matlab=strrep(m,'Probe_u[0]','Probe_u(1)');
        m_matlab=strrep(m_matlab,'Probe_u[1]','Probe_u(2)');
        m_matlab=strrep(m_matlab,'Probe_u[2]','Probe_u(3)');
        m_matlab=strrep(m_matlab,'Probe_u[3]','Probe_u(4)');
        m_matlab=strrep(m_matlab,'Probe_u[4]','Probe_u(5)');        
        
        m_matlab=strrep(m_matlab,'Probe_v[0]','Probe_v(1)');
        m_matlab=strrep(m_matlab,'Probe_v[1]','Probe_v(2)');
        m_matlab=strrep(m_matlab,'Probe_v[2]','Probe_v(3)');
        m_matlab=strrep(m_matlab,'Probe_v[3]','Probe_v(4)');
        m_matlab=strrep(m_matlab,'Probe_v[4]','Probe_v(5)');
         
        jet1_mat=m_matlab;
        jet2_mat=['-' m_matlab];
        
        %Impose a representative value for the variables to check for jet
        %limits (based on solver limits of jet<0.01)
        Probe_u=ones(gen_param.sensors/2,1)*10;
        Probe_v=ones(gen_param.sensors/2,1)*10;
        
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
            
            %% CASE 1: VALOR ABSOLUTO DE LA MEDIA CL (SAME AS RABAULT)
%             %compute C_D and C_L based on final region and factorize
%             C_D=mean(cell2mat(output(end-subeval_steps:end,3)))*(-20);
%             C_L=mean(cell2mat(output(end-subeval_steps:end,4))*(20));
%             
%             %compute J, based on Rabault reward function (3.18 = 0.159*20)
%             J=1+(C_D-3.18)+gamma_J*abs(C_L);  %3.18 is a proxy value, corresponding to CD when there is no control
            
            %% CASE 2: MEDIA DEL VALOR ABSOLUTO CL (TO REDUCE AMPLITUDE)
            
            %compute C_D and C_L based on final region and factorize
            C_D=mean(cell2mat(output(end-subeval_steps:end,3)))*(-20);
            C_L=mean(abs(cell2mat(output(end-subeval_steps:end,4))*(20)));
            
            %compute J, based on Rabault reward function (3.18 = 0.159*20)
            J=1+(C_D-3.18)+gamma_J*C_L;  %3.18 is a proxy value, corresponding to CD when there is no control
            
            fprintf('(%i) C_D = %f\n',i,C_D)
            fprintf('(%i) C_L = %f\n',i,C_L)
            fprintf('(%i) J   = %f\n',i,J)
            %Print python input
            fprintf(['(%i) jet = ' jet1 '\n'],i);
        catch err    
            sys=[];
            sys.crashed=1;
            J=gen_param.badvalue;  
            fprintf('(%i) Not able to read csv\n',i)
        end
    end
end