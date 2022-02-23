function [] = plot_manipulability( time,WT, WTs, WR, WRs,wth,option,sing_time)

%Plot translational manipulability indices (weak and strong)
 subplot(2,1,1);
 plot(time,[WT(1:length(time)); WTs]); 
 xlabel('time (sec)')
 title('Translational Manipulability')
 legend('ì_Ô (weak)','ì_Ô_S_t_r_o_n_g','Location','eastoutside','Orientation','vertical');
 hold on
  if option~=0
     p1=plot([time(1) time(end)],[wth(1) wth(1)],':k')  %Plot threshold 
     legend(p1,'Threshold')
     [ymin, xmin] = min(WTs(:));
     strmin = ['(min,t_m_i_n)=(',[num2str(ymin) ',' num2str(xmin/100)],')'];
     text(xmin/100,ymin,strmin,'VerticalAlignment','bottom');
     hold on
     ps=plot(xmin/100,ymin,'*black')
     legend(ps,'Minimum')
 else
     p1=plot([time(1) time(end)],[wth(1) wth(1)],':k')  %Plot threshold 
     hold on
     p2=plot([time(1) time(end)],[WTs(sing_time) WTs(sing_time)],'--g')  %Plot threshold 
     legend(p1,'Threshold')
     legend(p2,'Singular point')    
%    ymin=WTs(sing_time);
%    strmin = ['Singular Point=',num2str(ymin)];
%    text(time(1),ymin,strmin,'VerticalAlignment','bottom');
  end
 Tickvector=[0:0.01:0.03-0.01];
 Tickvector=[Tickvector,0.03:0.02:10];
 set(gca,'YTick',Tickvector);
 set(gca,'YTickLabelMode','manual');
 set(gca,'YTickLabel',Tickvector);
 
 %Plot rotational manipulability indices (weak and strong)
 subplot(2,1,2);
 p3=plot(time,[WR(1:length(time)); WRs]);  
 xlabel('time (sec)')
 title('Rotational Manipulability')
 legend('ì_R (weak)','ì_R_S_t_r_o_n_g','Location','eastoutside','Orientation','vertical');  
 hold on
 if option~=0
     p4=plot([time(1) time(end)],[wth(4) wth(4)],':k')  %Plot threshold 
     legend(p4,'Threshold')
     [ymin, xmin] = min(WRs(:));
     strmin = ['(min,t_m_i_n)=(',[num2str(ymin) ',' num2str(xmin/100)],')'];
     text(xmin/100,ymin,strmin,'VerticalAlignment','bottom');
     hold on
     ps=plot(xmin/100,ymin,'*black')
     legend(ps,'Minimum')
     
 else
     p4=plot([time(1) time(end)],[wth(4) wth(4)],':k')  %Plot threshold
     hold on
     p5=plot([time(1) time(end)],[WRs(sing_time) WRs(sing_time)],'--g')  %Plot threshold 
     legend(p4,'Threshold')
     legend(p5,'Singular point')
 end
 Tickvector=[0:0.15:0.2-0.1];
 Tickvector=[Tickvector,0.2:0.4:10];
 set(gca,'YTick',Tickvector);
 set(gca,'YTickLabelMode','manual');
 set(gca,'YTickLabel',Tickvector);
 
 

end

