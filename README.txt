Two main folders, one for each case considered

- OpenMLC_FENICS includes the tree-based MLC analysis, with the evaluation of jet actuation in a cylinder flow simulation. Subcases considered
    -Original. Based on Cd,Cl sensors that compute the instantaneous coefficients of the flow each timestep
    -5probes. Based on the measurements of 5 velocity probes located past the cylinder
    -11 probes. Based on the measurements of 11 velocity probes past the cylinder
    
    Each case is included in a subfolder in OpenMLC_FENICS. To run it, you must execute the "Main.m" file located in OpenMLC_FENICS/MLC_tools/MLC_FENICS Interface (casename)/ANN_controlled_flow_learning/
  
- xMLC_FENICS includes the linear-based MLC analysis, with the evaluation of jet actuation in a cylinder flow simulation. Subcases considered
    -5probes. 
    To run it, you must execute the "Initialization.m" file located in xMLC_FENICS/. However, you must do so while being in the folder xMLC_FENICS/Plant/MLC-Fenics (casename)/ANN_controlled_flow_learning/
