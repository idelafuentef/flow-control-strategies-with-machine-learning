Folders in this directory:

OpenMLC_FENICS includes the tree-based MLC analysis, with the evaluation of jet actuation in a cylinder flow simulation. Subcases considered are in the "Plant\" folder.
    -MLC-Fenics_Interface_CdCl. Based on Cd,Cl sensors that compute the instantaneous coefficients of the flow each timestep
    -MLC-Fenics_Interface_5probes. Based on the measurements of 5 velocity probes located past the cylinder
    -MLC-Fenics_Interface_11probes. Based on the measurements of 11 velocity probes past the cylinder
    
    Each case is included in a subfolder in OpenMLC_FENICS. To run it, you must execute the "Main.m" file located in OpenMLC_FENICS/    MLC_tools/MLC_FENICS Interface (casename)/ANN_controlled_flow_learning/
    Once the process is finished, the winning strategy is stored into the folder "bashfiles" as an executable bash file, such as:
    python3 ./perform_learning.py "control_law_jet1" "control_law_jet2" n_timesteps ind_ID
    If you want to run a longer simulation with the winning strategy, just increase the parameter "n_timesteps" and execute the bashfile from the ANN_cont...learning\ folder
    
    In the Plant\ folder you also have a Law_translate.m, this helps to translate from LISP format to the strings that are input into the bash file, given the number and type of probes of each case. This is useful if the winning strategy is given in the workspace window and you need to check with the bash files available.
    
    
xMLC_FENICS includes the linear-based MLC analysis, with the evaluation of jet actuation in a cylinder flow simulation. Subcases considered
    -MLC-Fenics_Interface_5probes. Based on the measurements of 5 velocity probes located past the cylinder
    -MLC-Fenics_Interface_11probes. Based on the measurements of 11 velocity probes past the cylinder
    
    To run it, you must execute the "Initialization_5.m" or "Initialization_11.m" file located in xMLC_FENICS/. However, you must do so while being in the folder xMLC_FENICS/Plant/MLC-Fenics_(casename)/ANN_controlled_flow_learning/. It is recommende to add the whole xMLC_FENICS folder to the MATLAB path
    
 In the Plant\ folder you also have a Law_translate.m, this helps to translate from LISP format to the strings that are input into the bash file, given the number and type of probes of each case. This is useful if the winning strategy is given in the workspace window and you need to check with the bash files available.
    
    
gMLC_FENICS includes the gradient-enriched linear-based MLC analysis, with the evaluation of jet actuation in a cylinder flow simulation. Subcases considered
    -MLC-Fenics_Interface_5probes. Based on the measurements of 5 velocity probes located past the cylinder
    -MLC-Fenics_Interface_11probes. Based on the measurements of 11 velocity probes past the cylinder
    
    To run it, you must execute the "cylinder_5probes_script.m" or "cylinder_11probes_script.m" file located in gMLC_FENICS/. It is recommende to add the whole gMLC_FENICS folder to the MATLAB path
    
    
ReLe includes the Reinforcement Learning analysis, with the evaluation of jet actuation in a cylinder flow simulation. Subcases considered
    -5probes. Based on the measurements of 5 velocity probes located past the cylinder
    -11probes. Based on the measurements of 11 velocity probes past the cylinder
    -151probes. Based on the measurements of 151 velocity probes past and around the cylinder
    
    To run it, you must first enter into the Singularity container. To do so, execute the bash file "start_singularity.sh" inside the ReLe folder. Once you are in, you must navigate through each of the case folders to find the "ANN_controlled_flow_learning" subfolder. Inside it, to start a learnign session, simply write "python perform_learning.py" and stop at the number of episodes you consider convenient.
    
    
    Noise_studies contains the some of these folders modified for sensor noise study, in which the measurement from the velocity probes is modified by a random value in order to check the influence of sensing noise to the control strategy. More information of the modifications is present in a Readme inside that folder.
    
    
    IC_studies contains the some of these folders modified for an Initial Condition study, in which the starting point of the simulation is randomized along a shedding cycle in order to ensure independence of the control law from the starting point. More information of the modifications is present in a Readme inside that folder
