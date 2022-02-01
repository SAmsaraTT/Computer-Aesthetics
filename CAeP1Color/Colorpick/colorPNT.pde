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
float hsv_max=1;
float hsl_max=1;

float rgb_max=255;

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
    return "( "+Sx+nf(x,3,3)+" , "+Sy+nf(y,3,3)+" , "+Sz+nf(z,3,3)+" )";
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
   CPNT HSVfromRGB(CPNT RGB)
 {
     float var_R = ( RGB.x / 255);
     float var_G = ( RGB.y / 255);
     float var_B = ( RGB.z / 255);
     float var_Min = min( var_R, var_G, var_B );
     float var_Max = max( var_R, var_G, var_B );
     float del_Max = var_Max - var_Min;
     float V=var_Max;
     if ( del_Max == 0 )                     //This is a gray, no chroma...
     {
       float H = 0;
       float S = 0;
       return K(H,S,V);
     }
     else
     { 
       float H=0;
       float S=del_Max/var_Max;
       float del_R = ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
       float del_G = ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
       float del_B = ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
      if( var_R == var_Max ) 
      {
            H = del_B - del_G;
      }
      if ( var_G == var_Max )
      {
            H = (1./3) + del_R - del_B;
      }
      else if ( var_B == var_Max ) 
      {
            H =(2./3) + del_G - del_R;
      }
       if(H<0) H=H+1;
       if(H>1) H=H-1;
       return K(H,S,V);
     }
    
 }
 
  CPNT RGBfromHSV(CPNT HSV)
  {
    float H=HSV.x,S=HSV.y,V=HSV.z;
    float R=0,G=0,B=0;
    float var_r,var_g,var_b;
   if(S==0)
   {
     R = V * 255;
     G = V * 255;
     B = V * 255;
     return K(R,G,B);
   }
   else
   {
     float var_h = H * 6;
     if ( var_h == 6 ) 
     {
       var_h = 0;
     }    
     float var_i = floor(var_h);         
     float var_1 = V * ( 1 - S );
     float var_2 = V * ( 1 - S * ( var_h - var_i ) );
     float var_3 = V * ( 1 - S * ( 1 - ( var_h - var_i ) ) );

   if( var_i == 0 ) 
   { var_r = V; 
     var_g = var_3; 
     var_b = var_1;
   }
   else if (var_i == 1) 
   { var_r = var_2 ; 
     var_g = V; 
     var_b = var_1; 
   }
   else if ( var_i == 2) 
   { var_r = var_1 ; 
     var_g = V ; 
     var_b = var_3; 
   }
   else if ( var_i == 3) 
   { var_r = var_1 ; 
     var_g = var_2 ; 
     var_b = V;     
    }
   else if ( var_i == 4 ) 
   { 
     var_r = var_3 ; 
     var_g = var_1 ; 
     var_b = V ;    
   }
   else
  {
   var_r = V; 
   var_g = var_1; 
   var_b = var_2; 
   }

   R = var_r * 255;
   G = var_g * 255;
   B = var_b * 255;
   return K(R,G,B);
   }
  }
  
  CPNT HSLfromRGB(CPNT RGB)
  {
    float var_R = ( RGB.x /255);
    float var_G = ( RGB.y/ 255);
    float var_B = ( RGB.z/ 255);

    float var_Min = min( var_R, var_G, var_B ) ;  
    float var_Max = max( var_R, var_G, var_B );    
    float del_Max = var_Max - var_Min ;            

     float L = ( var_Max + var_Min )/ 2;

       if ( del_Max == 0 )                     
      {
           float H = 0;
           float S = 0;
           return K(H,S,L);
      }
      else                                    
     {  
       float S=0;
       float H=0;
       if ( L < 0.5 ) 
       {
        S = del_Max / ( var_Max + var_Min );
       }
       else
       {
        S = del_Max / ( 2 - var_Max - var_Min );
       }
      float del_R = ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
      float del_G = ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
      float del_B = ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max;

        if ( var_R == var_Max )
        {
          H = del_B - del_G;
        }
        else if ( var_G == var_Max ) 
        {
          H = (1./3) + del_R - del_B;
        }
        else if ( var_B == var_Max ) 
        {
          H = ( 2./3) + del_G - del_R;
        }

         if ( H < 0 ) H += 1;
         if ( H > 1 ) H -= 1;
         return K(H,S,L);
     }
  }
  
float Hue_2_RGB (float v1,float v2, float vH)          
{
   if ( vH < 0 ) vH = vH+1;
   if ( vH > 1 ) vH = vH-1;
   if ( ( 6 * vH ) < 1 ) return ( v1 + ( v2 - v1 ) * 6 * vH );
   if ( ( 2 * vH ) < 1 ) return (v2);
   if ( ( 3 * vH ) < 2 ) return ( v1 + ( v2 - v1 ) * ( ( 2./3 ) - vH ) * 6 );
   return  (v1) ;
}
  
  CPNT RGBfromHSL(CPNT HSL)
  {
    float H=HSL.x,S=HSL.y,L=HSL.z;
    if ( S == 0 )
     {

       float R = L * 255;
       float G = L * 255;
       float B = L * 255;
       return K(R,G,B);
    }
    else
    {
      float var_2=0;
      if ( L < 0.5 ) 
      {
       var_2 = L * ( 1 + S );
      }
      else
      {
       var_2 = ( L + S ) - ( S * L );
      }

       float var_1 = 2 * L - var_2;
       float H1=H+1./3;
       float H2=H-1./3;
       float R = 255* Hue_2_RGB(var_1,var_2, H1);
       float G = 255* Hue_2_RGB( var_1, var_2, H );
       float B = 255* Hue_2_RGB( var_1, var_2, H2 );
      return K(R,G,B);
    }
    
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
  if(SCSname==_HSV) {Am = HSVfromRGB(Am); Bm = HSVfromRGB(Bm); Cm = HSVfromRGB(Cm); };
  if(SCSname==_HSL) {Am = HSLfromRGB(Am); Bm = HSLfromRGB(Bm); Cm = HSLfromRGB(Cm); };
  
  CPNT R;
  if(interpolating) R = Kinterpolation(0,Am,0.5,Bm,1,Cm,t);
  else              R = Kapproximation(0,Am,0.5,Bm,1,Cm,t);
  if(SCSname==_XYZ) R = RGBfromXYZ(R); 
  if(SCSname==_LAB) R = RGBfromLAB(R); 
  if(SCSname==_LCH) R = RGBfromLCH(R); 
  if(SCSname==_HSV) R = RGBfromHSV(R); 
  if(SCSname==_HSL) R = RGBfromHSL(R); 
  return R;
  }
  CPNT KInterpolateInSCSLAB(CPNT A, CPNT B, CPNT C, float t)
  {
  CPNT Am = K(A), Bm = K(B), Cm = K(C);
  Am = LABfromRGB(Am); Bm = LABfromRGB(Bm); Cm = LABfromRGB(Cm); 
  CPNT R;
  R = Kinterpolation(0,Am,0.5,Bm,1,Cm,t);
  R = RGBfromLAB(R); 
  return R;
  }
  
  
  CPNT KInterpolateInSCSLCH(CPNT A, CPNT B, CPNT C, float t)
  {
  CPNT Am = K(A), Bm = K(B), Cm = K(C);
  Am = LCHfromRGB(Am); Bm = LCHfromRGB(Bm); Cm = LCHfromRGB(Cm); 
  CPNT R;
  R = Kinterpolation(0,Am,0.5,Bm,1,Cm,t);
  R = RGBfromLCH(R); 
  return R;
  }
  
  CPNT KInterpolateInSCSHSV(CPNT A, CPNT B, CPNT C, float t)
  {
  CPNT Am = K(A), Bm = K(B), Cm = K(C);
  Am = HSVfromRGB(Am); Bm = HSVfromRGB(Bm); Cm = HSVfromRGB(Cm); 
  CPNT R;
  R = Kinterpolation(0,Am,0.5,Bm,1,Cm,t);
  R = RGBfromHSV(R); 
  return R;
  }
  
   CPNT KInterpolateInSCSHSL(CPNT A, CPNT B, CPNT C, float t)
  {
  CPNT Am = K(A), Bm = K(B), Cm = K(C);
  Am = HSLfromRGB(Am); Bm = HSLfromRGB(Bm); Cm = HSLfromRGB(Cm); 
  CPNT R;
  R = Kinterpolation(0,Am,0.5,Bm,1,Cm,t);
  R = RGBfromHSL(R); 
  return R;
  }
  
  CPNT KInterpolateInSCSRGB(CPNT A, CPNT B, CPNT C, float t)
  {
  CPNT Am = K(A), Bm = K(B), Cm = K(C);
  CPNT R;
  R = Kinterpolation(0,Am,0.5,Bm,1,Cm,t);
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
    K_HSV = HSVfromRGB(K_RGB);
    K_HSL= HSLfromRGB(K_RGB);
    }
  if(SCSname==_XYZ) 
    {
    K_RGB = RGBfromXYZ(K_XYZ);
    K_LAB = LABfromXYZ(K_XYZ); 
    K_LCH = LCHfromLAB(K_LAB);
    K_HSV = HSVfromRGB(K_RGB);
    K_HSL=  HSLfromRGB(K_RGB);
    }
  if(SCSname==_LCH) 
    {
    while(K_LCH.z>=360) K_LCH.z-=360; while(K_LCH.z<0) K_LCH.z+=360;
    K_LAB = LABfromLCH(K_LCH); 
    K_XYZ = XYZfromLAB(K_LAB);
    K_RGB = RGBfromXYZ(K_XYZ);
    K_HSV = HSVfromRGB(K_RGB);
    K_HSL= HSLfromRGB(K_RGB);
    }
  if(SCSname==_LAB) 
    {
    K_LCH = LCHfromLAB(K_LAB);
    K_XYZ = XYZfromLAB(K_LAB);
    K_RGB = RGBfromXYZ(K_XYZ);
    K_HSV = HSVfromRGB(K_RGB);
    K_HSL= HSLfromRGB(K_RGB);
    }
  if(SCSname==_HSV)
  { 
    K_HSV.x=max(0,K_HSV.x); K_HSV.x=min(hsv_max,K_HSV.x); 
    K_HSV.y=max(0,K_HSV.y); K_HSV.y=min(hsv_max,K_HSV.y); 
    K_HSV.z=max(0,K_HSV.z); K_HSV.z=min(hsv_max,K_HSV.z);
    K_RGB = RGBfromHSV(K_HSV);
    K_XYZ = XYZfromRGB(K_RGB); 
    K_LAB = LABfromXYZ(K_XYZ); 
    K_LCH = LCHfromLAB(K_LAB);
    K_HSL=  HSLfromRGB(K_RGB);
  }
  if(SCSname==_HSL)
  { 
    K_HSL.x=max(0,K_HSL.x); K_HSL.x=min(hsl_max,K_HSL.x); 
    K_HSL.y=max(0,K_HSL.y); K_HSL.y=min(hsl_max,K_HSL.y); 
    K_HSL.z=max(0,K_HSL.z); K_HSL.z=min(hsl_max,K_HSL.z);
    K_RGB = RGBfromHSL(K_HSL);
    K_XYZ = XYZfromRGB(K_RGB); 
    K_LAB = LABfromXYZ(K_XYZ); 
    K_LCH = LCHfromLAB(K_LAB);
    K_HSV = HSVfromRGB(K_RGB);
    
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
  K_HSV = HSVfromRGB(K_RGB);
  K_HSL= HSLfromRGB(K_RGB);
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
