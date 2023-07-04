

function bezierVec = fun_bezierMatrixForm(P,tVec,M)
   
   % eval bezierVec
   %%%%%%%%%%%%%%%%%%%
   k         = length(tVec);
   bezierVec = zeros(k,2);

   n    = length(P)-1;
   powt = [n:-1:1];

   for i=1:k
        
       t = tVec(i);

       bezierVec(i,:) = [t.^powt 1]*M*P;
       
   end

end