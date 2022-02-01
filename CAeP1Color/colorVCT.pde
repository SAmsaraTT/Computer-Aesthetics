// In case you want to play with 3D point+vector constructions in the SCS

class CVCT // Color-vector: Difference between two point-vectors
   { 
   float x=0,y=0,z=0; 
   CVCT () {}; 
   CVCT (float px, float py, float pz) {x = px; y = py; z = pz;};
   } // end class vec

////////// Construction of CVCT from CPNT
CVCT V() {return new CVCT(); };                                                                      // make vector (x,y,z)
CVCT V(float x, float y, float z) {return new CVCT(x,y,z); };                                        // make vector (x,y,z)
CVCT V(CVCT V) {return new CVCT(V.x,V.y,V.z); };                                                     // make copy of vector V
CVCT V(float s, CVCT A) {return new CVCT(s*A.x,s*A.y,s*A.z); };                                      // sA
CVCT V(float a, CVCT A, float b, CVCT B) {return A(V(a,A),V(b,B));}                                  // aA+bB 
CVCT V(float a, CVCT A, float b, CVCT B, float c, CVCT C) {return A(V(a,A,b,B),V(c,C));}             // aA+bB+cC
CVCT U(CVCT V) {float n = n(V); if (n<0.0000001) return V(0,0,0); else return V(1./n,V);};           // V/||V||
CVCT A(CVCT A, CVCT B) {return new CVCT(A.x+B.x,A.y+B.y,A.z+B.z); };                                 // A+B
CVCT A(CVCT U, float s, CVCT V) {return V(U.x+s*V.x,U.y+s*V.y,U.z+s*V.z);};                          // U+sV
CVCT M(CVCT U, CVCT V) {return V(U.x-V.x,U.y-V.y,U.z-V.z);};                                         // U-V
CVCT M(CVCT V) {return V(-V.x,-V.y,-V.z);};                                                          // -V
CVCT Cross(CVCT U, CVCT V) {return V( U.y*V.z-U.z*V.y, U.z*V.x-U.x*V.z, U.x*V.y-U.y*V.x); };         // UxV cross product (normal to both)

////////// Construction of CVCT from CPNT
CVCT V(CPNT P, CPNT Q) {return new CVCT(Q.x-P.x,Q.y-P.y,Q.z-P.z);};          // PQ
CVCT Cross(CPNT A, CPNT B, CPNT C) {return Cross(V(A,B),V(A,C)); };          // normal to triangle (A,B,C), not normalized (proportional to area)
CVCT U(CPNT P, CPNT Q) {return U(V(P,Q));};                                  // PQ/||PQ||

////////// Construction of CPNT from CPNT
CPNT P(float x, float y, float z) {return new CPNT(x,y,z); };                                            // point (x,y,z)
CPNT P(float s, CPNT A) {return new CPNT(s*A.x,s*A.y,s*A.z); };                                            // sA
CPNT P(float a, CPNT A, float b, CPNT B) {return A(P(a,A),P(b,B));}                                        // aA+bB 
CPNT P(float a, CPNT A, float b, CPNT B, float c, CPNT C) {return A(P(a,A),P(b,B,c,C));}                     // aA+bB+cC 
CPNT P(float a, CPNT A, float b, CPNT B, float c, CPNT C, float d, CPNT D){return A(P(a,A,b,B),P(c,C,d,D));}   // aA+bB+cC+dD
CPNT A(CPNT A, CPNT B) {return new CPNT(A.x+B.x,A.y+B.y,A.z+B.z); };                                         // A+B
CPNT P(CPNT A, CPNT B, CPNT C) {return new CPNT((A.x+B.x+C.x)/3.0,(A.y+B.y+C.y)/3.0,(A.z+B.z+C.z)/3.0); };     // (A+B+C)/3
CPNT projectionOnLine(CPNT P, CPNT A, CPNT B) {return P(A,dot(V(A,B),V(A,P))/dot(V(A,B),V(A,B)),V(A,B));}

////////// Construction of CPNT from CPNT and scaled CVCTs
CPNT P(CPNT P, float s, CVCT V) {return new CPNT(P.x+s*V.x,P.y+s*V.y,P.z+s*V.z);}                           // P+sV
CPNT P(CPNT O, float x, CVCT I, float y, CVCT J) {return P(O.x+x*I.x+y*J.x,O.y+x*I.y+y*J.y,O.z+x*I.z+y*J.z);}  // O+xI+yJ
CPNT P(CPNT O, float x, CVCT I, float y, CVCT J, float z, CVCT K) {return P(O.x+x*I.x+y*J.x+z*K.x,O.y+x*I.y+y*J.y+z*K.y,O.z+x*I.z+y*J.z+z*K.z);}  // O+xI+yJ+kZ

////////// Rotations of CPNT or CVCTs
CVCT R(CVCT V) {return V(-V.y,V.x,V.z);} // rotated 90 degrees in XY plane
CPNT R(CPNT P, float a, CVCT I, CVCT J, CPNT G) {float x=dot(V(G,P),I), y=dot(V(G,P),J); float c=cos(a), s=sin(a); return P(P,x*c-x-y*s,I,x*s+y*c-y,J); }; // Rotated P by a around G in plane (I,J)
CVCT R(CVCT V, float a, CVCT I, CVCT J) {float x=dot(V,I), y=dot(V,J); float c=cos(a), s=sin(a); return A(V,V(x*c-x-y*s,I,x*s+y*c-y,J)); }; // Rotated V by a parallel to plane (I,J)
CPNT R(CPNT Q, float a) {float dx=Q.x, dy=Q.y, c=cos(a), s=sin(a); return P(c*dx+s*dy,-s*dx+c*dy,Q.z); };  // Q rotated by angle a around the origin
CPNT R(CPNT Q, float a, CPNT C) {float dx=Q.x-C.x, dy=Q.y-C.y, c=cos(a), s=sin(a); return P(C.x+c*dx-s*dy, C.y+s*dx+c*dy, Q.z); };  // Q rotated by angle a around point P
CPNT R(CPNT Q, CPNT C, CPNT P, CPNT R)  // returns rotated version of Q by angle(CP,CR) parallel to plane (C,P,R)
   {
   CVCT I0=U(C,P), I1=U(C,R), V=V(C,Q); 
   float c=dot(I0,I1), s=sqrt(1.-sq(c)); 
        if(abs(s)<0.00001) return Q; // singular cAW
   CVCT J0=V(1./s,I1,-c/s,I0);  
   CVCT J1=V(-s,I0,c,J0);  
   float x=dot(V,I0), y=dot(V,J0);
   return P(Q,x,M(I1,I0),y,M(J1,J0)); 
   } 
   
////////// Measures and tests
float dot(CVCT U, CVCT V) {return U.x*V.x+U.y*V.y+U.z*V.z; };       //U*V dot product
float mixed(CVCT U, CVCT V, CVCT W) {return dot(U,Cross(V,W)); };   // U*(VxW)  mixed product, determinant
float angle(CVCT U, CVCT V) {return acos(dot(U,V)/n(V)/n(U)); };    // angle(U,V) positive  (in 0,PI)
float n2(CVCT V) {return sq(V.x)+sq(V.y)+sq(V.z);};                 // V*V    norm squared
float n(CVCT V) {return sqrt(n2(V));};                              // ||V||  norm
float triangleArea(CPNT A, CPNT B, CPNT C) {return n(Cross(A,B,C))/2; };                        // (positive) area of triangle in 3D
float tetVolume(CPNT A, CPNT B, CPNT C, CPNT D) {return mixed(V(A,B),V(A,C),V(A,D))/6; };       // (signed) volume of tetrahedron
boolean projectsBetween(CPNT P, CPNT A, CPNT B) {return dot(V(A,P),V(A,B))>0 && dot(V(B,P),V(B,A))>0 ; };


CPNT X(CPNT C1, CPNT C2, CPNT C3)
  {
  CPNT A = P(C1,C2,C3);
  float a = triangleArea(C1,C2,C3);
  CVCT N = U(Cross(V(C2,C1),V(C2,C3)));
  return P(A,sqrt(a),N);
  }
