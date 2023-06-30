function s = fun_smoothstep_ab(t,x1,x2,y1,y2)

    b = min([1,(t-x1)/(x2-x1)]);
    k = max([0,b]);
    t = fun_smoothstep(k);
    s = (y2-y1)*t+y1;
end