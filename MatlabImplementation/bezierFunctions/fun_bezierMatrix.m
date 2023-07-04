 

function M = fun_bezierMatrix(P)

    % this algorithm default M
    % M = [
    %      1    -2     1;
    %     -2     2     0;
    %      1     0     0];
    %
    %  p(t) = [t^2 t 1] * M * [p0x,p0y;   = [x,y]
    %                          p1x,p1y;
    %                          ...,...;
    %                          pnx,pny];
    
    % compute M
    %%%%%%%%%%%%%%
    N = length(P);
    n = N-1;
    M = zeros(N);
    
    for i = 0:n
        for j=0:n
    
            bool_i = i>=0 && i<=n;
            bool_j = j>=0 && j<=n-i;
    
            if(bool_i && bool_j)
                M(i+1,j+1) = fun_binomial(n,i)*fun_binomial(n-i,j)*(-1)^(n+i-j);
            end
    
        end
    end

end