% Singularity Avoidance on Cartesian Admittance control
% using either manipulability,MSV or LCI index and a spring.
%
% Requirements:
% - Robotics Toolbox for Matlab (http://www.petercorke.com/Robotics_Toolbox.html)
% 
% Notes: 
% - The simulation does not consider the joint limits so the robot
% might behave weird
%
% Author: Charalampos Papakonstantinou
%
% Copyright 2015 Charalampos Papakonstantinou


close all;
%%
clear all;
clc;
%Create the model
L1 = Link('d', 0.3105, 'a', 0, 'alpha', pi/2, 'offset', 0);
L2 = Link('d', 0, 'a', 0, 'alpha', -pi/2, 'offset', 0);
L3 = Link('d', 0.4, 'a', 0, 'alpha',-pi/2, 'offset', 0);
L4 = Link('d', 0, 'a', 0, 'alpha', pi/2, 'offset', 0);
L5 = Link('d', 0.39, 'a', 0, 'alpha', pi/2);
L6 = Link('d', 0, 'a', 0, 'alpha', -pi/2, 'offset', 0);
L7 = Link('d', 0.078, 'a', 0, 'alpha', 0, 'offset', 0);
KUKA = SerialLink([L1 L2 L3 L4 L5 L6 L7], 'name', 'KUKA LWR 7DOF');
q0=[0 0.3491 0 -1.3963 0 1.3963 0];

Ts=0.01; %fs=1KHz
figure(1)
KUKA.plot(q0,'delay',Ts,'notiles','floorlevel',-0.5,'linkcolor',[ 1 0.4 0],'jointcolor',[0.7 0.7 0.8]); 

time = 0:Ts:5; %Simulation time

%SET THE DESIRED REPRESENATION
option=1; 
% 0: no limits, 
% 1: Manipulability representation (Strong indices)
% 2: MSV representation 
% 3: LCI representation 

%SET THE DESIRED MOVEMENT
Translational=1;
Rotational=0;
% 0: no movement
% 1: movement 

%SET THE EXTERNAL FORCE/TORQUE (N, N/m)
F=zeros(6,length(time));
until=300;                   %the force/torque will be applied for "until" time : until*10ms = 1sec
%First value given into the vector represents the axis in which the
%force/torque will be applied:
%1=X, 2=Y, 3=Z, 4=Tx, 5=Ty, 6=Tz
     F(1,1:until)  = 7;          
     F(2,1:until)  = 7;
     F(4,1:until) = 0*0.1;  
     F(5,1:until) = 0*0.3;   
 
%SET THE GAINS AND THE THRESHOLD FOR EACH REPRESENTATION
if (option==0)
  %wth=zeros(1,6)';
  wth=[0.03*ones(1,3) 0.2*ones(1,3)]';
  kerdosT=zeros(3,1);
  kerdosR=zeros(3,1);
elseif (option==1)
  wth=[0.03*ones(1,3) 0.2*ones(1,3)]'; 
  kerdosT=1e6*ones(3,1);
  kerdosR=2*1e3*ones(3,1); 
elseif (option==2)
  wth=0.1*ones(1,6)';
  kerdosT=1e5*ones(3,1); 
  kerdosR=1e4*ones(3,1); 
elseif (option==3)
  wth=0.05*ones(1,6)';
  kerdosT=1e5*ones(3,1);
  kerdosR=1e4*ones(3,1); 
end

%SET THE DC GAIN OF EACH MOVEMENT EQUAL TO ZERO IF REQUIRED
if (Translational==0) 
  kerdosT=zeros(3,1);
end
if (Rotational==0) 
  kerdosR=zeros(3,1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%INITIALIZING PARAMETERS

M = diag([2*ones(1,3) 0.1*ones(1,3)]');  %Desired robot mass 
C = diag([50*ones(1,3) 0.5*ones(1,3)]'); %Desired robot damping
K_w=[0 0 0 0 0 0]';                      %Dc gain of the spring
K_wT=[0 0 0]';      
K_wR=[0 0 0]';
breakPointTr=0.01;
breakPointRot=0.16;

xDdot=[0 0 0 0 0 0]';
T=KUKA.fkine(q0);            %Forward kinematics: find x,y,z coordinates of the end effector
x0=[T(1,4) T(2,4) T(3,4) 0 0 0]';  
x = [T(1,4) T(2,4) T(3,4)]';
x_dot=[0 0 0 0 0 0]';
x_dotprev=x_dot;
q = q0';
qq = [];
F_avoid= []; 
A=zeros(6,1); 
W=[]; WT=[]; WR=[]; WTs=[]; WRs=[];
S=[]; St=[]; Sr=[]; St_aug=[]; Sr_aug=[]; 
LCI=[];
AA=[];
taxythta=[];
sing_time=0;

 for i=1:length(time)
   %Calculate J,JT,JR,JTaug,JRaug
   J = KUKA.jacobn(q);
   JT = J(1:3,:); 
   JR = J(4:6,:);
   JTaug = JT*(eye(length(q0),length(q0))-pinv(JR)*JR);
   JRaug = JR*(eye(length(q0),length(q0))-pinv(JT)*JT);   
   %Calculate manipulability indices
   WT  = [ WT KUKA.maniplty(q','T')];  %uT Translational manipulability index
   WR  = [ WR KUKA.maniplty(q','R')];  %uR Rotational manipulability index      
   WTs = [WTs sqrt(det( JT*(eye(length(q0),length(q0))-pinv(JR)*JR)*JT' ))]; %uTstrong: Strong translational manipulability index
   WRs = [WRs sqrt(det( JR*(eye(length(q0),length(q0))-pinv(JT)*JT)*JR' ))]; %uRstrong: Strong rotational manipulability index  
   %Calculate MSV indices
   sigma = svd(J);
   S=[S min(sigma)];
   St=[St min(svd(JT))];              %Translational J only
   Sr=[Sr min(svd(JR))];              %Rotational J only
   St_aug = [St_aug min(svd(JTaug))]; %Augmented translational J
   Sr_aug = [Sr_aug min(svd(JRaug))]; %Augmented rotational J
   %Calculate LCI index
   LCI=[LCI min(sigma)/(max(sigma))];

   %Create W vector according to the option
   if (option<=1)       
     W=[W [WTs(i)*ones(3,1);WRs(i)*ones(3,1)]];
   elseif (option==2)
     W=[W min(sigma)*ones(6,1)];
   elseif (option==3)
     W=[W LCI(i)*ones(6,1)];
   end
       
   % Check for low performance configurations
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Translational motion singularities
   if (W(1,i) < wth(1)) 
     for dir=1:3
       A(dir)= grad_w(q,KUKA,dir,J,option);  
     end      
     K_wT = kerdosT;  
   elseif (W(1,i) >= wth(1)) 
     A(1:3)=zeros(3,1);
     K_wT = [0 0 0]';         
   end
   %Rotational motion singularities
   if (W(4,i) < wth(4))      
     for dir=4:6
       A(dir)= grad_w(q,KUKA,dir,J,option);  
     end 
     K_wR = kerdosR;                
   elseif (W(4,i) >= wth(4)) 
     A(4:6)=zeros(3,1);
     K_wR = [0 0 0]';               
   end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
   K_w=[K_wT; K_wR]; % Create the final dc gain vector from translational and rotational vector         
   
   %Apply the control law
   F_avoid(:,i)= diag(A')* K_w.*(W(:,i) - wth); 
   x_dot=inv( M/Ts + C)*( F(:,i) + M*x_dotprev/Ts - F_avoid(:,i) ) ;
   
   q_dot = pinv(J)*x_dot;
   q=Ts*q_dot+q;
   qq(:,i)=q;           
   T=KUKA.fkine(q);
   x = [T(1,4) T(2,4) T(3,4)]';
   x_dotprev=x_dot;
   
   AA = [AA A];          %Save all A vectors
   taxythta(:,i)=q_dot;  %Save all velocities
   
   if((option==0) && Translational==1 && (W(1,i) < breakPointTr) )
     sing_time=i;
     break
   end
   if((option==0) && Rotational==1 && (W(4,i) < breakPointRot))
     sing_time=i;
     break
   end
 end
 
 if (option==0)
   %Fill the matrices W & taxythta with zeros after the break point
   fill_cells=length(time)-i;
   W=[W zeros(6,fill_cells)];
   WT=[WT zeros(1,fill_cells)];
   WTs=[WTs zeros(1,fill_cells)];
   WR=[WR zeros(1,fill_cells)];
   WRs=[WRs zeros(1,fill_cells)];
   S=[S zeros(1,fill_cells)];
   St_aug=[St_aug zeros(1,fill_cells)];
   Sr_aug=[Sr_aug zeros(1,fill_cells)];
   LCI=[LCI zeros(1,fill_cells)];
   taxythta=[taxythta zeros(7,fill_cells)];
 end
 
% ANIMATION
figure(1)
KUKA.plot(q0,'delay',Ts,'notiles','floorlevel',-0.5,'linkcolor',[ 1 0.4 0],'jointcolor',[0.7 0.7 0.8])

KUKA.animate(qq')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plots
 
if (option==0)
   figure(2)
   plot_velocity(time,taxythta);
   figure(3)
   plot_manipulability(time,WT,WTs,WR,WRs,wth,option,sing_time)
   figure(4)
   plot_MSV(time,S,St_aug,Sr_aug,wth,option,sing_time)
   figure(5)
   plot_LCI(time,LCI,wth,option,sing_time)  
elseif (option==1)
   figure(2)
   plot_velocity(time,taxythta);
   figure(3)
   plot_manipulability(time,WT,WTs,WR,WRs,wth,option,sing_time)
   figure(4)
   plot_A_and_Favoid(time,AA,F_avoid)   
elseif (option==2)
   figure(2)
   plot_velocity(time,taxythta);
   figure(3)
   plot_MSV(time,S,St_aug,Sr_aug,wth,option,sing_time)
   figure(4)
   plot_A_and_Favoid(time,AA,F_avoid)    
elseif (option==3)
   figure(2)
   plot_velocity(time,taxythta);
   figure(3)
   plot_LCI(time,LCI,wth,option,sing_time)  
   figure(4)
   plot_A_and_Favoid(time,AA,F_avoid)      
end
