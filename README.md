# 2D Piecewise Function Demo

## [LINK TO DEMO ...](https://geniosainz.github.io/2D-Piecewise-Function/)

This JavaScript based [demo](https://geniosainz.github.io/2D-Piecewise-Function/) is based on the video [``Painting a Landscape with Maths´´](https://www.youtube.com/watch?v=BFld4EBO2RE&t=157s) by [Inigo Quilez](https://iquilezles.org/) in which he explains how to generate a landscape procedurally by adding terrain, vegetation, clouds and lighting models.


 $$ 
 f_{ij}(x,y) = a_{ij}+
              (b_{ij}-a_{ij})S(x-i)+
              (c_{ij}-a_{ij})S(y-j)+
              (a_{ij}-b_{ij}-c_{ij}+
              d_{ij})S(x-i)S(y-j)
 $$

```js
let smoothstepFuns = {
                      smoothstep0: (t)=>  t,
                      smoothstep1: (t)=> -2*t**3+3*t**2,
                      smoothstep2: (t)=>  6*t**5-15*t**4+10*t**3,
                      smoothstep3: (t)=> -20*t**7+70*t**6-84*t**5+35*t**4,
```

<img src="docs/imgs/smoothstep.png"  width="100%">
<img src="docs/imgs/gif.gif"  width="100%">


shows graphically how Ken Perlin's [Improved Noise Algorithm](chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://mrl.cs.nyu.edu/~perlin/paper445.pdf) from 2002 works.  

I have used as main library [P5.js](https://p5js.org/) for the representation of all the elements that involve the main grid and [Plotly.js](https://plotly.com/javascript/) for the creation of the dynamic graphics.


## DEMO FEATURES

The demo shows how from an input point on the 2D grid 4 parameters are obtained by means of the dot product between:
- Gradient vectors at the corners of each cell.  These vectors are defined by the seed of the algorithm.
- The vectors defined by the entry point and the corners of each cell.

By interpolating these parameters, the output of the algorithm is finally obtained.


<img src="docs/imgs/img4.png"  width="100%">

<ul>
  <li><b>A:</b> Interpolations

  <ul>
    <li> Smoothstep interpolations: <i> U = Smoothstep( Xgrid ), V = Smoothstep( Ygrid ) </i></li>
    <li> Corners values graph:      <i> A,B,C,D                                          </i></li>
    <li> Lerp interpolations:       <i> AB = Lerp(U,A,B), CD = Lerp(U,C,D)               </i></li>
  </ul>

  </li>

  <li><b>B:</b> Input grid representing...
    <ul>
        <li> The gradient vectors of each corner</li>
        <li> The color map generated from the evaluation of the noise2D function for each pixel </li>
    </ul>
  </li>

  <li><b>C:</b> 1D Noise slices traces of the 2D noise by plotting the row/column YY/XX vectors defined by the input (x,y) coordinates.

  </li>

</ul>




