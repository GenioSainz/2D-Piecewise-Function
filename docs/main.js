
// Divs Vars
//////////////
var id_plot  = 'id_plot';
var divPad   = 25;
var guiWidth = 250

var divSizeW
var divSizeH

function setup() {
    
    createCanvas(windowWidth,windowHeight);
    background(0);

    var div_plot = createDiv('').id(id_plot).style('border','1px black solid'); 

    if(windowWidth>windowHeight){
            divSizeH = windowHeight - 2*divPad;
            divSizeW = windowWidth  - 2*divPad - guiWidth;
            div_plot.position(windowWidth/2-divSizeW/2-guiWidth/2,divPad)
    }else{
            divSizeH = windowHeight/2 - 2*divPad;
            divSizeW = windowWidth    - 2*divPad;
            div_plot.position(windowWidth/2-divSizeW/2,windowHeight/4)
    }
};

// Corners Vars
//////////////////
var nCorners    = 3;
var nGrid       = 41;
var cornersMin  = -5;
var cornersMax  =  5;
var cornersStep = 1;

var x      = tf.linspace(0,nCorners-1,nGrid).arraySync();
var y      = tf.linspace(0,nCorners-1,nGrid).arraySync();
var [X, Y] = tf.meshgrid(x, y);
     X     = X.arraySync();
     Y     = Y.arraySync();

var shapes = {
                shape0: [[0,0,0],[0,0,0],[0,0,0]],
                shape1: [[cornersMax,cornersMax,cornersMax],[cornersMax,cornersMin,cornersMax],[cornersMax,cornersMax,cornersMax]],
                shape2: [[cornersMin,cornersMin,cornersMin],[cornersMin,cornersMax,cornersMin],[cornersMin,cornersMin,cornersMin]],
                shape3: [[cornersMin,cornersMax,cornersMin],[cornersMax,0,cornersMax],[cornersMin,cornersMax,cornersMin]],
                shape4: [[cornersMax,cornersMin,cornersMax],[cornersMin,0,cornersMin],[cornersMax,cornersMin,cornersMax]],
                random1: randomCornes,
                random2: randomCornes
             };

var guiVars = {
                corner_A: 0,
                corner_B: 0,
                corner_C: 0,
                corner_D: 0,
                corner_E: 0,
                corner_F: 0,
                corner_G: 0,
                corner_H: 0,
                corner_I: 0,
                mode:'shape1'
};


// Initial Corners Mat from guiVar
////////////////////////////////////
var initCornerMat      = shapes[guiVars.mode].flat();
var guiVarsCornersKeys = Object.keys(guiVars).filter((key) => key.includes('corner_'));
   
    guiVarsCornersKeys.forEach( (corner,indx)=> {
                       guiVars[corner] = initCornerMat[indx];
    });


// Gui creation
//////////////////
var gui   = new dat.gui.GUI({width:guiWidth});

// Folders MODES
///////////////////
var folderShapes = gui.addFolder('Shapes');
    folderShapes.add(guiVars, 'mode', [ 'random1','random2','shape0','shape1', 'shape2', 'shape3','shape4'] ).onChange( function(shape) {

                                                                                        if(shape=='random1' || shape=='random2' ){

                                                                                            setCornersMat(shapes[shape]());
                                                                                            updatePlots_traces( getCornersMat() );
                                                                                        }else{
                                                                                            setCornersMat(shapes[shape]);
                                                                                            updatePlots_traces( getCornersMat() );
                                                                                        }
                                                                                   });
// Folder Corners SLIDER
//////////////////////////
var folderSliders = gui.addFolder('CornersValues');
var sliders  = Object.keys(guiVars).filter((key) => key.includes('corner_'))

    sliders.forEach( slider => {

        folderSliders.add(guiVars,slider,cornersMin,cornersMax,cornersStep).onChange( function(){ 
        
                                                                                                 updatePlots_traces( getCornersMat() ) ;
                                                                                            })
    });

// Open guis
///////////////
setTimeout(()=>{folderShapes.open()},1000);
setTimeout(()=>{folderSliders.open()},2000);
    
// Initial Corners Mat and Plot
//////////////////////////////////
setTimeout(()=>{
            
            // Init corners mat
            var cornersMat = shapes[guiVars.mode]
  
            // Init layout data
            var tiles   = getTraces_tiles2D(x,y,cornersMat);
            var corners = getTraces_corners(cornersMat);
            var grid    = getTraces_grid(cornersMat,tiles.z)
            var data    = [tiles,corners,grid]
            init_layout(data)
},100);


function getCornersMat(){
    
    var cornersMat = [[],[],[]]
    var slider_indx = 0;
    for(let i=0;i<nCorners;i++){
        for(let j=0;j<nCorners;j++){

            cornersMat[i][j] = folderSliders.__controllers[slider_indx++].getValue();
        };
    };

    return cornersMat
};

function setCornersMat(mat){

    // Slider.setvalue(n) is not used to avoid triggering events, thus avoiding performance losses.
    // updates based on 
    // var slider_indx = 0;
    // for(let i=0;i<nCorners;i++){
    //     for(let j=0;j<nCorners;j++){

    //         //folderSliders.__controllers[slider_indx++].setValue(mat[i][j]).updateDisplay();
    //     };
    // };
    
    var cornersMat         = mat.flat()
    var guiVarsCornersKeys = Object.keys(guiVars).filter((key) => key.includes('corner_'));
        guiVarsCornersKeys.forEach( (corner,indx)=> {
                        guiVars[corner] = cornersMat[indx];
                        folderSliders.__controllers[indx].updateDisplay();
      })
};

function randomCornes() {

    min = Math.ceil(cornersMin);
    max = Math.floor(cornersMax);

    var mat = [[],[],[]]

    for(let i=0;i<nCorners;i++){
        for(let j=0;j<nCorners;j++){

            mat[i][j] = Math.floor(Math.random() * (max - min + 1) + min);
        };
    };
    return mat
};

function fun_evalTile(xj,yi,corners_mat){
         

    var i = Math.floor(yi);
    var j = Math.floor(xj);

    var a = corners_mat[i  ][j  ];
    var b = corners_mat[i  ][j+1];
    var c = corners_mat[i+1][j  ];
    var d = corners_mat[i+1][j+1];
    
    var xfactor  = (b-a)*fun_smoothstep(xj-j);
    var yfactor  = (c-a)*fun_smoothstep(yi-i);
    var xyfactor = (a-b-c+d)*fun_smoothstep(xj-j)*fun_smoothstep(yi-i);
    
    return a + xfactor + yfactor + xyfactor;
};

function getTraces_tiles2D(x,y,corners_mat){
        
        var Z = tf.zeros([nGrid,nGrid]).arraySync();
        
        for(let i=0;i<nGrid;i++){
            for(let j=0;j<nGrid;j++){

                Z[i][j] = fun_evalTile(x[j],y[i],corners_mat);
            };
        };

        var dataTiles = { 
                          name:'Surface',
                          opacity:1, 
                          showlegend: true,
                          type: 'surface', 
                          colorscale:'Jet',
                          colorbar:{x:-0.15,
                                    len:0.6,title:{ text:'',side:'right',font:{size:16}},
                                    bgcolor:"rgb(150,150,150)",
                                    bordercolor:"white",
                                    borderwidth:2,
                                },
                          x: x,
                          y: y,
                          z: Z,
                          contours: {
                            z: {
                                show:true,
                                project:{z: false,usecolormap: false,},
                                highlightwidth:10,highlightcolor:"white",
                                start:cornersMin, end:cornersMax, size: 0.25}}
                        };

        return dataTiles
};

function getTraces_corners(cornersMat){

            var xy     = [0,1,2];
            var [X, Y] = tf.meshgrid(xy, xy);
            X          = X.reshape([1, 9]).arraySync()[0];
            Y          = Y.reshape([1, 9]).arraySync()[0];
            var Z      = tf.tensor(cornersMat).reshape([1, 9]).add(0.1).arraySync()[0];

            var scatterCorners = {
                            
                    name:'Corners',
                    x: X,
                    y: Y,
                    z: Z,
                    type: 'scatter3d',
                    mode: 'markers+text',
                    text: ['A','B','C','D','E','F','G','H','I'],
                    textfont:{size:20,color:'rgb(255,0,255)'},
                    showlegend:true,
                    legendgroup: 'Corners',
                    marker: { color: 'rgb(255,255,0)',symbol: 'circle',opacity: 1,size: 12,line: {color: 'rgb(0,0,0)',width: 1}}


                    };

            return scatterCorners 
};

function getTraces_grid(corners_mat,Z){
    

    var xy   = tf.linspace(0,nCorners-1,nGrid).arraySync();
    var xy0  = tf.ones([1,nGrid]).mul(0).arraySync()[0];
    var xy1  = tf.ones([1,nGrid]).mul(1).arraySync()[0];
    var xy2  = tf.ones([1,nGrid]).mul(2).arraySync()[0]
    var zy0  = Z[0];
    var zy1  = Z[20];
    var zy2  = Z[40];
    var zx0  = Z.map(row => row[0]);
    var zx1  = Z.map(row => row[20]);
    var zx2  = Z.map(row => row[40]);
    var zMin = tf.ones([nGrid,nGrid]).mul(cornersMin).arraySync()[0]
    
    var U    = undefined

    var A = {x:[0,0,U],y:[0,0,U],z:[cornersMin,corners_mat[0][0],U]} 
    var B = {x:[1,1,U],y:[0,0,U],z:[cornersMin,corners_mat[0][1],U]} 
    var C = {x:[2,2,U],y:[0,0,U],z:[cornersMin,corners_mat[0][2],U]}
    
    var D = {x:[0,0,U],y:[1,1,U],z:[cornersMin,corners_mat[1][0],U]} 
    var E = {x:[1,1,U],y:[1,1,U],z:[cornersMin,corners_mat[1][1],U]} 
    var F = {x:[2,2,U],y:[1,1,U],z:[cornersMin,corners_mat[1][2],U]}

    var G = {x:[0,0,U],y:[2,2,U],z:[cornersMin,corners_mat[2][0],U]} 
    var H = {x:[1,1,U],y:[2,2,U],z:[cornersMin,corners_mat[2][1],U]} 
    var I = {x:[2,2,U],y:[2,2,U],z:[cornersMin,corners_mat[2][2],U]} 

               // y = cte                  // x = cte
    var gridx_3D  = [ ...xy ,U,...xy ,U,...xy , U,...xy0,U,...xy1,U,...xy2,U]
    var gridy_3D  = [ ...xy0,U,...xy1,U,...xy2, U,...xy ,U,...xy ,U,...xy ,U]
    var gridz_3D  = [ ...zy0,U,...zy1,U,...zy2, U,...zx0,U,...zx1,U,...zx2,U]

    var gridx_2D  = [ ...xy  ,U,...xy  ,U,...xy ,  U,...xy0 ,U,...xy1 ,U,...xy2,U]
    var gridy_2D  = [ ...xy0 ,U,...xy1 ,U,...xy2,  U,...xy  ,U,...xy  ,U,...xy ,U]
    var gridz_2D  = [ ...zMin,U,...zMin,U,...zMin, U,...zMin,U,...zMin,U,...zMin,U]

    var cornersX  = [ ...A.x,...B.x,...C.x,...D.x,...E.x,...F.x,...G.x,...H.x,...I.x];
    var cornersY  = [ ...A.y,...B.y,...C.y,...D.y,...E.y,...F.y,...G.y,...H.y,...I.y];
    var cornersZ  = [ ...A.z,...B.z,...C.z,...D.z,...E.z,...F.z,...G.z,...H.z,...I.z];
    
    var grid = {
                name:'Grid',
                x: [...gridx_3D,...gridx_2D,...cornersX],
                y: [...gridy_3D,...gridy_2D,...cornersY],
                z: [...gridz_3D,...gridz_2D,...cornersZ],
                showlegend:true,
                legendgroup: 'Grid',
                type: 'scatter3d',
                mode: 'lines',
                line: { color: 'black',width:4},
            }

       return grid
}

function init_layout(data){

    var axisColor = "rgb(150,150,150)";
    var dxy       = 0.1;
    var dz        = 1;

    var layout   = {

        title: {text:`<b>2D PIECEWISE FUNCTION`,font:{size:20}},
        font: {
            //size: 12,
            color: 'white'
          },
        width:  divSizeW,
        height: divSizeH,
        showlegend:true,
        legend:{font:{size:16},
               x:-0.15,
               bgcolor: axisColor,
               bordercolor: 'white',
               borderwidth: 2},
        scene:{

            aspectratio: {x:1, y:1, z:0.5},
            xaxis:{ backgroundcolor: axisColor ,
                    gridcolor: "rgb(255,255,255)",
                    showbackground: true,
                    zerolinecolor: "rgb(0,0,0)",title:'X',
                    range: [0-dxy,2+dxy ],
                    tickvals:[0,1,2],
            },
            yaxis:{ backgroundcolor: axisColor ,
                    gridcolor: "rgb(255,255,255)",
                    showbackground: true,
                    zerolinecolor: "rgb(255, 255, 255)",title:'Y',
                    range: [0-dxy,2+dxy ],
                    tickvals:[0,1,2],
            },
            zaxis:{ backgroundcolor: axisColor ,
                    gridcolor: "rgb(255,255,255)",
                    showbackground: true,
                    zerolinecolor: "rgb(0,0,0)",title:'Z',
                    range: [cornersMin-dz,cornersMax+dz],
                    // tickvals:tf.linspace(-5,5,11).arraySync(),
                    tickvals:[-5,-2.5,0,2.5,5],
           },
        },
        margin: {
            l: 25,
            r: 25,
            b: 25,
            t: 50,
            pad: 2
          },
          plot_bgcolor:"black",
          paper_bgcolor:"black"
      };

    Plotly.newPlot(id_plot ,data, layout,{displayModeBar: false})

};

function fun_smoothstep(t){

    return 6*t**5-15*t**4+10*t**3;
};


var countUpdtaes = 0;
function updatePlots_traces(cornersMat){
    
    var zTiles        = getTraces_tiles2D(x,y,cornersMat).z;
    var zCorners      = getTraces_corners(cornersMat).z;
    var zGrid         = getTraces_grid(cornersMat,zTiles).z;
    var surfaceUpdate = {'z':[zTiles]}
    var cornersUpdate = {'z':[zCorners]}
    var gridUpdate    = {'z':[zGrid]}

    Plotly.update(id_plot, surfaceUpdate, {}, [0]);
    Plotly.update(id_plot, cornersUpdate, {}, [1]);
    Plotly.update(id_plot, gridUpdate   , {}, [2]);
     
    // count UPDATES
    // console.log('UPDATES: ',countUpdtaes++)
};

    // color scale
    // Plotly.update(id_plot, {colorscale:'Picnic'}, {}, [0]);
    // Plotly.update(id_plot, {colorscale:'Earth'},  {}, [0]);

    // var newScene = document.getElementById(id_plot).layout.scene;
    // newScene.aspectratio = {x:1, y:1, z:0.25}
    // Plotly.relayout(id_plot,newScene);

function windowResized(){
  
    resizeCanvas(windowWidth, windowHeight);
    background(0);
    window.location.reload()
};


