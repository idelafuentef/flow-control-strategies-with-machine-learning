# gMLC

Fast self-learning control laws for nonlinear dynamics.
This software is based on a Genetic Programming framework to build control laws for dynamical systems.
The genetic operators are remplaced by three steps:
- exploitation (Downhill simplex)
- evolution (mutation and crossover)

## Getting Started

Unzip the tar.gz file.

### Prerequisites

The software needs MATLAB.
This version has been developped on MATLAB version 9.5.0.944444 (R2018b)
Please contact gy.cornejo.maceda@gmail.com in case of error.

### Content
The main folder should contain the following folders and files:
- *README.md*
- *Initialization.m*, *Restart.m*, to initialize and restart the toy problem.
- *@LGPC/*, *@LGPCind/*, *@LGPCpop/*, *@LGPCtable/* contains the object definition files for "classic" LGPC algorithm.
- *@gMLC/*, *@gMLCbasket/*, *@gMLChistory/*, *@gMLCind/*, *@gMLCstock/*, *@gMLCtable/* contains the object definition files for gMLC.
- *Analysis/* folder for analysis.
- *Clustering/* folder for clustering control laws.
- *External/* contains scripts to interface gMLC with UNS3 simulations and experiments.
- *gMLC_tools/* contains functions used in gMLC
- *Other_tools/* contains other functions such ODE solvers and plot function for proximity map.
- *Plant/* contains all the problems and associated parameters. One folder for each problem. Default parameters are in *gMLC_tools/*.
- *save_runs/* contains the savings.
- *sub/* contains script to launch some cases.

### Initialization and run

To start, run matlab in the main folder, then run Initialization.m to load the folders and class object.

```
Initialization;
```

A *mlc* object is created containing the toy problem.
The toy problem is the interpolation of a tanh function.
For more interesting behavior, work on the Generalized Mean-Field Model (GMFM).
To load a different problem, just specify it when the gMLC object is created.

```
mlc=gMLC('oscillator');
mlc.show_problem;
```

To start the optimization process of the toy problem, run the *mlc2boost.m* method.
Run alone it process one cycle of optimization.
For the first iteration, it will initialize the data base with new individiduals following a giving method (Monte Carlo by defaul).

```
mlc.mlc2boost;
```


## Post processing and analysis.

To visualize the best individual, use :

```
mlc.show;
```

To visualize the learning process, use : 

```
mlc.plot_progress;
```

% THE FOLLOWING IS NOT READY YET
To plot the proximity map, a distance metric is needed.
It should be in the adequate Plant folder.
See *toy_distance.m* for an example.

```
mlc.extract_to_compute_distance;
mlc.compute_distance;
mlc.export_figures;
```

All the figures for the proximity map are in save_runs/NameOfMyRun/Figures/Proximity_map

### Useful parameters

```
mlc.parameters.name = 'NameOfMyRun'; % This is the used to save;
mlc.parameters.save_data=1; % Save actuation and sensor data for proximity map, see toy_problem.
mlc.parameters.basket_init_size = 100; % Number of individuals generated in the initialization step;
	% For Monte-Carlo, it gives 100 random individuals.
mlc.parameters.basket_size = 10; % Size of the downhill simplex subpsace.
mlc.parameters.actuation_limit=[-1,1]; % The actuation is bounded between -1 and 1.
```

### Save/Load

One can save and load one run.
/!\ When loading, the mlc object will be overwritten, be careful!

```
mlc.save;
mlc.load('NameOfMyRun');
```

## Versioning

To be updated.

Modifications:
 - The @LGPC class has been updated and renamed @MLC.
 - The parameter file has been updated.

## Author

* **Guy Y. Cornejo Maceda** 

## License

gMLC (Gradient-enriched Machine Learning Control) for taming nonlinear dynamics.
    Copyright (c) 2019, Guy Y. Cornejo Maceda (gy.cornejo.maceda@gmail.com)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

## Acknowledgments

* Hat tip to Thomas Duriez whose code was used
* Thank you to Ruying Li which inspired some of the functions.
* Thank you to Philipp Oswald for his precious help for the parallelization of the code with the MATLAB parallel toolbox.


