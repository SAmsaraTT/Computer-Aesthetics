/*
EDITING SELECTED COLOR
  ‘1’, ‘2’, ‘3’: select color to edit
  ‘I’: import selected color from clipboard (“#123456”)
  ‘W’: write selected color to clipboard (“CPNT C1=K(..),…”)
  'A': save ramp declaration to clipboard
  ‘r’/‘g’/‘b’: press&drag mouse horizontally to edit R/G/B
  ‘x’/‘y’/‘z’: press&drag mouse horizontally to edit X/Y/Z
  ‘l’/‘a’/‘s’: press&drag mouse horizontally to edit L/a/b
  ‘l’/‘c’/‘h’: press&drag mouse horizontally to edit L/c/h

CHANGE NUMBER OF COLORS IN RAMP 
  ‘,’ / ‘.’ increment/decrement
  ‘<’ / ‘>’ divide by 2 / multiply by 2

CHANGE MODE AND OPTIONS
‘C’: set Default (coverpage) mode

‘D’: set disks mode
  ‘d’ regenerate random disks
  ‘m’ regenerate random color from ramp for each disk

‘R’: set ramp mode
  ‘i’ toggle interpolating vs approximating
  ‘L’ toggle curve segment vs closed loop

‘T’: set triangle mode

CHANGE SELECTED COLOR SPACE (SCS)
  ‘G’: RGB
  ‘X’: XYZ
  ‘P’: Las 
  ‘H’: Lch

CAPTURE PICTURES OF CANVAS
  ‘f’: set clipboard content F as start of filenames for pictures 
  ‘!’: snaps new picture F+counter+SCS

*/

String guide=" G:rgb X:xyz P:las H:lch V:456 L:789 "; // help info
void keyPressed() 
  {
  if(key=='!') {snapJPG=true; println("saved pix to: MyImages/"+PicturesFileName+"/P"+SCSname+nf(pictureCounterJPG,3)+".jpg");}// make a .PDF picture of the canvas, compact, poor quality
  if(key==',') {n=max(3,n-1);  } 
  if(key=='.'&&n<=9) {n++; }
  if(key=='<') {n=int((n+1)/2);  if(n<3) n=3; } 
  if(key=='>') {n=2*n-1; }
  if(key=='G') {SCSname=_RGB; SCS = "RGB"; makeColors();}
  if(key=='X') {SCSname=_XYZ; SCS = "XYZ"; makeColors();}
  if(key=='P') {SCSname=_LAB; SCS = "LAB"; makeColors();} 
  if(key=='H') {SCSname=_LCH; SCS = "LCH"; makeColors();}
  if(key=='V') {SCSname=_HSV; SCS = "HSV"; makeColors();}
  if(key=='L') {SCSname=_HSL; SCS = "HSL"; makeColors();}
  if(key=='C') showing=_cover;
  if(key=='W') setClipboard("CPNT C1=K"+Si(C1)+", C2=K"+Si(C2)+", C3=K"+Si(C3)+";"); // write string to clpiboard
  if(key=='f') {PicturesFileName=getClipboard(); println("PicturesFileName = "+PicturesFileName+" .");} // get fileName from clipboard
  if(key=='m') makeColors();
  if(key=='d') makeDisks(); 
  if(key=='I') // Import color from clipboard
    {
    if(selectedColor==1) C1 = CLRfromClipboard(); 
    if(selectedColor==2) C2 = CLRfromClipboard(); 
    if(selectedColor==3) C3 = CLRfromClipboard();
    setSpaceColorsFromSelectedColor();
    //SCSname=_RGB; updateColors();
    }
  if(key=='1') {selectedColor=1; setSpaceColorsFromSelectedColor();}
  if(key=='2') {selectedColor=2; setSpaceColorsFromSelectedColor();}
  if(key=='3') {selectedColor=3; setSpaceColorsFromSelectedColor();}
  if(key=='A') setClipboard(StringOfRamp(C1,C2,C3,interpolating));
  }
void mousePressed() 
  {
  P=P1;
  PNT M = Mouse();
  if(d(P2,M)<d(P,M)) P=P2;
  if(d(P3,M)<d(P,M)) P=P3;
  }
void mouseDragged() 
  {
  if(!keyPressed) P.setTo(O(Pmouse(),Mouse(),P));
  else
    {
    if(key=='r') {K_RGB.x+=125.*float(mouseX-pmouseX)/width; SCSname=_RGB;}
    if(key=='g') {K_RGB.y+=125.*float(mouseX-pmouseX)/width; SCSname=_RGB;}
    if(key=='b') {K_RGB.z+=125.*float(mouseX-pmouseX)/width; SCSname=_RGB;}
    if(key=='x') {K_XYZ.x+= 50.*float(mouseX-pmouseX)/width; SCSname=_XYZ;}
    if(key=='y') {K_XYZ.y+= 50.*float(mouseX-pmouseX)/width; SCSname=_XYZ;}
    if(key=='z') {K_XYZ.z+= 50.*float(mouseX-pmouseX)/width; SCSname=_XYZ;}
    if(key=='l') {K_LCH.x+= 50.*float(mouseX-pmouseX)/width; SCSname=_LCH;}
    if(key=='c') {K_LCH.y+=200.*float(mouseX-pmouseX)/width; SCSname=_LCH;}
    if(key=='h') {K_LCH.z+=100.*float(mouseX-pmouseX)/width; SCSname=_LCH;}
    if(key=='a') {K_LAB.y+=100.*float(mouseX-pmouseX)/width; SCSname=_LAB;}
    if(key=='s') {K_LAB.z+=100.*float(mouseX-pmouseX)/width; SCSname=_LAB;}
    if(key=='4') {K_HSV.x+=1.*float(mouseX-pmouseX)/width;SCSname=_HSV;}
    if(key=='5') {K_HSV.y+=1.*float(mouseX-pmouseX)/width;SCSname=_HSV;}
    if(key=='6') {K_HSV.z+=1.*float(mouseX-pmouseX)/width;SCSname=_HSV;}  
    if(key=='7') {K_HSL.x+=1.*float(mouseX-pmouseX)/width;SCSname=_HSL;}
    if(key=='8') {K_HSL.y+=1.*float(mouseX-pmouseX)/width;SCSname=_HSL;}
    if(key=='9') {K_HSL.z+=1.*float(mouseX-pmouseX)/width;SCSname=_HSL;}  

    updateColors();    
    }
  }
  
