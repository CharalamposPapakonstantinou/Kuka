
# KUKA 7 DoF - Manipulator Performance Constraints in Cartesian Admittance Control for Human-Robot Cooperation

A method is proposed that implements virtual constraints in Cartesian admittance control
 in order 
to prevent the operator from guiding the ma- nipulator to 
low-performance configurations. The constraints are forces expressed 
in the Cartesian frame, which restrict the translation of the end-effector when
 the operator guides the robot below a certain performance threshold. These forces
  are calculated online by numerically approximating the gradient of the performance 
  index with respect to the Cartesian frame attached to the end-effector.


## Run

Run Main_code.m in Matlab.

Robotics Toolbox - Peter Corke is required



    
## Related

https://www.youtube.com/watch?v=1zTDmiDjDOA

https://ieeexplore.ieee.org/document/7487469
