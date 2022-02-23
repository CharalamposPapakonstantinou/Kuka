function [] = plot_MSV( time,S, St_aug, Sr_aug, wth,option,sing_time )
 %Plot MSV index 
 plot(time,[S; St_aug; Sr_aug]) %St; Sr; 
 xlabel('time (sec)')
 title('Minimum Singular Value')
 legend('MSV','MSV_{T aug}','MSV_{R aug}','Location','eastoutside','Orientation','vertical') %'JT','JR',
 hold on
 if option~=0
     p1=plot([time(1) time(end)],[wth(1) wth(1)],':k')      %Plot threshold 
     legend(p1,'Threshold')
     [ymin, xmin] = min(S(:));
     strmin = ['(min,t_m_i_n)=(',[num2str(ymin) ',' num2str(xmin/100)],')'];
     text(xmin/100,ymin,strmin,'VerticalAlignment','bottom');
     hold on
     ps=plot(xmin/100,ymin,'*black')
     legend(ps,'Minimum')
 else
     p1=plot([time(1) time(end)],[0.1 0.1],':k')
     hold on 
     p2=plot([time(1) time(end)],[S(sing_time) S(sing_time)],'--g') 
     legend(p1,'Threshold')
     legend(p2,'Singular point')
 end
 Tickvector=[0:0.05:0.3-0.05];
 Tickvector=[Tickvector,0.3:0.1:0.9];
 set(gca,'YTick',Tickvector);
 set(gca,'YTickLabelMode','manual');
 set(gca,'YTickLabel',Tickvector);
end

