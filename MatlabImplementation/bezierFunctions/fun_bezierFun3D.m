function B = fun_bezierFun3D(P,u_vec,v_vec)

            %S(u,v) = E(i=0:m)E(j=0:n) P_ij * B_im(u) * B_nj(v)
        
    % inputs:
    % P(n,m,rgb)
    % P(:,:,1) = X;
    % P(:,:,2) = Y;
    % P(:,:,3) = Z;
    % u_vec    = linspace(0,1,u_len)
    % v_vec    = linspace(0,1,v_len)
    
    % outputs:
    % B(v_len,u_len,1) = x;
    % B(v_len,u_len,2) = y;
    % B(v_len,u_len,3) = z;


     % inputs size
     %%%%%%%%%%%%%%%%%%%%%%%%%%%
    [m,n,~] = size(P);
     m      = m-1;
     n      = n-1;

     u_len  = length(u_vec);
     v_len  = length(v_vec);
     B      = zeros(v_len,u_len,3); 

     for vj = 1:v_len
        for ui = 1:u_len

                sum_ij = zeros(1,3);
                u      = u_vec(ui);
                v      = v_vec(vj);

                for i = 0:m
                    for j = 0:n
                    
                        Pij    = [P(i+1,j+1,1),P(i+1,j+1,2),P(i+1,j+1,3)];
                        sum_ij = sum_ij + Pij * fun_Bernstein(m,i,u) * fun_Bernstein(n,j,v);
    
                    end
                end

                B(vj,ui,:) = sum_ij;
        end
     end

         
end



