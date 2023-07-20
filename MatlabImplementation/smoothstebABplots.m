clear all;clc;close all


xm = 8;
x  = linspace(-xm,xm,1000);
set(gcf,'position',[0 0 1000 1000])

set(gcf,'color','w');
ti = tiledlayout(3,2,TileSpacing = 'compact',Padding = 'compact');
title(ti,{'$s = 3k^2-2k^3$';''},'Interpreter','latex',FontSize=22)

a = 0;
b = 4;
k = max(0,min(1,(abs(x)-a)./(b-a)));
s = 3*k.^2-2*k.^3;
txt ={'$k=\max(0,\min(1,\frac{abs(x)-a}{b-a}))$';['$ a=',num2str(a),';b=',num2str(b),'$']};
plotSmoothstep(a,b,x,k,s,xm,txt)

a = 4;
b = 0;
k = max(0,min(1,(abs(x)-a)./(b-a)));
s = 3*k.^2-2*k.^3;
txt ={'$k=\max(0,\min(1,\frac{abs(x)-a}{b-a}))$';['$ a=',num2str(a),';b=',num2str(b),'$']};
plotSmoothstep(a,b,x,k,s,xm,txt)


a = 2;
b = 6;
k = max(0,min(1,(abs(x)-a)./(b-a)));
s = 3*k.^2-2*k.^3;
txt ={'$k=\max(0,\min(1,\frac{abs(x)-a}{b-a}))$';['$ a=',num2str(a),';b=',num2str(b),'$']};
plotSmoothstep(a,b,x,k,s,xm,txt)

a = 6;
b = 2;
k = max(0,min(1,(abs(x)-a)./(b-a)));
s = 3*k.^2-2*k.^3;
txt ={'$k=\max(0,\min(1,\frac{abs(x)-a}{b-a}))$';['$ a=',num2str(a),';b=',num2str(b),'$']};
plotSmoothstep(a,b,x,k,s,xm,txt)

a = 2;
b = 6;
t = 1;
k = max(0,min(1,(abs(x-t)-a)./(b-a)));
s = 3*k.^2-2*k.^3;
txt ={'$k=\max(0,\min(1,\frac{abs(x-t)-a}{b-a}))$';['$ a=',num2str(a),';b=',num2str(b),';t=',num2str(t),'$']};
plotSmoothstep(a+t,b+t,x,k,s,xm,txt)

a = 6;
b = 2;
t = 1;
k = max(0,min(1,(abs(x-t)-a)./(b-a)));
s = 3*k.^2-2*k.^3;
txt ={'$k=\max(0,\min(1,\frac{abs(x-t)-a}{b-a}))$';['$ a=',num2str(a),';b=',num2str(b),';t=',num2str(t),'$']};
plotSmoothstep(a+t,b+t,x,k,s,xm,txt)

function plotSmoothstep(a,b,x,k,s,xm,txt)
    
    miny = -0.5;
    maxy = 1.5;
    
    nexttile
    hold on;box on;grid on;axis([-xm xm miny maxy]);
    daspect([4 1 1]);xticks(-xm:xm)

    ax = gca;
    ax.XAxisLocation = 'origin';
    ax.YAxisLocation = 'origin';

    plot(x,k,'b','DisplayName','k')
    plot(x,s,'r--','DisplayName','s')
    legend('NumColumns',2,AutoUpdate = 'off',FontSize=14);

    scatter([a b],[0 0],MarkerFaceColor='r',MarkerEdgeColor='k',SizeData=50);
    text([a b],[0 0]+miny+0.15,{'a';'b'}, ...
        HorizontalAlignment='center', ...
        BackgroundColor='w', ...
        FontSize=12);

    title(txt,'Interpreter','latex',FontSize=16);
    legend(FontSize=10)
end
