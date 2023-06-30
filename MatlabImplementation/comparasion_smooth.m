clear all;clc;close all


x1 = 2;
x2 = 7;
y1 = 3;
y2 = 5;

n = 20;
X1 = linspace(x1,x2,n);
Y1 = zeros(1,n);

for i=1:n
    Y1(i) = fun_smoothstep_ab(X1(i),x1,x2,y1,y2);
end

x1 = 2;
x2 = 7;
y1 = 5;
y2 = 3;

n = 20;
X2 = linspace(x1,x2,n);
Y2 = zeros(1,n);

for i=1:n
    Y2(i) = fun_smoothstep_ab(X2(i),x1,x2,y1,y2);
end


hold on;grid on;box on
plot(X1,Y1,'r')
plot(X2,Y2,'b')

