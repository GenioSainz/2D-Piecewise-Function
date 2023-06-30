
function Z = fun_tiles2D(x,y,corners_mat)

        Z   = zeros(length(corners_mat));
        
        for i = 1:length(y)
            for j = 1:length(x)

                Z(i,j) = fun_evalTile(x(j),y(i),corners_mat);
            end
        end
end
    