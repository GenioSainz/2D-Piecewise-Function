
clear all;clc;close all


t = linspace(0,1);


set(gcf,'Position',[1 1 1000 1000]);set(gcf,'color','w');
hold on;box on;grid on;daspect([1,1,1]);

LW = 2;
plot(t,smoothstep1(t),'LineWidth',LW,'DisplayName','Smoothstep1')
plot(t,smoothstep2(t),'LineWidth',LW,'DisplayName','Smoothstep2')
plot(t,smoothstep3(t),'LineWidth',LW,'DisplayName','Smoothstep3')
plot(t,t,'LineWidth',LW,'DisplayName','Linear')

l = legend;
l.Location = 'northwest';
l.FontSize = 20;


function y = smoothstep1(t)

         y = 3*t.^2-2*t.^3;
end


function y = smoothstep2(t)

         y = 6*t.^5-15*t.^4+10*t.^3;
end

function y = smoothstep3(t)
         
         y = -20*t.^7+70*t.^6-84*t.^5+35*t.^4 ;
end







