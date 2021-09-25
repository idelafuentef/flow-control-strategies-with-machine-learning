from printind.printind_function import printi, printiv
from env import resume_env

import numpy as np
import env
import os
import csv
import sys


printi("resume env")

fun_jet1 = sys.argv[1]
fun_jet2 = sys.argv[2]
eval_steps = int(sys.argv[3])
ind = int(sys.argv[4])
dt=0.0005

environment = resume_env(plot=500, dump=10, single_run=True)
deterministic=True

restore_path = None
if(os.path.exists("saved_models/checkpoint")):
    restore_path = './saved_models'
restore_path = './best_model'


if(os.path.exists("saved_models/test_strategy.csv")):
    os.remove("saved_models/test_strategy.csv")

if(os.path.exists("saved_models/test_strategy_avg.csv")):
    os.remove("saved_models/test_strategy_avg.csv")

printi("start simulation")
state = environment.reset()
environment.render = True

for k in range(3 * env.nb_actuations):
    state, terminal, reward = environment.execute(fun_jet1,fun_jet2,dt)

data = np.genfromtxt("saved_models/test_strategy"+str(ind)+".csv", delimiter=";")
data = data[1:,1:]
m_data = np.average(data[len(data)//2:], axis=0)
nb_jets = len(m_data)-4
# Print statistics
print("Single Run finished. AvgDrag : {}, AvgRecircArea : {}".format(m_data[1], m_data[2]))

name = "test_strategy_avg.csv"
if(not os.path.exists("saved_models")):
    os.mkdir("saved_models")
if(not os.path.exists("saved_models/"+name)):
    with open("saved_models/"+name, "w") as csv_file:
        spam_writer=csv.writer(csv_file, delimiter=";", lineterminator="\n")
        spam_writer.writerow(["Name", "Drag", "Lift", "RecircArea"] + ["Jet" + str(v) for v in range(nb_jets)])
        spam_writer.writerow([environment.simu_name] + m_data[1:].tolist())
else:
    with open("saved_models/"+name, "a") as csv_file:
        spam_writer=csv.writer(csv_file, delimiter=";", lineterminator="\n")
        spam_writer.writerow([environment.simu_name] + m_data[1:].tolist())

