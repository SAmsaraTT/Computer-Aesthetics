// ************************** Picture utilities **************************
int pictureCounter=0;
int pictureCounterPDF=0, pictureCounterJPG=0, pictureCounterTIF=0; 
String PicturesFileName = "Pictures";

boolean snapJPG=false;
void snapPictureToJPG() {saveFrame("MyImages/"+PicturesFileName+"/P"+SCSname+nf(pictureCounterJPG++,3)+".jpg"); snapJPG=false;}

PImage PictureOfMyFace1; // picture of author's face, should be: data/pic.jpg in sketch folder
PImage PictureOfMyFace2;
PImage PictureOfMyFace3;
PFont font;

// ************************** Text utilities **************************

void displayHeader()  // Displays title and authors face on screen
    {
    int i = 0;
    scribeHeader(title,i++);                                                     
    scribeHeader(subtitle,i++);    
    scribeHeader(name,i++); 
    image(PictureOfMyFace1,620 ,50,80,100); 
    image(PictureOfMyFace2,710 ,50,80,100); 
    image(PictureOfMyFace3,800 ,50,80,100); 
    scribeHeader(guide,i++);  // (cheatsheet) guide is in the gui tab
    }

void scribe(String S, float x, float y) {fill(0); text(S,x,y); noFill();} // writes on screen at (x,y) with current fill color
void scribeHeader(String S, int i) { text(S,10,25+i*25); noFill();} // writes black at line i
void scribeHeaderRight(String S, int i) {fill(0); float w = textWidth(S); text(S,width-w-10,25+i*25); noFill();} // writes black on screen top, right-aligned
void scribeFooter(String S, int i) {scribeFooter(S,i,0);} // writes black on screen at line i from bottom
void scribeFooter(String S, int i, color c) {fill(c); text(S,10,height-10-i*25); noFill();} // writes black on screen at line i from bottom
void scribeAtMouse(String S) {fill(0); text(S,mouseX,mouseY); noFill();} // writes on screen near mouse

// ************************** Clipboard utilities **************************
public static String getClipboard() // returns content of clipboard or null
   {   
   Transferable t = Toolkit.getDefaultToolkit().getSystemClipboard().getContents(null);
   try {if (t != null && t.isDataFlavorSupported(DataFlavor.stringFlavor)) {
           String text = (String)t.getTransferData(DataFlavor.stringFlavor);
           return text; }} 
   catch (UnsupportedFlavorException e) { } catch (IOException e) { }
   return null;
   }
public static void setClipboard(String str) // loads str into clipboard
   { 
   StringSelection ss = new StringSelection(str);
   Toolkit.getDefaultToolkit().getSystemClipboard().setContents(ss, null);
   }
