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
    m=strrep(m,'S0','Cd');  
    m=strrep(m,'S1','Cd_167');  
    m=strrep(m,'S2','Cd_333');  
    m=strrep(m,'S3','Cd_500');  
    m=strrep(m,'S4','der_Cd');  
    
    m=strrep(m,'S5','Cl');  
    m=strrep(m,'S6','Cl_167');  %Cl at 1/4 period
    m=strrep(m,'S7','Cl_333');  %Cl at 1/2 period
    m=strrep(m,'S8','Cl_500');  %Cl at 3/4 period    
    m=strrep(m,'S9','der_Cl');  %Cl derivative
    
    m=strrep(m,' ','');
    m=strrep(m,'.*','*');
    
    %Define jets based on equation
    jet1=[m];                       
    jet2=['-' m];
    
    
    if verb
        fprintf('(%i) Simulating ...\n',i)
    end
    
    try
        %Impose a representative value for the variables to check for jet
        %limits (based on solver limits of jet<0.01)
        Cd=0.01;Cd_167=0.01;Cd_333=0.01;Cd_500=0.01;der_Cd=70;
        der_Cl=70;Cl=0.06;Cl_167=0.06;Cl_333=0.06;Cl_500=0.06;
        
        disp(jet1)
        disp(jet2)
        if abs(eval(jet1)*0.001)>0.01 || abs(eval(jet2)*0.001)>0.01
            disp('Over the limits')
            error('aa')
        end
        
        if contains(jet1,'C')==0
            disp('No sensors included')
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