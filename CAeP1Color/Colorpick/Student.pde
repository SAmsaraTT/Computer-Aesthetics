//  STUDENT: IF POSSIBLE, PLEASE PUT ALL YOUR CODE IN THIS TAB
// places wher you need to add or change something are marked with ????

 
// //////////////////// student's contributions
// Title and help
/* ???? remove 4497 or 6497  */   
String title ="Class: CS6497, Year: 2022, Project 01";   //      
String subtitle = "Lch and Lab colour and gradient picker";    

  /* ???? replace string below by your name (eg "Jarek ROSSIGNAC") */  
String name ="Haotian Liu; Aishwarya Mudga; Harshal Dahakel ";

  /* ???? replace file \data\pic.jpg by a small (150x225 or so pixels) picture of your face  */  

// INTERPOLATION OF 3 POINTS OR 3 colors
// function for one of the blending weights (as discussed in the lecture) 
float u(float a, float b, float c, float t) 
  {
  /* ???? replace code below by your code of wtight function ???? */  
  float x=((t-b)*(t-c))/((a-b)*(a-c));
  return x;
  }
  
// Makes point at parameter s along pareabola through points A, B, C (uses u() defined above)
PNT Interpolate(float a, PNT A, float b, PNT B, float c, PNT C, float t)
  {
  /* ???? replace code below by your code ???? */
   PNT A1=P(0,0);;
   A1.x=A.x*u(a,b,c,t)+B.x*u(b,a,c,t)+C.x*u(c,a,b,t);
   A1.y=A.y*u(a,b,c,t)+B.y*u(b,a,c,t)+C.y*u(c,a,b,t);
   return A1;
  }
  
float u1(float a, float b, float t) 
  {
  /* ???? replace code below by your code of wtight function ???? */  
  float x=(t-b)/(a-b);
  return x;
  }
  
PNT Interpolate1(float a, PNT A, float b, PNT B, float t)
  {
  /* ???? replace code below by your code ???? */
   PNT A1=P(0,0);
   A1.x=A.x*u1(a,b,t)+B.x*u1(b,a,t);
   A1.y=A.y*u1(a,b,t)+B.y*u1(b,a,t);
   return A1;
  }
 
  
PNT L(PNT A, PNT B, float t)
 {
  PNT A1=P(0,0);
  
  A1.x=A.x*(1-t)+B.x*t;
  A1.y=A.y*(1-t)+B.y*t;
  return A1;
  
 }
 

PNT Approximate(PNT A, PNT B, PNT C, float t)
  {
  /* ???? replace code below by your code ???? */
  return L(L(A,B,t),L(B,C,t),t);
  }
  
// Makes color at parameter s along pareabola through CLRs A, B, C in the SCS (uses u() defined above)
CPNT Kinterpolation(float a, CPNT A, float b, CPNT B, float c, CPNT C, float t)
  {
  /* ???? replace code below by your code ???? */ 
  CPNT A1=K(0,0,0);
  A1.x=A.x*u(a,b,c,t)+B.x*u(b,a,c,t)+C.x*u(c,a,b,t);
  A1.y=A.y*u(a,b,c,t)+B.y*u(b,a,c,t)+C.y*u(c,a,b,t);
  A1.z=A.z*u(a,b,c,t)+B.z*u(b,a,c,t)+C.z*u(c,a,b,t);
 
  return A1;
  }
  
  CPNT Kinterpolation1(float a, CPNT A, float b, CPNT B, float t)
  {
  /* ???? replace code below by your code ???? */ 
  CPNT A1=K(0,0,0);
  A1.x=A.x*u1(a,b,t)+B.x*u1(b,a,t);
  A1.y=A.y*u1(a,b,t)+B.y*u1(b,a,t);
  A1.z=A.z*u1(a,b,t)+B.z*u1(b,a,t);
 
  return A1;
  }
  
  
  CPNT CL(CPNT A, CPNT B, float t)
 {
  CPNT A1=K(0,0,0);
  
  A1.x=A.x*(1-t)+B.x*t;
  A1.y=A.y*(1-t)+B.y*t;
  A1.z=A.z*(1-t)+B.z*t;
  return A1;
  
 }

// Makes color at parameter s along pareabola through CLRs A, B, C in the SCS (uses u() defined above)
CPNT Kapproximation(float a, CPNT A, float b, CPNT B, float c, CPNT C, float t)
  {
  /* ???? replace code below by your code ???? */  
  return CL(CL(A,B,t),CL(B,C,t),t);
  }

 
// LOOP: provide both interpolating and approximating variants for colored closed-loop
void showLoop()
{
  LshowLoop(P1,P2,P3,C1,C2,C3,interpolating);
}
void LshowLoop(PNT A, PNT B, PNT C, CPNT C1, CPNT C2, CPNT C3, boolean interpolating)
{
    float rr = r; //width/n/2; 
    noStroke(); // do not draw border circle around the disks
    

    if(interpolating)
    { for(int i = 0; i<n/2; i++) // shows disks with interpolating color ramp
      {
       float s = (float)i/(n-1);
        /* ???? replace code below by your code ???? */ 
       color c1 = c(KInterpolateInSCS(C1,C2,C3,s)); // color blended in the SCS (Selcted Color Space)
       PNT P1 = Interpolate(A,B,C,s);
       color c2 = c(KInterpolateInSCS(C2,C3,C1,s)); // color blended in the SCS (Selcted Color Space)
       PNT P2 = Interpolate(B,C,A,s);
       color c3 = c(KInterpolateInSCS(C3,C1,C2,s)); // color blended in the SCS (Selcted Color Space)
       PNT P3 = Interpolate(C,A,B,s);
       disk(P1,rr,c1);
       disk(P2,rr,c2);
       disk(P3,rr,c3);
      }
  
     }
  else
    {
  /* ???? replace code below by your code ???? */ 
  for(int i = 0; i<n; i++) // shows disks with interpolating color ramp
      {
       PNT M1=P(0,0);
       PNT M2=P(0,0);
       PNT M3=P(0,0);
       CPNT CM1=K(0,0,0);
       CPNT CM2=K(0,0,0);
       CPNT CM3=K(0,0,0);
   
       M1.x=(A.x+B.x)/2;
       M1.y=(A.y+B.y)/2;
       M2.x=(A.x+C.x)/2;
       M2.y=(A.y+C.y)/2;
       M3.x=(B.x+C.x)/2;
       M3.y=(B.y+C.y)/2;
       
       CM1.x=(C1.x+C2.x)/2;
       CM1.y=(C1.y+C2.y)/2;
       CM1.z=(C1.z+C2.z)/2;
       CM2.x=(C1.x+C3.x)/2;
       CM2.y=(C1.y+C3.y)/2;
       CM2.z=(C1.z+C3.z)/2;
       CM3.x=(C2.x+C3.x)/2;
       CM3.y=(C2.y+C3.y)/2;
       CM3.z=(C2.z+C3.z)/2;
       float s = (float)i/(n-1);
       color c1 = c(KApproximateInSCS(CM1,C2,CM3,s)); // color blended in the SCS (Selcted Color Space)
       PNT P1= Approximate(M1,B,M3,s); // Makes point at parameter s along pareabola through points A, B, C
       disk(P1,rr,c1);
       color c2 = c(KApproximateInSCS(CM2,C3,CM3,s)); // color blended in the SCS (Selcted Color Space)
       PNT P2 = Approximate(M2,C,M3,s); // Makes point at parameter s along pareabola through points A, B, C
       disk(P2,rr,c2);
       color c3 = c(KApproximateInSCS(CM1,C1,CM2,s)); // color blended in the SCS (Selcted Color Space)
       PNT P3 = Approximate(M1,A,M2,s); // Makes point at parameter s along pareabola through points A, B, C
       disk(P3,rr,c3);
      }
    } 
  
}
  
  
// TRIANGLE: Fill triangle
void showFilledTriangle()
  {
  noFill(); strokeWeight(2); if(mousePressed) disk(P,r+4,color(0)); 
  noStroke(); // do not draw border circle around the disks
  //showTri(P1,P2,P3,C1,C2,C3,min(n-3,5));// shows small disks inside triangle of points with selected colors
  showTri1(P1,P2,P3,C1,C2,C3);
  }
 void showTri1(PNT A, PNT B, PNT C, CPNT a, CPNT b, CPNT c)
 {  
   float rr =4;
   float sn=80;
   float sn1=4;
   for(int i = 0; i<sn; i++) // shows disks with interpolating color ramp
    {
    float s = (float)i/(sn-1);
   
    PNT P1 = Interpolate1(B,A,s);
    PNT P2 = Interpolate1(B,C,s);
    CPNT T1=KInterpolateInSCS1(C2,C1,s);
    CPNT T2=KInterpolateInSCS1(C2,C3,s);
    color c1 = c(KInterpolateInSCS1(C2,C1,s));
    color c2= c(KInterpolateInSCS1(C2,C3,s));
    disk(P1,rr,c1);
    disk(P2,rr,c2);
    
      for(int j=0;j<sn1;j++)
      {
        float s1 = (float)j/(sn1-1);
        PNT P3=Interpolate1(P1,P2,s1);
        color c3= c(KInterpolateInSCS1(T1,T2,s1));
        disk(P3,rr,c3);
      }
      
     sn1=sn1+1;
   }
 }
void showTri(PNT A, PNT B, PNT C, CPNT a, CPNT b, CPNT c, int rec) 
  {
  /* ???? you need not use a recursive call, as I did below ???? */  
  showTri(A,B,C,a,b,c,150./(pow(2,rec)),rec);
  }
   
// Show colored disks inside triangle of points (A,B,C) with assigned colors (a,b,c) blended in the SCS 
void showTri(PNT A, PNT B, PNT C, CPNT a, CPNT b, CPNT c, float r, int rec) // recursive call
  {
   /* ???? if you use recursion, replace code below by your code ???? */
   disk(P(A,B,C),r,c(OKinSCS(a,b,c)));
  }
  

// ACCENT: Improve the computation of the accent color and jusify/discuss 
CPNT AccentColorInSCS(CPNT A, CPNT B, CPNT C)
  {
  /* ???? explain my code, provide your improvement, and compare ???? */  
  CPNT Ac = RGBcomplement(A), Bc = RGBcomplement(B), Cc = RGBcomplement(C);
  if(SCSname==_XYZ) {Ac = XYZfromRGB(Ac); Bc = XYZfromRGB(Bc); Cc = XYZfromRGB(Cc); };
  if(SCSname==_LAB) {Ac = LABfromRGB(Ac); Bc = LABfromRGB(Bc); Cc = LABfromRGB(Cc); };
  if(SCSname==_LCH) {Ac = LCHfromRGB(Ac); Bc = LCHfromRGB(Bc); Cc = LCHfromRGB(Cc); };
  CPNT R =  WAK(1./3,Ac,1./3,Bc,1./3,Cc);
  if(SCSname==_XYZ) R = RGBfromXYZ(R); 
  if(SCSname==_LAB) R = RGBfromLAB(R); 
  if(SCSname==_LCH) R = RGBfromLCH(R); 
  //return R;
  return R;
  }
