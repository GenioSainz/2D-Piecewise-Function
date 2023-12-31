# 2D Piecewise Function Demo

## [LINK TO DEMO ...](https://geniosainz.github.io/2D-Piecewise-Function/)

This [demo](https://geniosainz.github.io/2D-Piecewise-Function/) implemented in JavaScript is based on the amazing video [``Painting a Landscape with Maths´´](https://www.youtube.com/watch?v=BFld4EBO2RE&t=157s) by [Inigo Quilez](https://iquilezles.org/) in which he explains how to generate a landscape procedurally by adding terrain, vegetation, clouds and lighting models. The demo focuses on the part of the video where Iñigo models the terrain as a piecewise surface formed by square tiles. This tiles are defined by the value of their corners and by the functions that ensures connectivity between adjacent tiles. The demo allows the user to modify the functions and the value of the corners, thus varying the shape of the surface.

To guarantee the connectivity between the tiles $f_{ij}$, the value of the grid corners $a,b,c,d$ of the shared cells has to be fixed. The connectivity is done in a smooth way using the [smoothstep](https://en.wikipedia.org/wiki/Smoothstep#:~:text=The%20function%20receives%20a%20real,is%20zero%20at%20both%20edges.) family of functions $S$.

$$\begin{eqnarray} 
     f_{ij}(x,y) = a_{ij} & + & (b_{ij}-a_{ij})S(x-i)+(c_{ij}-a_{ij})S(y-j) \\
                          & + & (a_{ij}-b_{ij}-c_{ij}+d_{ij})S(x-i)S(y-j)
\end{eqnarray}$$


Smoothstep family of curves:
<img src="docs/imgs/smoothstep.png"  width="100%">
```js
let S = {
         smoothstep0: (x)=>  x,
         smoothstep1: (x)=> -2*x**3+3*x**2,
         smoothstep2: (x)=>  6*x**5-15*x**4+10*x**3,
         smoothstep3: (x)=> -20*x**7+70*x**6-84*x**5+35*x**4,
        }                     
```

Shape of the functions:
<img src="docs/imgs/smoothsteps.png"  width="100%">

Smoothstep in generalised form for an interval a,b.
<img src="docs/imgs/smoothstepAB.png"  width="100%">
## DEMO FEATURES

The demo uses [dat.GUI](https://github.com/dataarts/dat.gui) and allows:

- Vary the aspect ratio of the surface.
- Vary colour map and mode according to height or slope.
- The possibility to choose between the four smoothstep functions by modifying the interpolation and thus varying the shape of the surface. I have included the smoothstep0 function (linear function) to demonstrate that the connectivity is not smooth.
- The possibility to choose from predefined surface shapes.
- The possibility to change the value of the shared corners by means of sliders, thus modifying the local shape of the surface.

<p align="center"><img src="docs/imgs/gui.PNG"  width="40%"></p>

To represent the colour map as a function of slope it is necessary to calculate numerically the gradient of the tiles. It can be computed by convolution with the X,Y kernels.

<img src="docs/imgs/gradient.png"  width="100%">

```js
// let values = [[a,b,c],
//               [d,e,f],
//               [g,h,i],];

let values = [[Z[i-1][j-1],Z[i-1][j],Z[i-1][j+1]],
              [Z[i  ][j-1],Z[i  ][j],Z[i  ][j+1]],
              [Z[i+1][j-1],Z[i+1][j],Z[i+1][j+1]],];

let kernels = { X: [[-1,0,1],
                    [-2,0,2],
                    [-1,0,1]],

                Y: [[-1,-2,-1],
                    [ 0, 0, 0],
                    [ 1, 2, 1]],
               }; 

let Gx = sum(values * kernels.X);
let Gy = sum(values * kernels.Y);
let G  = Math.sqrt( Gx**2 + Gy**2 );

                                
```

## MATLAB IMPLEMENTATION

I have programmed some Matlab scripts to generate animations of transitions of different values of the grid corners. In these examples the colour map is defined by the module of the gradient vector of the surface, giving a sense of how deformed the surface is.

<img src="docs/imgs/image2.png"  width="100%">
<img src="docs/imgs/gif.gif"     width="100%">











