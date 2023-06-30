function m12 = fun_matInterp1(m1,m2,N)

    n   = length(m1);
    m12 = zeros(n,n,N);

    for k = 1:N
        for i = 1:n
            for j=1:n
   
            lineal  = linspace(m1(i,j),m2(i,j),N);
            m12(i,j,k)= lineal(k);
          
            end
        end
    end
end