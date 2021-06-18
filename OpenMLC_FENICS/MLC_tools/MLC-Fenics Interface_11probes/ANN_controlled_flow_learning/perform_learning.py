#MLC-Fenics interface
from env import resume_env, nb_actuations
import os
import numpy as np
import sys
import env

#This instantiates the class Env2DCylinder through the function resume_env. The __init__ part has the following form:

#self, path_root, geometry_params, flow_params, solver_params, output_params, optimization_params, inspection_params, n_iter_make_ready=None, verbose=0, size_history=2000, cost_function='plain_drag', size_time_state=50, number_steps_execution=1, simu_name="Simu"):

#The resume_env is like this: resume_env(plot=False,step=50,dump=100,remesh=False,random_start=False,single_run=False):
#In this function, the different parameters of Env2DCylinder are defined


#Define the actuation functions
#The "sys" command connects MLC and the current .py file through the system command, and allows to read the string corresponding to the actuation function
fun_jet1 = '0.01*(' + sys.argv[1] + ')'
fun_jet2 = '0.01*(' + sys.argv[2] + ')'

#Define the number of timesteps for the simulation (also defined in MLC)
eval_steps = int(sys.argv[3])

#Define the individual ID (used when writing the csv results file)
ind = int(sys.argv[4])

#Timestep duration in seconds.Defined in env.py, if we change it we have to change it in both places
dt=0.0005			

#Define and start environment. This function comes from the "env" class, defined in "env.py". This is a subclass from the main class "Env2DCylinder"
environment = resume_env(plot=False, step=10, dump=10)
environment.start_class(complete_reset=True)
environment.write_history_parameters()

#Start execution of the Fenics solver. Each step has 50 substeps within the execution function 
for k in range(int(eval_steps)):
    state, terminal, reward = environment.execute(fun_jet1,fun_jet2,dt)
    environment.sing_run_output(ind)

#Compute average values of Cd,Cl,rec_area and print statistics
data = np.genfromtxt("saved_models/test_strategy"+str(ind)+".csv", delimiter=";")
data = data[1:,1:]
m_data = np.average(data[len(data)//2:], axis=0)
nb_jets = len(m_data)-4
print("Single Run finished. AvgDrag : {}, AvgLift : {}".format(m_data[1], m_data[2]))

