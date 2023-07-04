clear all;clc;close all

% P = [ 1,1;
%       6,4;
%       11,1];

x = 1:2:12;
w = 5;
y = x -2*w*rand(1,length(x))+w;
P = [x',y'];

tVec = linspace(0,1,20);
B1 = fun_bezierFun2D(P,tVec);
B2 = fun_bezierMatrixForm(P,tVec,fun_bezierMatrix(P));

hold on;box on;grid on

scatter(P(:,1),P(:,2),MarkerFaceColor='r',MarkerEdgeColor='k')

plot(B1(:,1),B1(:,2),'b.')
plot(B2(:,1),B2(:,2),'r')



