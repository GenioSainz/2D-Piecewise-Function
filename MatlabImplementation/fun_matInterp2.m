function m12 = fun_matInterp2(m1,m2,N)
    
    n   = length(m1);
    m12 = zeros(n,n,N);

    for k = 1:N
        for i = 1:n
            for j=1:n
  
            % fun_smoothstep_ab(t,x1,x2,y1,y2)
            m12(i,j,k)= fun_smoothstep_ab(k,1,N,m1(i,j),m2(i,j));
          
            end
        end
    end
end