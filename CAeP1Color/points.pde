class PNT 
  { 
  float x=0,y=0; 
  PNT (float px, float py) {x = px; y = py;}
  void setTo(PNT P) {x=P.x; y=P.y;}
  }
PNT P() {return P(0,0); }                                                                       // make point (0,0)
PNT P(float x, float y) {return new PNT(x,y); }                                                       // make point (x,y)
PNT P(PNT P) {return P(P.x,P.y); }                                                                    // make copy of point A
void disk(PNT P, float r, color c) {fill(c); ellipse(P.x, P.y, 2*r, 2*r);}                                               // draws circle of center r around P
void circ(PNT P, float r, color c) {stroke(c); ellipse(P.x, P.y, 2*r, 2*r);}                                               // draws circle of center r around P
float d2(PNT P, PNT Q) {return sq(Q.x-P.x)+sq(Q.y-P.y); };                                             // AB*AB (Distance squared)
float d(PNT P, PNT Q) {return sqrt(d2(P,Q)); }                                                       // ||AB|| (Distance)
PNT P(float a, PNT A, float b, PNT B) {return P(a*A.x+b*B.x,a*A.y+b*B.y);}   // aA+bB, (assumes a+b+c=1) 
PNT P(float a, PNT A, float b, PNT B, float c, PNT C) {return P(a*A.x+b*B.x+c*C.x,a*A.y+b*B.y+c*C.y);}   // aA+bB+cC, (assumes a+b+c=1) 
PNT P(PNT A, float t, PNT B){return P(1.-t,A,t,B);}
PNT P(PNT A, PNT B){return P(0.5,A,0.5,B);}
PNT P(PNT A, PNT B, PNT C){return P(1./3,A,1./3,B,1./3,C);}
PNT O(PNT A, PNT B, PNT C){return P(-1,A,1,B,1,C);}
PNT Interpolate(PNT A, PNT B, PNT C, float t){return Interpolate(0,A,0.5,B,1,C,t);}
PNT Interpolate1(PNT A, PNT B, float t){return Interpolate1(0,A,1,B,t);}
PNT ScreenCenter() {return P(width/2,height/2);}                                                        //  point in center of  canvas
PNT Mouse() {return P(mouseX,mouseY);};                                                                 // returns point at current mouse location
PNT Pmouse() {return P(pmouseX,pmouseY);};                                                              // returns point at previous mouse location


void rect(PNT P, float w, float h, color c) {}                                               // draws circle of center r around P
