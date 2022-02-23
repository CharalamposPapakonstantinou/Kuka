function [] = plot_LCI( time,LCI,wth,option,sing_time )
 %Plot LCI index
 p0=plot(time,LCI)
 legend(p0,'LCI')
 xlabel('time (sec)')
 title('LCI=1/condition number')  
 hold on
 if option~=0
     p1=plot([time(1) time(end)],[wth(1) wth(1)],':k')      %Plot threshold 
     legend(p1,'Threshold')
     [ymin, xmin] = min(LCI(:));
     strmin = ['(min,t_m_i_n)=(',[num2str(ymin) ',' num2str(xmin/100)],')'];
     text(xmin/100,ymin,strmin,'VerticalAlignment','bottom');
     hold on
     ps=plot(xmin/100,ymin,'*black')
     legend(ps,'Minimum')
 else
     p1=plot([time(1) time(end)],[0.05 0.05],':k')  
     hold on 
     p2=plot([time(1) time(end)],[LCI(sing_time) LCI(sing_time)],'--g') 
     legend(p1,'Threshold')
     legend(p2,'Singular point')
 end
 Tickvector=[0:0.01:0.05-0.01];
 Tickvector=[Tickvector,0.05:0.01:10];
 set(gca,'YTick',Tickvector);
 set(gca,'YTickLabelMode','manual');
 set(gca,'YTickLabel',Tickvector);
end

