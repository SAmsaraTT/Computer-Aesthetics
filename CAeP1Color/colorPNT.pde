// FROM: http://rsbweb.nih.gov/ij/plugins/download/Color_Space_Converter.java
// See also https://physics.stackexchange.com/questions/487763/how-are-the-matrices-for-the-rgb-to-from-cie-xyz-conversions-generated/563379

public float[] D65 = {95.0429, 100.0, 108.8900};
public float[] whitePoint = D65;
public float[][] Mi  =  {{ 3.2406, -1.5372, -0.4986},
                         {-0.9689,  1.8758,  0.0415},
                         { 0.0557, -0.2040,  1.0570}};
public float[][] M   =  {{0.4124, 0.3576,  0.1805},
                         {0.2126, 0.7152,  0.0722},
                         {0.0193, 0.1192,  0.9505}};
                         
// lightness: 0<L<100, cyan-magenta: -100<a<100, blue-yellow: -100<b<100
float L=74,a=5, b=5; 
float L0=57, a0=-88, b0=-91;
float L1=74, a1=95, b1=65;

float rgb_max=256;

// COLOR CLASS (in any color space)
//RGB: Red Green Blue
//LCH: Lightness Chroma Hue
CPNT R1, C1LAB, C1XYZ, C1LCH;
CPNT R2, C2LAB, C2XYZ, C2LCH;
CPNT R3, C3LAB, C3XYZ, C3LCH;

class CPNT // Color Point class
  { 
  float x=0, y=0, z=0; 
  CPNT (float px, float py, float pz) {x = px; y = py; z=pz;}
  String S() 
    {
    String Sx=""; String Sy=""; String Sz="";
    if(x>=0) Sx=" "; if(y>=0) Sy=" "; if(z>=0) Sz=" ";
    return "( "+Sx+nf(x,3,1)+" , "+Sy+nf(y,3,1)+" , "+Sz+nf(z,3,1)+" )";
    }
  }
  
//////////////////////////////////////////////////////////////////////// CLR creation
CPNT K(float x, float y, float z) {return new CPNT(x,y,z); }                                                     
CPNT K() {return K(0,0,0); } 
CPNT K(color c) {return K(red(c),green(c),blue(c));}
CPNT K(CPNT C) {return K(C.x,C.y,C.z);}
CPNT RGBcomplement(CPNT C) {return K(rgb_max-C.x,rgb_max-C.y,rgb_max-C.z); }    // complement (only works in RGB [0,256) )                                                                   

//////////////////////////////////////////////////////////////////////// CLR use for rendering and writing
color c(CPNT C) {return color(round(C.x),round(C.y),round(C.z));} // Processing color of a CLR
String S(CPNT C) {return "("+nf(C.x,3,1)+","+nf(C.y,3,1)+","+nf(C.z,3,1)+")";}
String Si(CPNT C) {return "("+str(int(C.x))+","+str(int(C.y))+","+str(int(C.z))+")";} // sting of the CLR parameters

//////////////////////////////////////////////////////////////////////// CLR conversions between color spaces
    // XYZfromRGB RGBfromXYZ
    // LABfromRGB RGBfromLAB
    // LCHfromRGB RGBfromLCH
    // XYZfromLAB LABfromXYZ
    // LABfromLCH LCHfromLAB


CPNT XYZfromRGB(CPNT RGB)
  {
  float R=RGB.x, G=RGB.y, B=RGB.z;
  float r = R / rgb_max;
  float g = G / rgb_max;
  float b = B / rgb_max;
  // assume sRGB
  if (r <= 0.04045) r = r / 12.92; else r = pow(((r + 0.055) / 1.055), 2.4);
  if (g <= 0.04045) g = g / 12.92; else g = pow(((g + 0.055) / 1.055), 2.4);
  if (b <= 0.04045) b = b / 12.92; else b = pow(((b + 0.055) / 1.055), 2.4);
  r *= 100.0;
  g *= 100.0;
  b *= 100.0;
  // [X Y Z] = [r g b][M]
  float X = (r * M[0][0]) + (g * M[0][1]) + (b * M[0][2]);
  float Y = (r * M[1][0]) + (g * M[1][1]) + (b * M[1][2]);
  float Z = (r * M[2][0]) + (g * M[2][1]) + (b * M[2][2]);
  return K(X,Y,Z);
  }
  
CPNT RGBfromXYZ(CPNT XYZ)
  {
  float X=XYZ.x, Y=XYZ.y, Z=XYZ.z;
  float x = X / 100;
  float y = Y / 100;
  float z = Z / 100;
  // [r g b] = [X Y Z][Mi]
  float r = (x * Mi[0][0]) + (y * Mi[0][1]) + (z * Mi[0][2]);
  float g = (x * Mi[1][0]) + (y * Mi[1][1]) + (z * Mi[1][2]);
  float b = (x * Mi[2][0]) + (y * Mi[2][1]) + (z * Mi[2][2]);
  // assume sRGB
  if (r > 0.0031308) r = ((1.055 * pow(r, 1.0 / 2.4)) - 0.055); else r = (r * 12.92);
  if (g > 0.0031308) g = ((1.055 * pow(g, 1.0 / 2.4)) - 0.055); else g = (g * 12.92);
  if (b > 0.0031308) b = ((1.055 * pow(b, 1.0 / 2.4)) - 0.055); else b = (b * 12.92);
  r = (r < 0) ? 0 : r;
  r = (r > 1) ? 1 : r;
  g = (g < 0) ? 0 : g;
  g = (g > 1) ? 1 : g;
  b = (b < 0) ? 0 : b;
  b = (b > 1) ? 1 : b;
  // convert 0..1 into 0..256
  float R = r * rgb_max;
  float G = g * rgb_max;
  float B = b * rgb_max;
  return K(R,G,B);
  }
      
CPNT XYZfromLAB(CPNT LAB)
  {
  float L=LAB.x, A=LAB.y, B=LAB.z;  
  float y = (L + 16.0) / 116.0;
  float y3 = pow(y, 3.0);
  float x = (A / 500.0) + y;
  float x3 = pow(x, 3.0);
  float z = y - (B / 200.0);
  float z3 = pow(z, 3.0);
  if (y3 > 0.008856) y = y3; else y = (y - (16.0 / 116.0)) / 7.787;
  if (x3 > 0.008856) x = x3; else x = (x - (16.0 / 116.0)) / 7.787;
  if (z3 > 0.008856) z = z3; else z = (z - (16.0 / 116.0)) / 7.787;
  float X = x * whitePoint[0];
  float Y = y * whitePoint[1];
  float Z = z * whitePoint[2];
  return K(X,Y,Z);
  } 
  
CPNT LABfromXYZ(CPNT XYZ)
  {
  float X=XYZ.x, Y=XYZ.y, Z=XYZ.z;
  float x = X / whitePoint[0];
  float y = Y / whitePoint[1];
  float z = Z / whitePoint[2];
  if (x > 0.008856) x = pow(x, 1.0 / 3.0); else x = (7.787 * x) + (16.0 / 116.0);
  if (y > 0.008856) y = pow(y, 1.0 / 3.0); else y = (7.787 * y) + (16.0 / 116.0);
  if (z > 0.008856) z = pow(z, 1.0 / 3.0); else z = (7.787 * z) + (16.0 / 116.0);
  float L = (116.0 * y) - 16.0;
  float A = 500.0 * (x - y);
  float B = 200.0 * (y - z);
  return K(L,A,B);
  } 
  
CPNT LABfromLCH(CPNT LCH)
  {
  float L=LCH.x, C=LCH.y, H=LCH.z;
  float h = H*PI/180;
  float A = C * cos(h);
  float B = C * sin(h);
  return K(L,A,B);
  } 
  
CPNT LCHfromLAB(CPNT LAB)
  {
  float L=LAB.x, A=LAB.y, B=LAB.z;  
  float h = atan2(B, A);
  // convert radians to degrees
  float C = sqrt(A*A + B*B);
  float H = h/PI*180;
  while(H>=360) H-=360;
  while(H<0) H+=360;
  return K(L,C,H);
  } 
  
  
//////////////////////////////////////////////////////////////////////// Composed CLR conversions between color spaces
CPNT LCHfromRGB(CPNT C) {return LCHfromLAB(LABfromXYZ(XYZfromRGB(C)));} 
CPNT RGBfromLCH(CPNT C) {return RGBfromXYZ(XYZfromLAB(LABfromLCH(C)));}
CPNT LABfromRGB(CPNT C) {return LABfromXYZ(XYZfromRGB(C));} 
CPNT RGBfromLAB(CPNT C) {return RGBfromXYZ(XYZfromLAB(C));}



//////////////////////////////////////////////////////////////////////// CLR blending in scs (selected color space)
CPNT KaverageInSCS(CPNT A, CPNT B)
  {
  CPNT Am = K(A), Bm = K(B);
  if(SCSname==_XYZ) {Am = XYZfromRGB(Am); Bm = XYZfromRGB(Bm); };
  if(SCSname==_LAB) {Am = LABfromRGB(Am); Bm = LABfromRGB(Bm); };
  if(SCSname==_LCH) {Am = LCHfromRGB(Am); Bm = LCHfromRGB(Bm); };
  CPNT R = WAK(0.5,Am,0.5,Bm);
  if(SCSname==_XYZ) R = RGBfromXYZ(R); 
  if(SCSname==_LAB) R = RGBfromLAB(R); 
  if(SCSname==_LCH) R = RGBfromLCH(R); 
  return R;
  }
CPNT KInterpolateInSCS(CPNT A, CPNT B, CPNT C, float t)
  {
  CPNT Am = K(A), Bm = K(B), Cm = K(C);
  if(SCSname==_XYZ) {Am = XYZfromRGB(Am); Bm = XYZfromRGB(Bm); Cm = XYZfromRGB(Cm); };
  if(SCSname==_LAB) {Am = LABfromRGB(Am); Bm = LABfromRGB(Bm); Cm = LABfromRGB(Cm); };
  if(SCSname==_LCH) {Am = LCHfromRGB(Am); Bm = LCHfromRGB(Bm); Cm = LCHfromRGB(Cm); };
  CPNT R;
  if(interpolating) R = Kinterpolation(0,Am,0.5,Bm,1,Cm,t);
  else              R = Kapproximation(0,Am,0.5,Bm,1,Cm,t);
  if(SCSname==_XYZ) R = RGBfromXYZ(R); 
  if(SCSname==_LAB) R = RGBfromLAB(R); 
  if(SCSname==_LCH) R = RGBfromLCH(R); 
  return R;
  }
  
  CPNT KInterpolateInSCS1(CPNT A, CPNT B, float t)
  {
  CPNT Am = K(A), Bm = K(B);
  if(SCSname==_XYZ) {Am = XYZfromRGB(Am); Bm = XYZfromRGB(Bm); };
  if(SCSname==_LAB) {Am = LABfromRGB(Am); Bm = LABfromRGB(Bm); };
  if(SCSname==_LCH) {Am = LCHfromRGB(Am); Bm = LCHfromRGB(Bm); };
  CPNT R;
  R = Kinterpolation1(0,Am,1,Bm,t);
  if(SCSname==_XYZ) R = RGBfromXYZ(R); 
  if(SCSname==_LAB) R = RGBfromLAB(R); 
  if(SCSname==_LCH) R = RGBfromLCH(R); 
  return R;
  }
  


CPNT KApproximateInSCS(CPNT A, CPNT B, CPNT C, float t)
  {
  CPNT Am = K(A), Bm = K(B), Cm = K(C);
  if(SCSname==_XYZ) {Am = XYZfromRGB(Am); Bm = XYZfromRGB(Bm); Cm = XYZfromRGB(Cm); };
  if(SCSname==_LAB) {Am = LABfromRGB(Am); Bm = LABfromRGB(Bm); Cm = LABfromRGB(Cm); };
  if(SCSname==_LCH) {Am = LCHfromRGB(Am); Bm = LCHfromRGB(Bm); Cm = LCHfromRGB(Cm); };
  CPNT R = Kapproximation(0,Am,0.5,Bm,1,Cm,t);
  if(SCSname==_XYZ) R = RGBfromXYZ(R); 
  if(SCSname==_LAB) R = RGBfromLAB(R); 
  if(SCSname==_LCH) R = RGBfromLCH(R); 
  return R;
  }
  

CPNT WAKinSCS(float a, CPNT A, float b, CPNT B, float c, CPNT C)
  {
  CPNT Am = K(A), Bm = K(B), Cm = K(C);
  if(SCSname==_XYZ) {Am = XYZfromRGB(Am); Bm = XYZfromRGB(Bm); Cm = XYZfromRGB(Cm); };
  if(SCSname==_LAB) {Am = LABfromRGB(Am); Bm = LABfromRGB(Bm); Cm = LABfromRGB(Cm); };
  if(SCSname==_LCH) {Am = LCHfromRGB(Am); Bm = LCHfromRGB(Bm); Cm = LCHfromRGB(Cm); };
  CPNT R =  WAK(a,Am,b,Bm,c,Cm);
  if(SCSname==_XYZ) R = RGBfromXYZ(R); 
  if(SCSname==_LAB) R = RGBfromLAB(R); 
  if(SCSname==_LCH) R = RGBfromLCH(R); 
  return R;
  }

CPNT MeanColorInSCS(CPNT A, CPNT B, CPNT C) {return WAKinSCS(1./3,A,1./3,B,1./3,C);}
CPNT OKinSCS(CPNT A, CPNT B, CPNT C) {return WAKinSCS(-1,A,1,B,1,C);}

//////////////////////////////////////////////////////////////////////// CLR weighted average of colors
CPNT WAK(float a, CPNT A, float b, CPNT B) {return K(a*A.x+b*B.x,a*A.y+b*B.y,a*A.z+b*B.z);}   
CPNT WAK(float a, CPNT A, float b, CPNT B, float c, CPNT C) {return K(a*A.x+b*B.x+c*C.x,a*A.y+b*B.y+c*C.y,a*A.z+b*B.z+c*C.z);}


//////////////////////////////////////////////////////////////////////// Update colors when edting current color
    
void updateColors() // resets K_RGB, K_XYZ, K_LAB, K_LCH, C1, C2, and C3 when K_RGB, K_XYZ, or K_LCH was updated
  {
  if(SCSname==_RGB) 
    {
    K_RGB.x=max(0,K_RGB.x); K_RGB.x=min(rgb_max,K_RGB.x); 
    K_RGB.y=max(0,K_RGB.y); K_RGB.y=min(rgb_max,K_RGB.y); 
    K_RGB.z=max(0,K_RGB.z); K_RGB.z=min(rgb_max,K_RGB.z);
    K_XYZ = XYZfromRGB(K_RGB); 
    K_LAB = LABfromXYZ(K_XYZ); 
    K_LCH = LCHfromLAB(K_LAB);
    }
  if(SCSname==_XYZ) 
    {
    K_RGB = RGBfromXYZ(K_XYZ);
    K_LAB = LABfromXYZ(K_XYZ); 
    K_LCH = LCHfromLAB(K_LAB);
    }
  if(SCSname==_LCH) 
    {
    while(K_LCH.z>=360) K_LCH.z-=360; while(K_LCH.z<0) K_LCH.z+=360;
    K_LAB = LABfromLCH(K_LCH); 
    K_XYZ = XYZfromLAB(K_LAB);
    K_RGB = RGBfromXYZ(K_XYZ);
    }
  if(SCSname==_LAB) 
    {
    K_LCH = LCHfromLAB(K_LAB);
    K_XYZ = XYZfromLAB(K_LAB);
    K_RGB = RGBfromXYZ(K_XYZ);
    }

  if(selectedColor==1) C1=K(K_RGB);
  if(selectedColor==2) C2=K(K_RGB);
  if(selectedColor==3) C3=K(K_RGB);
  
  K_RGB.x=max(0,K_RGB.x); K_RGB.x=min(rgb_max,K_RGB.x); 
  K_RGB.y=max(0,K_RGB.y); K_RGB.y=min(rgb_max,K_RGB.y); 
  K_RGB.z=max(0,K_RGB.z); K_RGB.z=min(rgb_max,K_RGB.z);
  
  }

void setSpaceColorsFromSelectedColor() // sets K_RGB, K_XYZ, K_LAB, and K_LCH for C1, C2, or C3 when pressking '1', '2', '3', or 'r','g'...'h'
  {
  if(selectedColor==1) K_RGB=K(C1);
  if(selectedColor==2) K_RGB=K(C2);
  if(selectedColor==3) K_RGB=K(C3);
  K_XYZ = XYZfromRGB(K_RGB);
  K_LAB = LABfromXYZ(K_XYZ); 
  K_LCH = LCHfromLAB(K_LAB);
  }
  
//////////////////////////////////////////////////////////////////////// color from clipboard #HEX string like #7E1125
CPNT CLRfromClipboard() // Tools > ColorSelector > pick color > (Copy) > click canvas > '1', '2', or '3'
    {
    String C = getClipboard(); 
    println("Clipboard = ",C,", starts with ",C.substring(0,1));
    if(C.charAt(0)!='#') 
      {
      println("Color should start with #"); 
      return K(color(120));  
      }
    String S = C.substring(1); 
    int c=Integer.parseInt(S,16); 
    int r = (c >> 16) & 0xFF;     
    int g = (c >> 8) & 0xFF;   
    int b = c & 0xFF;   
    println("Picked RGB = (",r,",",g,",",b,")");
    return K(color(r,g,b));
    }   
