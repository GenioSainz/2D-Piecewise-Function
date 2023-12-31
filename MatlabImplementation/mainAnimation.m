clear all;clc;close all

%%% Init corners
%%%%%%%%%%%%%%%%%%
nframes   = 50;
n_corners = 3;
a         = -3;
b         = 3;
% m1 = a + (b-a)*rand(3);
% m2 = a + (b-a)*rand(3);

% m0 = zeros(3);
% m1 = [a b a;
%       b a b;
%       a b a];
% m2 = [b a b;
%       a b a;
%       b a b];
% m3 = a + (b-a)*rand(3);
% m4 = a + (b-a)*rand(3);

% m0 = zeros(3);
% 
% m1 = [b 0 0;
%       0 0 0;
%       0 0 b];
% m2 = [b 0 b;
%       0 0 0;
%       b 0 b];
% m3 = [b b b;
%       0 0 0;
%       b b b];
% m4 = [b b b;
%       b 0 b;
%       b b b];
% m5 = [b a b;
%       a 0 a;
%       b a b];
% m6 = [a b a;
%       b 0 b;
%       a b a];

m0 = zeros(3);
m1 = [a a a;
      a b a;
      a a a];
m2 = [b b b;
      b a b;
      b b b];
m3 = [b a b;
      a 0 a;
      b a b];
m4 = [a b a;
      b 0 b;
      a b a];


ma   = fun_matInterp2(m0,m1,nframes);
mb   = fun_matInterp2(m1,m2,nframes);
mc   = fun_matInterp2(m2,m3,nframes);
md   = fun_matInterp2(m3,m4,nframes);


findGradient = {m0,m1,m2,m3,m4};
concat       = {ma,mb,mc,md};
m121         = cat(3,concat{:});
[f,c,rgb]    = size(m121);
nframes      = rgb;

%%% Init vectors and matrix of coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N        = 41;
xy       = 1:n_corners;
x        = linspace(1,n_corners,N);
y        = linspace(1,n_corners,N);
[X,Y]    = meshgrid(x,y);

%%% Generate tiles and compute gradient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Z       = fun_tiles2D(x,y,m121(:,:,1));
[gX,gY] = gradient(Z);
G       = sqrt(gX.^2+gY.^2);

%%% Init Video
%%%%%%%%%%%%%%%%%%
videoName       = [pwd,'\animations\','prueba600'];
video           = VideoWriter(videoName ,'MPEG-4'); 
video.Quality   = 80;
video.FrameRate = 15;
open(video);

%%% Init Figure
%%%%%%%%%%%%%%%%%%
set(gcf,'Position',[1 1 800 800]);set(gcf,'color','w');

hold on;pbaspect([1 1 0.75])
box on;%ax = gca;ax.BoxStyle = 'full';
set(gca,'xticklabel',[]);set(gca,'yticklabel',[]);set(gca,'zticklabel',[])

axis([1 n_corners 1 n_corners a b])
view(135,45)

camzoom(1.2)

%%% Plot surface
%%%%%%%%%%%%%%%%%%
surface=surf(X,Y,Z,G);
surface.FaceColor='interp';
surface.EdgeColor='k';
surface.FaceAlpha=1;
surface.LineWidth=0.25;
colormap("jet");

%%% Compute color limits
%%%%%%%%%%%%%%%%%%%%%%%%%%%
[cmin,cmax] = fun_color_limits(findGradient,x,y);
kc          = 0;
%%caxis([cmin cmax]+[ 0])
caxis([-0.2 0.7])

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
tilesBorder = plot3(xlines,ylines,zlines,'k',LineWidth=3);

%%%  Scatter corners values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Xxy,Yxy] = meshgrid(xy,xy);
Zxy       = m121(:,:,1);
corners   = scatter3(Xxy(:),Yxy(:),Zxy(:),MarkerFaceColor='y',MarkerEdgeColor='k',SizeData=300);

for k = 1:nframes
   
    %%% update surface
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    corners_mat   = m121(:,:,k);
    Z             = fun_tiles2D(x,y,corners_mat);
    [gX,gY]       = gradient(Z);
    G             = sqrt(gX.^2+gY.^2);
    surface.ZData = Z;
    surface.CData = G;
    
    %%% update tiles border
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    zlines            = interp2(X,Y,Z,xlines,ylines);
    tilesBorder.ZData = zlines;
    
    %%% update corners
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    corners.ZData = corners_mat(:);

    drawnow limitrate

    frame = getframe(gcf);
    writeVideo(video,frame);

end

close(video);



