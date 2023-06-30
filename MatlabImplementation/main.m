clear all;clc;close all

%%% Init corners
%%%%%%%%%%%%%%%%%%

n_corners   = 3;
a           = -1;
b           = 1;

% corners_mat = a + (b-a)*rand(n_corners);
m1 = [a b a;
      b a b;
      a b a];

corners_mat = m1;
%%% Init vectors and matrix of coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N        = 41;
xy       = 1:n_corners;
x        = linspace(1,n_corners,N);
y        = linspace(1,n_corners,N);
[X,Y]    = meshgrid(x,y);

%%% Generate tiles and compute gradient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Z       = fun_tiles2D(x,y,corners_mat);
[gX,gY] = gradient(Z);
G       = sqrt(gX.^2+gY.^2);

%%% Init Figure
%%%%%%%%%%%%%%%%%%
set(gcf,'Position',[0 0 1600 900]);set(gcf,'color','w');
hold on;box on;grid on;xlabel('X');ylabel('Y');zlabel('Z');pbaspect([1 1 0.5])
title('2D FUNCTION FORMED BY 4 TILES')
view(135,45)
%%% Plot surface
%%%%%%%%%%%%%%%%%%
h=surf(X,Y,Z,G);
h.FaceColor='interp';
h.EdgeColor='k';
h.FaceAlpha=0.75;
h.LineWidth=0.25;
colormap("hsv")

%%% Plot tiles border
%%%%%%%%%%%%%%%%%%%%%%%%
xVertical   = [xy(1)*ones(1,N),NaN,xy(end)*ones(1,N),NaN];
yVertical   = [y              ,NaN,y                ,NaN];
xHorizontal = [x              ,NaN,x                ,NaN];
yHorizontal = [xy(1)*ones(1,N),NaN,xy(end)*ones(1,N),NaN];
xMedium     = [xy(2)*ones(1,N),NaN,x                ,NaN];
yMedium     = [y              ,NaN,xy(2)*ones(1,N)  ,NaN];
xlines      = [xVertical, xHorizontal, xMedium];
ylines      = [yVertical, yHorizontal, yMedium];
zlines      = interp2(X,Y,Z,xlines,ylines);
plot3(xlines,ylines,zlines,'k',LineWidth=3)

%%%  Scatter corners values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Xxy,Yxy] = meshgrid(xy,xy);
scatter3(Xxy(:),Yxy(:),corners_mat(:),MarkerFaceColor='y',MarkerEdgeColor='k',SizeData=300)




