function z = fun_evalTile(xj,yi,corners_mat)
         
         n = length(corners_mat);
         i = floor(yi); if(i==n);i=n-1;end
         j = floor(xj); if(j==n);j=n-1;end

         a = corners_mat(i,j);
         b = corners_mat(i,j+1);
         c = corners_mat(i+1,j);
         d = corners_mat(i+1,j+1);
         
         xfactor  = (b-a)*fun_smoothstep(xj-j);
         yfactor  = (c-a)*fun_smoothstep(yi-i);
         xyfactor = (a-b-c+d)*fun_smoothstep(xj-j)*fun_smoothstep(yi-i);
         
         z = a + xfactor + yfactor + xyfactor;
         
         %fprintf('(i,j)=(%d,%d) (%0.3f,%0.3f,%0.3f,%0.3f)-->(y,x)=(%0.3f,%0.3f)\n',i,j,a,b,c,d,yn,xn)
end