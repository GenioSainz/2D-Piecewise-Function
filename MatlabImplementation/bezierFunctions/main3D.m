clear all;clc;close all


x     = 1:6;
y     = 8:14;
[X,Y] = meshgrid(x,y);
m     = length(y);
n     = length(x);

Z      = zeros(m,n);
Z(1,:) = [1,2,3,3,2,1];
Z(2,:) = Z(1,:)+1;
Z(3,:) = Z(1,:)+2;
Z(4,:) = Z(1,:)+2;
Z(5,:) = Z(1,:)+2;
Z(6,:) = Z(1,:)+1;
Z(7,:) = Z(1,:);

noiseA = 0.5;
Z      = Z + 2*noiseA*rand(m,n)-noiseA;

P(:,:,1) = X;
P(:,:,2) = Y;
P(:,:,3) = Z;


u_vec = linspace(0,1,21);
v_vec = linspace(0,1,50);

B = fun_bezierFun3D(P,u_vec,v_vec);


hold on;box on;grid on;daspect([1 1 1]);xlabel('X');ylabel('Y');zlabel('Z');

axis([min(X(:)) max(X(:)) min(Y(:)) max(Y(:)) min(Z(:)) max(Z(:))  ]+ [-1 1 -1 1 -1 1])

view(-45,20)

%%% Input grid
%%%%%%%%%%%%%%%%%
mesh(X,Y,Z             ,FaceColor='none',EdgeColor='r',LineWidth=1.5)
scatter3(X(:),Y(:),Z(:),MarkerFaceColor='b',MarkerEdgeColor='k',SizeData=50)

%%% Bezier surface
%%%%%%%%%%%%%%%%%%%%%
mesh(B(:,:,1),B(:,:,2),B(:,:,3),EdgeColor='k',FaceColor='flat',FaceAlpha=0.7)



