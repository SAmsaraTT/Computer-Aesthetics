// ******* DISK MODE (random disks with random color fron ramp
int nd = 200; // number of disks
float[] R = new float[nd]; 
float[] X = new float[nd]; 
float[] Y = new float[nd];
color[] Colors = new color[nd];
float rs=10, rl=50, xs=0, xl=900, ys=0, yl=600; // limits

// ******* DEFAULT MODE (show color ramp)
void showCover()
    {
    noStroke();
    fill(c(backgroundColor)); 
    rect(width/4, 315, width/2, 90*4+40); // fills background with mean color
    PNT A = P(120,400), B = P(225,220), C = P(330,400);
    disk(A,90,c(C1)); disk(B,90,c(C2)); disk(C,90,c(C3)); // shows disks filled with input colors
    disk(P(A,B,C),30,c(accentColor)); // shows small disk with accent color
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


void makeColors() // computes mean, accent and ramp colors
  {
  backgroundColor = MeanColorInSCS(C1,C2,C3); // set mean color
  accentColor = AccentColorInSCS(C1,C2,C3); // set accent color
  for(int d = 0; d<nd; d++) Colors[d] = c(KInterpolateInSCS(C1,C2,C3,((float)floor(random(0,n)))/(n-1)));
  }

void makeDisks()
  {
  for(int d = 0; d<nd; d++)
    {
    float r = random(rs,rl);
    R[d] = r;
    X[d] = random(xs+r,xl-r);
    Y[d] = random(ys+r,yl-r);
    }
  }

void showDisks() 
  { 
  fill(c(backgroundColor)); rect((xl+xs)/2, (yl+ys)/2, xl-xs, yl-ys); // fills background with mean color
  stroke(c(accentColor)); strokeWeight(3);
  for(int d = 0; d<nd; d++) disk(P(X[d],Y[d]),R[d],Colors[d]);
  noStroke();
  fill(c(accentColor)); scribeHeaderRight(SCS,24);
  }


    
// ******* RAMP MODE
void showRamp()
  {
  ramp(P1,P2,P3,C1,C2,C3,interpolating);
  }
  
void ramp(PNT A, PNT B, PNT C, CPNT C1, CPNT C2, CPNT C3, boolean interpolating)
  {
  float rr = r; //width/n/2; 
  noStroke(); // do not draw border circle around the disks
  for(int i = 0; i<n; i++) // shows disks with interpolating color ramp
    {
    float s = (float)i/(n-1); // parameter in [0,1] of the current sample used to compute its position P and color c
    if(interpolating) 
      {
      color c = c(KInterpolateInSCS(C1,C2,C3,s)); // color blended in the SCS (Selcted Color Space)
      PNT P = Interpolate(A,B,C,s); // Makes point at parameter s along pareabola through points A, B, C
      disk(P,rr,c);
      }
    else 
      {
      color c = c(KApproximateInSCS(C1,C2,C3,s)); // color blended in the SCS (Selcted Color Space)
      PNT P= Approximate(A,B,C,s); // Makes point at parameter s along pareabola through points A, B, C
      disk(P,rr,c);
      }
    }
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

String StringOfRamp(CPNT C1, CPNT C2, CPNT C3, boolean interpolating)
  {
  CPNT Ci = K();
  String S = "CPNT[] CLRramp={";
  for(int i = 0; i<n; i++) 
    {
    float s = (float)i/(n-1); 
    if(interpolating) 
      {
      Ci = KInterpolateInSCS(C1,C2,C3,s); 
      }
    else 
      {
      Ci = KApproximateInSCS(C1,C2,C3,s); 
      }
    S = S + S(Ci);
    if(i<n-1) S = S + ",";
    }
  S = S+"};";
  return S;
  }
