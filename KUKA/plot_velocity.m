function [] = plot_velocity( time,taxythta )
   %Plot velocity
   plot(time,taxythta)
   xlabel('time (sec)')
   ylabel('rad/s')
   title('Joint Velocities ($\dot{q}$)','interpreter','latex')
   legend('1','2','3','4','5','6','7','Location','eastoutside','Orientation','vertical')

   [ymin, xmin] = max(abs(taxythta(:)));
   if taxythta(xmin)>=0
       strmin = ['',num2str(ymin)];
       text(xmin/700,ymin,strmin,'VerticalAlignment','top');
       hold on
       ps=plot(xmin/700,ymin,'ro')
       legend(ps,'Maximum')
   else
       strmin = ['',num2str(-ymin)];
       text(xmin/700,-ymin,strmin,'VerticalAlignment','top');
       hold on
       ps=plot(xmin/700,-ymin,'ro')
       legend(ps,'Minimum')
   end
end
