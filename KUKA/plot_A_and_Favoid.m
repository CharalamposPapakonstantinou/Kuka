function [] = plot_A_and_Favoid( time,AA ,F_avoid)
%  %Plot A vector
 subplot(2,1,1)
 plot(time,AA)
 xlabel('time (sec)')
 title('A_T_r & A_R_o_t')
 legend('A_T_r_,_x','A_T_r_,_y','A_T_r_,_z','A_R_o_t_,_x','A_R_o_t_,_y','A_R_o_t_,_z','Location','eastoutside','Orientation','vertical')
 
 %Plot F_avoid
 subplot(2,1,2)
 plot(time,F_avoid)
 xlabel('time (sec)')
 ylabel('N,Nm')
 title('Favoid (XYZ)')
 legend('F_{av,x}','F_{av,y}','F_{av,z}','ô_{av,x}','ô_{av,y}','ô_{av,z}','Location','eastoutside','Orientation','vertical')
  
%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  %Plot A vector
%  subplot(3,1,1)
%  plot(time,AA)
%  xlabel('time (sec)')
%  title('A_T_r & A_R_o_t')
%  legend('A_T_r_,_x','A_T_r_,_y','A_T_r_,_z','A_R_o_t_,_x','A_R_o_t_,_y','A_R_o_t_,_z','Location','eastoutside','Orientation','vertical')
%  
%  %Plot F_avoid
%  subplot(3,1,2)
%  plot(time,F_avoid)
%  xlabel('time (sec)')
%  ylabel('N,Nm')
%  title('Favoid (XYZ)')
%  legend('F_{av,x}','F_{av,y}','F_{av,z}','ô_{av,x}','ô_{av,y}','ô_{av,z}','Location','eastoutside','Orientation','vertical')
% 
%  subplot(3,1,3)
%  plot(time,F_avoid)
%  xlabel('time (sec)')
%  ylabel('N,Nm')
%  title('Favoid (XYZ)')
%  legend('F_{av,x}','F_{av,y}','F_{av,z}','ô_{av,x}','ô_{av,y}','ô_{av,z}','Location','eastoutside','Orientation','vertical')
% xlim([1.2 5])
% ylim([-0.06 0.03])
% 
end

