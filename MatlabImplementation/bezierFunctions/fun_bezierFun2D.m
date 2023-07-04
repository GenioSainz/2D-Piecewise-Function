function bezierVec = fun_bezierFun2D(P,tVec)
        
            % inputs:
            % P = [p1x,p1y;
            %      p2x,p2y,
            %      ...,...
            %      pnx,pny];
            % tvec  = linspace(0,1,nt)
            
            % outputs:
            % bezierVec [p1x,p1y;
            %            ........
            %            ...,...
            %            pnx,pny]; length => nt
            
            n         = length(P)-1;
            nt        = length(tVec);
            bezierVec = zeros(nt,2);
    
            for k = 1:nt
                for i = 0:n
                    
                    Pi             = P(i+1,:);
                    t              = tVec(k);
                    bezierVec(k,:) = bezierVec(k,:) +  Pi*fun_Bernstein(n,i,t);
                end
            end
         
end

