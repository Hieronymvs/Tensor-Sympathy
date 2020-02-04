
    /**
    
     There are five versions of <code>getLineIn</code>:
     * <pre>
     * getLineIn()
     * getLineIn(int type) 
     * getLineIn(int type, int bufferSize) 
     * getLineIn(int type, int bufferSize, float sampleRate) 
     * getLineIn(int type, int bufferSize, float sampleRate, int bitDepth)  
     * </pre>
     * The value you can use for <code>type</code> is either <code>Minim.MONO</code> 
     * or <code>Minim.STEREO</code>. <code>bufferSize</code> specifies how large 
     * you want the sample buffer to be, <code>sampleRate</code> specifies the 
     * sample rate you want to monitor at, and <code>bitDepth</code> specifies what 
     * bit depth you want to monitor at. <code>type</code> defaults to <code>Minim.STEREO</code>,
     * <code>bufferSize</code> defaults to 1024, <code>sampleRate</code> defaults to 
     * 44100, and <code>bitDepth</code> defaults to 16. If an <code>AudioInput</code> 
     * cannot be created with the properties you request, <code>Minim</code> will report 
     * an error and return <code>null</code>.
     * 
     * When you run your sketch as an applet you will need to sign it in order to get an input. 
     * 
     * Before you exit your sketch make sure you call the <code>close</code> method 
     * of any <code>AudioInput</code>'s you have received from <code>getLineIn</code>.
     */
     // default values: 
     // type       : Minim.STEREO   (can be changed to Minim.MONO)
     // bufferSize : 1024  (size off sample buffer)
     // sampleRate :44100
     // bitDepth   :16

// list of bugs/glitches
// 1: timer does not reset to 0 returning to rotor 1 (after rotor2).
// 2: text must be stored in single string
//


    import ddf.minim.*;

    Minim minim;
    AudioInput in;
    
    float threshold =0.28; // heartbeat sensitive at 0.05
    
    float [] y;
    float [] z = new float [512];
    float sum;
    int buffersize;
    float avg;
    int time = millis();
    int startTime;
    int deltaTime;
   
    boolean timer = false;
    boolean signal = false;
    int rotorSpeed = 15;
    int counter =0;
    float max;
    float sumMax=0;
    public float fTime = 0;
    public float fRotation;
    public int rev = 0;
    public float rTime;
    float rangeTxt;
    int txt;
    int [] txtArray = new int [100];
   
   int s1;
   int s2;
   int s3;
   int s4;
   int s5;
   
   int rotor=1;
    public String str;
    public int chr;
    
    //PFont jfont;
    //jfont = loadFont("Consolas-Bold-48.vlw");
    //textFont(jfont);
    
    void setup()
    {
      //size(1024, 600, P2D);
      size(512, 900, P2D);
      background(200,200,200);
      //stroke(0);
      textSize(100);
      //textAlign(LEFT);
      textAlign(CENTER, CENTER);
      
      avg = threshold +1.0; // prevent first loop to go through avg<threshold loop
      
      buffersize = 512;
      minim = new Minim(this);
      //minim.debugOn();
      // get a line in from Minim, default bit depth is 16
      in = minim.getLineIn(Minim.STEREO, buffersize,44100);// using a lower setting results in 'lag'(previously 4000)
      //in = minim.getLineIn(Minim.STEREO, 512,2000);
      y = new float[buffersize];
      
     fTime =  millis();
     fRotation = 0;
     rotor = 1;
     
    }

    void draw()
    {
     int time = millis();
     background(255);
  
  
    // Graph
      for(int i = 0; i < in.bufferSize() - 1; i++)
        {
        y[i] =  in.right.get(i);
        sum += abs(y [i]);
        //part of the UI
        // displaying RED:freq wave GREEN:abs(freq) white axis.
        //noStroke();
     //  ellipse(i,height/2 - in.right.get(i)*100,20,20);
     // ellipse(i,height/2,10,(in.right.get(i)*10)); 
     //   rect(0,(height/2)-1,width,1); // horizontal divider
       
        fill(0);
        ellipse(i,height/2 - abs(in.right.get(i)*100),2,2);//absolute values 
        fill(0,0,0,100);
        // square with size x = 1 and y= in.
        rect(i,height/2 - abs(in.right.get(i)*100),1,abs(in.right.get(i)*100));
        fill(100,0,0);
        stroke(0);
       }
    
     avg = (sum/(buffersize));
     UI();
     rotor();
     sum =0;  
          
     // still switching too fast from 1 to 2
     // rotor 1 needs time reset
          
     if (avg >= threshold && rotor ==2 && deltaTime>500){ // deltime needs small lapse otherwise repeats
       
         // timer starts. If timer < value, a subsequent counter ++ won't be possible
        counter++;
         
         fill (0,255,0);
         //if (str = "SPC") 
         txtArray[counter-1] = txt;// first call sets counter to 1 while a 0 is needed. Thus counter-1
   
         //println(deltaTime+"-",rotor);
         //println("##############################");
         rotor =1;
         
         //startTime= 0; // previously, but this doesnt reset time. Timing continues when rotor 1
         startTime= millis();// reset timing 
         deltaTime = 0; // enable reset of rotor
         
     // display a second array
     arrayCopy (y,z);
     //for(int a = 0;a < 512; a++){
     
     //line (a,0,a,z[a]);
     
     //}
         }
         
      //if (avg >= threshold && rotor ==2){
      //   startTime=0;
      //   deltaTime = 0; 
      //   }  
       
     if (avg >= threshold && rotor ==1 && deltaTime>500 ){ // in this case a letter must have been selected thus rotor2 becomes active
     
       timer = false;
       
       rotor = 2; // first time avg>thr rotor changes
       
       
       float max = max(y);// max is the highest value in a single buffer sample.
       sumMax += max; // this is compounding the sum UI indicator.
       
         //startTime=0;// reset timing
         //deltaTime = 0; 
         
         startTime= millis();// reset timing 
         deltaTime = 0; // enable reset of rotor
         
       } //else timer = true;
       
       
       if (avg >= threshold && deltaTime>500 && ( rotor ==1 || rotor ==2 )){
         
         if (txt ==  127) { text ("<DEL",140,130);println("############<DEL##################");}
         if (txt ==  35) { text ("<CLR",140,130);println("############<CLR##################"); counter = counter -1;}
         if (txt ==  2) { text ("<SPC",140,130);println("############<SPC##################");}
         
         rotor =1;
         
         startTime= millis();// reset timing 
         deltaTime = 0; // enable reset of rotor
       
     }
     
    if (avg < threshold) {
      
      if (timer == false){ //timer is false when avg has been above threshold
       startTime = time; // start timing
       timer = true; 
       } else deltaTime = time - startTime;   // timer not false, continue timing 
       
       }
     
     // if q4 selected then modify string + select rotor 1
      // if any of q4 ->
     // if rotor 1, modify string
     // if rotor 2, modify string,make rotor 1
     
    
     
      printText(); 
   //saveFrame("#####.png");
   //saveFrame();
    
} // end void draw

class test {}


void UI() {
      
      strokeWeight(1);
      textAlign(CENTER, CENTER);
      
      noStroke();
      fill (0);
      rect (0,height/2,width,height);// bottom BKG
      //center ellipse
      //noFill();
      //  ellipse (width/2,0.75*height,512,512); 
      
      // bars
      //   line (0.8*width,0,0.8*width, height);// crosshair v
      
      // dynamic avg (average) bar
      //fill(0);
      //rect (0,height,60,-(avg*1000)); 
      
      
      // threshold bar (fixed)
      //rect (0,height-(threshold*1000),60,2);
      
      // max peak bar (compounds)
      //rect (0,height-(max*1000),60,5);     
      //rect (60,height-(sumMax*10),60,2); 
      
      // sumMax bar
      //rect (120,height-(deltaTime/100),60,2);
      
      // timer
      //textSize(15);
      //text ("timer"+deltaTime,120,height-(deltaTime/100));
     
      stroke(255);
      fill(255);
      
      if (rotor == 1){
        textSize(40);
        // 10 degree sectors
        pushMatrix(); // local push-pop
        translate (width/2,height*.75);
        
        // alphabet    
        
        for (int s = 97; s < 97+27; s++){
           rotate ((2*PI)/36);
           //strokeWeight(0.3);
           line (0,0,170,0); // radial line
          // triangle (0,-10,0,10,170,0);
           ellipse (170,0,5,5);// end marker
           
           strokeWeight(1);
         //  textSize(20);
              pushMatrix(); //local pushpop to rotate characters around own axis
              translate(200,0);
              rotate ((-(2*PI)/35)*(s-96));// s+1 because of for loop 0-6
              //text (char(s),100,0);// ascii values
              text (char(s),0,0);// ascii values
              popMatrix();
           
           } 
        popMatrix();
        }   
      
      if (rotor == 2){
        // 10 degree sectors
        fill(255);
        strokeWeight(0.5);
        textAlign(CENTER,CENTER);
        textSize(60);
        
        pushMatrix(); // local push-pop
        translate (width/2,height*.75);
       
        for (int s = 0; s < 5; s++){ // amount of characters
           rotate ((0.75*2*PI)/5);   // rotate one sector forward
          line (0,0,170,0); // radial line
          
          ellipse (170,0,5,5); // end marker
           rotate (((-0.75*2*PI)/5)/2); // rotate half a sector backwards to place character 
            
             //local push-pop to straighten letters
             pushMatrix(); 
             translate(170+(2*s),0);// factor (2*s) is a cosmetic markup so that chars align nicer
             
             //rotate ((((-0.75*2*PI)/5)/2)+((-0.75*2*PI)/5));  // use this if characters must align along radial
             //rotate ((((-0.75*2*PI)/5)*s)+((-0.75*2*PI)/5)/2);// use this if characters muct align vertically
             rotate ((((-0.75*2*PI)/5)*s)+((-0.75*2*PI)/5)/2); // every sector letter must rotate half sector back - s*setors
             text (char(s1+s),0,0);// ascii values
             popMatrix();
             rotate (((0.75*2*PI)/5)/2); // rotate half a sector forward to place new line 
             
             //  text (char(s1+s),100,0);// ascii values
             //rect (0,0,100,5);
         } 
      popMatrix();
        
      } 
      
     //Q4 DEL, SPC, HOME
     textSize(40); 
     pushMatrix(); // local push-pop
       translate (width/2,height*.75);
       rotate ((2*PI)*0.75);// start at 360deg.
       textAlign(CENTER, BOTTOM);
       rotate (((2*PI)/36)*3);
       line (0,0,170,0);
       ellipse (170,0,5,5);
       text(" del",170,0);
       rotate (((2*PI)/36)*3);
       line (0,0,170,0);
       ellipse (170,0,5,5);
       text("clear",170,0);
       rotate (((2*PI)/36)*3);
       line (0,0,170,0);
       ellipse (170,0,5,5);
       text("space",170,0);
     popMatrix();
     
      // push-pop-translated
      pushMatrix();
      translate (width/2,height*.75);
      noFill();
          
      //dynamic circular frequency 
      //fill(0);
      //for (int f = 0; f < buffersize; f++){ // loop buffersize -1 so that y[f] can be drawn one value more             
      //  rotate ((2*PI)/buffersize); //subsequent calls to this function compound the rotation!!!
      //  fill(0,0,0);
      //  rect (50,0,abs((y[f]*200)),abs((y[f]*200)));  // draws rectangles circular, size of line IN
      //  fill(255);
      //  stroke(0);
      //  point (100+(y[f]*100),0);     
      //  }
       
      popMatrix();
      
      stroke(255);
      fill(255);
        
      // rotating dial
      pushMatrix();
      translate (width/2,height*.75);
      //extra UI
      //rotate((2*PI)/60*(millis()/1000));// clock seconds
      rotate(fRotation);// 
      //rect (0,-3,185,6,3,3,3,3);// ////rotating dial
      line(0,0,170,0);
      ellipse (170,0,20,20);
      //fill(255,0,0);
      //ellipse (200/(2*PI)*fRotation,0,6,6);// moving dot along dial
      
      
      //noStroke();
      strokeWeight(20);
      fill(0);
      ellipse (0,0,200,200); // center dot ellipse
      //stroke(1);
      popMatrix();
      
      // display array of samples .divisions -> vertical bars
      // array 512 / 50 or so
      // vertical bars
      strokeWeight(1);
      fill(0,0,0); // color of vertical bars
      for (int s = 0; s < buffersize; s=s+5 ) { 
       // 
       fill (80);
       rect (s,(height/2),5,-abs((z[s]*100)));
      
      }
      
}// end void UI


void rotor(){
      
      pushMatrix();
      translate (width/2,height/2);
            
      rTime = (millis()-fTime)/rotorSpeed;           
      fRotation = ( ( (2*PI)/180 ) * rTime);
  
      if (fRotation > (2*PI)) {
      rTime =0;
      fTime=millis();
      }
      
      // rotor 1
      if (rotor ==1){ 
      textSize(30);
        
      rangeTxt = ((fRotation/(2*PI)) * 35);
      txt = 97 + int(rangeTxt); // convert rotation value to ascii to ro
      
      //if (fRotation >= 0 && fRotation <((2 * PI)*0.25)) {  str = "Q1";}
      //if (fRotation >= ((2 * PI)*0.25) && fRotation <((2 * PI)*0.5)) {  str = "Q2";}
      //if (fRotation >= ((2 * PI)*0.5) && fRotation <((2 * PI)*0.75)) {  str = "Q3";}
          
      chr = txt; // store first selected character for future use
      
      }
       
      if (rotor ==2){     
      // 5+2 sectors
      textSize(15);
       s1 = chr -2;
       s2 = chr -1;
       s3 = chr;
       s4 = chr -1;
       s5 = chr -2;  
      //float sector2 = (2*PI)/7;
      
      rangeTxt = ((fRotation/(2*PI)) * 7);// these two lines moved
      txt = s5 + int(rangeTxt);/// start counting from first letter in dial, txt = initial selected character
      
      //if (fRotation >= 0 && fRotation <sector2) { str = "s1";}
      //if (fRotation >= sector2 && fRotation <sector2*2) {  str = "s2";}
      //if (fRotation >= sector2*2 && fRotation <sector2*3) {  str = "s3";}
      //if (fRotation >= sector2*3 && fRotation <sector2*4) {  str = "s4";}
      //if (fRotation >= sector2*4 && fRotation <sector2*5) {  str = "s5";}
      
      // character r tiny circle
      
      }//end rotor 2
      
      // Q4 
      float sec = ((2*PI)/12);// 1 quart = 3 sectors (sec)
      float top = ((2*PI)*0.75);
      if (fRotation >= (top) && fRotation <(top+sec)) { str = "<DEL";txt = 127;}
      if (fRotation >= (top+sec) && fRotation <(top+2*sec)) { str = "<CLR";txt = 35;}
      if (fRotation >= (top+2*sec) && fRotation <(top+3*sec)) { str = "<SPC";txt = 32;}
      
      popMatrix();
      
      //fill(255,0,0);
      //text (str, width/2,(height*.75));   // writing str in center circle
    }

void printText(){
     textSize(100); 
     fill(255,0,0,200); // single character cell     
     text (char(txt)+" ",50,100);
     
     
     strokeWeight(0.5);
     fill(255,255,255,20);
     stroke(0,0,0,10);
     
     // brush stroke
     pushMatrix();
     translate(width/2,height*0.75);
     for(int a = 0;a < 512; a++){
     rotate (((2*PI)/512.0));
     //ellipse (200-(abs(z[a]*100)*2),0,30,30);
     rect (100,-1,(abs(z[a]*100)*1),3);
      
     }
     popMatrix();
    
     String[] chars = new String[counter];     
     //if (chr == 35);//clear
     for(int a = 0; a < counter; a++){
     // text (char(txtArray[a]),(100+(12*a)),100);
     chars[a] = str(char(txtArray[a])); 
     } 
     
    // main text line 
    String joinedChrtrs = join(chars, ""); 
    //troke(255);
    fill(0);
    textSize(120); 
    textAlign(LEFT,CENTER);
    text (joinedChrtrs,0,150);
    textAlign(CENTER, CENTER);
   
    txt= 0; 
}

public static String removeLastChar(String joinedChrtrs) {
    return (joinedChrtrs == null || joinedChrtrs.length() == 0)
      ? null
      : (joinedChrtrs.substring(0, joinedChrtrs.length() - 1));
}

void stop()
     {
      // always close Minim audio classes when you are done with them
      println("Application Stopped");
      in.close();
      minim.stop();
      super.stop();
     }
    
void keyPressed() {
     final int k = keyCode;
     if (k == 'S') loop();
     else         noLoop();
     }
