import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!
import java.awt.Toolkit;
import java.awt.datatransfer.*;

//CLR C1=K(158,0,50), C2=K(50,155,253), C3=K(0,122,14); // input colors
//CLR C1=K(200,0,0), C2=K(0,200,0), C3=K(0,0,200); 
//CLR C1=K(200,0,0), C2=K(245,216,99), C3=K(131,5,157);
CPNT C1=K(200,0,0), C2=K(0,200,0), C3=K(0,0,200);
// when running the sketch, to save the current 3 colors as input colors, press 's', paste the clipboard content below, and comment the line above 

CPNT backgroundColor, accentColor; // Computed colors:    Mean (background) Cm   and    Accent Ca  

int selectedColor=1; // for pasting from clipboard or editing with mouse+'r','g','b','x','y','z','l','c', or 'h'
CPNT K_RGB, K_XYZ, K_LAB, K_LCH; // selected color in different color spaces (used during editing)

int n = 17; // number of colors
int dx=300; // size of color pickers (1/3 of screen width)
float r=20, x1=110+r,  y1=410; // position  and radius constant
int _RGB=1, _XYZ=2, _LAB=3, _LCH=4; // color spaces used for computing solutions
int _cover=1, _disks=2, _ramp=3, _loop=4, _area=5;  // select mode using 'C', 'D', 'R', 'L', 'A'
int showing=_cover; // initial mode (with title, help, color details, etc)
boolean interpolating = true; // toggles between interpolating and approximating ramp
int SCSname = _RGB;  // defines which space is used for interpolation
String SCS = "RGB"; // for writing method on canvas
boolean demoDisks=false; // mode activated by 'd' showing colored disks
boolean demoCover=true; // mode activated by 'd' showing colored disks
boolean firstFrame=true; // to make colors after first pass of draw 
boolean showColor=true;
PNT P1 = P(140,510), P2 = P(650,100), P3 = P(760,410); // Editable control points
PNT P;

void setup() // Executed once at start of sketch
  {
  size(900, 660); // if you change the window size, you will need to change the various positionning constants 
  rectMode(CENTER); // for specifing rectanges via their center and size
  PictureOfMyFace1 = loadImage("data/pic.jpg"); // load image from file pic.jpg in folder data *** replace that file with pix of your own face
  PictureOfMyFace2 = loadImage("data/pic1.jpg"); 
  PictureOfMyFace3 = loadImage("data/pic2.jpg");
  font = loadFont("ChalkboardSE-Regular-32.vlw"); textFont(font, 24); // nice large font
  setClipboard("#F7BA0F"); // in case user presses '1' '2' '3' before copying a color into the clipboard
  makeDisks(); // makes random disks shown when demo is TRUE (toggled with 'D')
  SCSname=_RGB; selectedColor=1; K_RGB=K(C1); updateColors();
  }

void draw() // Executed at each frame
  {  
  backgroundColor = MeanColorInSCS(C1,C2,C3); // set mean color
  accentColor = AccentColorInSCS(C1,C2,C3); // set accent color
  if(showing==_cover) background(255); // erases screen and paints it white
  else background(c(backgroundColor));
  if(interpolating) r = width/n/2; else r = width/n/4;

  if(showing==_cover)
    {
    showCover(); // DEFAULT MODE (see code in TAB Student). Toggle using 'd' (when not in test mode)
    scribeHeaderRight("n="+n,21); scribeHeader("scs="+SCS,21); // writes chosen parameters on canvas
    displayHeader(); // title, student's name, picture (shown only in standard view, not demoDisk, not Test)    
    int SKl=9; 
    scribeHeaderRight("selected color = "+selectedColor,SKl++);
    String SK1 = "'G': RGB="+K_RGB.S(), SK2 = "'X': XYZ="+K_XYZ.S(), SK3 = "'P': LAB="+K_LAB.S(), SK4 = "'H': LCH="+K_LCH.S();
    scribeHeaderRight(SK1,SKl++); scribeHeaderRight(SK2,SKl++); scribeHeaderRight(SK3,SKl++); scribeHeaderRight(SK4,SKl++);
    scribeHeaderRight("Background = ( "+nf(backgroundColor.x,3,1)+", "+nf(backgroundColor.y,3,1)+", "+nf(backgroundColor.z,3,1)+" )",SKl++);
    scribeHeaderRight("Accent = ( "+nf(accentColor.x,3,1)+", "+nf(accentColor.y,3,1)+", "+nf(accentColor.z,3,1)+" )",SKl++);
    }
  if(showing==_disks) 
    {
    showDisks();    
    }
  if(showing==_ramp)
    {
    showRamp();    
    }
  if(showing==_loop)
    {
    showLoop();        
    }
  if(showing==_area)
    {
    showFilledTriangle(); // TEST MODE (see code in TAB Student). Toggle using 't'  
    for(int i = 0; i<n; i++) // shows interpolating color ramp
        {
        float s = (float)i/(n-1);
        color c = c(KInterpolateInSCS(C1,C2,C3,s));
        fill(c); stroke(c); strokeWeight(1); 
        float x = (0.5+i)/n*width;
        float w = float(width)/n;
        rect((0.5+i)/n*width, height-50, float(width)/n, 100);
        }
    }

  if(showing==_area || showing==_ramp || showing==_loop)  
    {
    stroke(c(accentColor)); strokeWeight(2); disk(P1,r,c(C1)); disk(P2,r,c(C2)); disk(P3,r,c(C3)); // shows disks filled with input colors
    noFill(); strokeWeight(2); if(mousePressed) circ(P,r+2,c(accentColor)); 
    fill(c(accentColor)); scribeHeaderRight(SCS,24); 
    }
    
  if(snapJPG) snapPictureToJPG(); // takes picture of canvas and puts in flder MyImages
  if(firstFrame) makeColors(); firstFrame=false; // to ensure that we colors are set for demoDisk   
  }
  
