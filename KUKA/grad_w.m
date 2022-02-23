function [a] = grad_w(q,KUKA,dir,J,option)
%find_best_W local search in the Cartesian frame
%   Find W in all directions of the Cartesian frame attached to the robot's
%   end-effector.

x_dv = 1;       %Apply a virtual velocity to the end effector
Dt=0.01;
direc = [1 -1]; %positive and negative direction
dn = length(q);
JT=J(1:3,:);
JR=J(4:6,:);

for m = 1:2     %For each direction
    x_dotv=[0 0 0 0 0 0]';
    x_dotv(dir)=x_dv*direc(m);
    qv=q + pinv(J)*x_dotv*Dt;
    Jnext = KUKA.jacobn(qv);
    JTnext = Jnext(1:3,:); 
    JRnext = Jnext(4:6,:);
    if (option<=1)
        if (dir<=3) %Strong translational manipulability
            now=sqrt(det( JT*(eye(dn,dn)-pinv(JR)*JR)*JT' ));
            next=sqrt(det( JTnext*(eye(dn,dn)-pinv(JRnext)*JRnext)*JTnext' )); 
            delta_w(m)= next-now;  
        else        %Strong rotational manipulability
            now=sqrt(det( JR*(eye(dn,dn)-pinv(JT)*JT)*JR' ));
            next=sqrt(det( JRnext*(eye(dn,dn)-pinv(JTnext)*JTnext)*JRnext' ));
            delta_w(m)= next-now;  
        end
    elseif (option==2)
        delta_w(m)=min(svd(Jnext)) - min(svd(J));
    elseif (option==3)
        delta_w(m)=1.0/(max(svd(Jnext))/min(svd(Jnext)))  -   1.0/(max(svd(J))/min(svd(J)));
    end
      
    if (delta_w(m))<0
        delta_w(m)=0;
    end
end

[a, index_of_sign] = max(delta_w);
a = a*direc(index_of_sign);  
end
