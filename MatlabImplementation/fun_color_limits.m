
function [cmin,cmax] = fun_color_limits(list_mat,x,y)

        n         = length(list_mat);
        vmin      = zeros(1,n);
        vmax      = zeros(1,n);

        for i = 1:n
            
            corners = list_mat{i};
            Z       = fun_tiles2D(x,y,corners);
            [gX,gY] = gradient(Z);
            G       = sqrt(gX.^2+gY.^2);
            vmin(i) = min(G(:));
            vmax(i) = max(G(:));
        end

        cmin = min(vmin);
        cmax = max(vmax);
end