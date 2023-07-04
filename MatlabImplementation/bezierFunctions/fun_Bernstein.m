function bin = fun_Bernstein(n,i,t)
          
         % b i,n(t)
         bin = fun_binomial(n,i)*(t^i)*(1-t)^(n-i);

end