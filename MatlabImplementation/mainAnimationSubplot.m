clear all;clc;close all

%%% Init corners
%%%%%%%%%%%%%%%%%%
nframes   = 80;
n_corners = 3;
a         = -3;
b         = 3;
m0        = zeros(3);

m1 = [b 0 0;
      0 0 0;
      0 0 b];
m2 = [b 0 b;
      0 0 0;
      b 0 b];
m3 = [b b b;
      0 0 0;
      b b b];
m4 = [b b b;
      b 0 b;
      b b b];
m5 = [b a b;
      a 0 a;
      b a b];
m6 = [a b a;
      b 0 b;
      a b a];

ma   = fun_matInterp2(m0,m1,nframes);
mb   = fun_matInterp2(m1,m2,nframes);
mc   = fun_matInterp2(m2,m3,nframes);
md   = fun_matInterp2(m3,m4,nframes);
me   = fun_matInterp2(m4,m5,nframes);
mf   = fun_matInterp2(m5,m6,nframes);

findGradient = {m0,m1,m2,m3,m4,m5,m6};
concat       = {ma,mb,mc,md,me,mf};
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
corners0 = m121(:,:,1);
%%% Generate tiles and compute gradient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Z       = fun_tiles2D(x,y,m121(:,:,1));
[gX,gY] = gradient(Z);
G       = sqrt(gX.^2+gY.^2);

%%% Init Video
%%%%%%%%%%%%%%%%%%
videoName       = [pwd,'\animations\','prueba1'];
video           = VideoWriter(videoName ,'MPEG-4');
video.Quality   = 80;
video.FrameRate = 40;
open(video);

%%% Init Figure
%%%%%%%%%%%%%%%%%%
set(gcf,'Position',[1 1 1800 900]);set(gcf,'color','w');

tile = tiledlayout(1,2,'TileSpacing','Compact','Padding','Compact');

nexttile

    hold on;box on;pbaspect([1 1 0.75])
    set(gca,'xticklabel',[]);set(gca,'yticklabel',[]);set(gca,'zticklabel',[])
    set(gca,'Xtick',[]);set(gca,'Ytick',[]);set(gca,'Ztick',[])
    axis([1 n_corners 1 n_corners a b])
    view(135,45)
    
    
    %%% Plot surface
    %%%%%%%%%%%%%%%%%%
    surface1=surf(X,Y,Z,G);
    surface1.FaceColor='interp';
    surface1.EdgeColor='k';
    surface1.FaceAlpha=1;
    surface1.LineWidth=0.25;
    colormap("jet")

    %%% Compute color limits
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    [cmin,cmax] = fun_color_limits(findGradient,x,y);
    kc          = 0;
    %%caxis([cmin cmax]+[ 0])
    caxis([-0.2 0.7])
    
    %%% Plot tiles border
    %%%%%%%%%%%%%%%%%%%%%%%%
    xVertical    = [xy(1)*ones(1,N),NaN,xy(end)*ones(1,N),NaN];
    yVertical    = [y              ,NaN,y                ,NaN];
    xHorizontal  = [x              ,NaN,x                ,NaN];
    yHorizontal  = [xy(1)*ones(1,N),NaN,xy(end)*ones(1,N),NaN];
    xMedium      = [xy(2)*ones(1,N),NaN,x                ,NaN];
    yMedium      = [y              ,NaN,xy(2)*ones(1,N)  ,NaN];
    xlines       = [xVertical, xHorizontal, xMedium];
    ylines       = [yVertical, yHorizontal, yMedium];
    zlines       = interp2(X,Y,Z,xlines,ylines);
    tilesBorder1 = plot3(xlines,ylines,zlines,'k',LineWidth=3);
    
    %%%  Scatter corners values
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Xxy,Yxy] = meshgrid(xy,xy);
    corners1   = scatter3(Xxy(:),Yxy(:),corners0(:),MarkerFaceColor='y',MarkerEdgeColor='k',SizeData=300);

    nexttile
      hold on;pbaspect([1 1 0.75]);axis off;
      set(gca,'xticklabel',[]);set(gca,'yticklabel',[]);set(gca,'zticklabel',[])
      set(gca,'Xtick',[]);set(gca,'Ytick',[]);set(gca,'Ztick',[])
      axis([1 n_corners 1 n_corners a b])
      view(135,90)
      

      %%% Plot surface
      %%%%%%%%%%%%%%%%%%
      surface2=surf(X,Y,zeros(N),G);
      surface2.FaceColor='interp';
      surface2.EdgeColor='k';
      surface2.FaceAlpha=1;
      surface2.LineWidth=0.5;
      colormap("jet")

      %%% Compute color limits
      %%%%%%%%%%%%%%%%%%%%%%%%%%%
      caxis([-0.2 0.7])

      %%% Plot tiles border
      %%%%%%%%%%%%%%%%%%%%%%%%
      xVertical    = [xy(1)*ones(1,N),NaN,xy(end)*ones(1,N),NaN];
      yVertical    = [y              ,NaN,y                ,NaN];
      xHorizontal  = [x              ,NaN,x                ,NaN];
      yHorizontal  = [xy(1)*ones(1,N),NaN,xy(end)*ones(1,N),NaN];
      xMedium      = [xy(2)*ones(1,N),NaN,x                ,NaN];
      yMedium      = [y              ,NaN,xy(2)*ones(1,N)  ,NaN];
      xlines       = [xVertical, xHorizontal, xMedium];
      ylines       = [yVertical, yHorizontal, yMedium];
      zlines       = interp2(X,Y,zeros(N),xlines,ylines);
      tilesBorder2 = plot3(xlines,ylines,zlines+1,'k',LineWidth=3);

      %%%  Scatter corners values
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      [Xxy,Yxy] = meshgrid(xy,xy);
      corners2   = scatter3(Xxy(:),Yxy(:),corners0(:)*0+2,MarkerFaceColor='y',MarkerEdgeColor='k',SizeData=300);
    


for k = 1:nframes


    %%% SUBPLOT 1
    %%%%%%%%%%%%%%%%%%

        %%% update surface
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        corners_mat    = m121(:,:,k);
        Z              = fun_tiles2D(x,y,corners_mat);
        [gX,gY]        = gradient(Z);
        G              = sqrt(gX.^2+gY.^2);
        surface1.ZData = Z;
        surface1.CData = G;
        
        %%% update tiles border
        %%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%
        zlines            = interp2(X,Y,Z,xlines,ylines);
        tilesBorder1.ZData = zlines;
        
        %%% update corners
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        corners1.ZData = corners_mat(:);


    %%% SUBPLOT 2
    %%%%%%%%%%%%%%%%%%

        %%% update surface
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        surface2.CData = G;

    drawnow limitrate

    frame = getframe(gcf);
    writeVideo(video,frame);

end

close(video);



