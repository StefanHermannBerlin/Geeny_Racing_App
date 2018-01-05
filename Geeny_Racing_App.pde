// make name entering nice
// put sound in (starting light, music, motors)
// get video running again -> // path animations

//import processing.video.*;
import processing.serial.*;         // serial library lets us talk to Arduino
import controlP5.*;                 // library to create input fields for player names
//Movie movie;

ControlP5 cp5;                      // object containing text fields for player names 
int myState=10;                      // state machine (should be 10)

// serial variables
int BPM1 = 80;         // HOLDS HEART RATE VALUE FROM ARDUINO
int BPM2 = 80;         // HOLDS HEART RATE VALUE FROM ARDUINO
Serial port;  // the serial port


// settings
String player1Name="Rachael Rosen";
String player2Name="Rick Deckard";

int lapsTotal=10;                   // number of maximal laps to go
int maxHeartrate=150;               
int minHeartrate=60;
int minSpeed=50;

int heartrateP1=90;
int heartrateP2=90;

int trottleP1=10;
int trottleP2=10;

// load the used fonts
PFont highscoreFont36;
PFont highscoreFont48;
PFont highscoreFont80;
PFont highscoreFont120;
PFont highscoreFont144;
PFont firaRegular24;
PFont firaRegular36;

// the used images
PImage[] images = new PImage[12];
PImage[] assets = new PImage[3];
PImage[] sekt = new PImage[3];
PImage korken, highscoreList;
PImage[] curves = new PImage[2];   // heartrate diagrams
PImage curveBGR;                   // heartrate diagrams
String[] curvesUrls = {"curveGreen.png", "curveRed.png"};
String curveBGRUrl ="curveBackground.png";
String[] imageUrls = {"Get ready to race.png", "Countdown.png", "Countdown Copy.png", "Countdown Copy 2.png", "Countdown Copy 3.png", "Countdown Copy 4.png", "Countdown Copy 5.png", "Race Screen.png", "Winner Screen.png", "Highscore Screen.png", "Header.png", "Animations.png"};
String[] assetUrls = {"asset-jumpup.png", "asset-jumpdown.png", "asset-heart.png"};
String[] sektUrls = {"Winner Screen Copy 2.png", "Winner Screen Copy 3.png", "Winner Screen Copy 4.png"};
String highscoreURL = "Highscore List.png";
int assetNumber = 3;
int sektNumber = 3;
int imageNumber = 12;               // number of images 
int currentImage=0;                 // the image what is displayed in this very moment

// styles
int player1NamePositionX;           // player screen animation helper variable
int player2NamePositionX;           // player screen animation helper variable


int speedP1=0;
int speedP2=0;
int maxSpeedP1;
int maxSpeedP2;

float heartrateIndicatorP1=0;
float heartrateIndicatorP2=0;

int currentLapP1=0;                 // lap counter Player 1
int currentLapP2=0;                 // lap counter Player 2
int[] heartratesP1 = new int[10];   // heartratesP1
int[] heartratesP2 = new int[10];   // heartratesP2
long[] laptimeP1 = new long[10];    // lap times player 1
long[] laptimeP2 = new long[10];    // lap times player 2
long[] totaltimeP1 = new long[10];  // lap times player 1
long[] totaltimeP2 = new long[10];  // lap times player 2
long starttimeP1 = 0;               // storing the millis passed until start player 1
long starttimeP2 = 0;               // storing the millis passed until start player 2
long lapStarttimeP1 = 0;            // storing the millis passed until start player 1
long lapStarttimeP2 = 0;            // storing the millis passed until start player 2
int winner=0;                       // winner 0 = no winner, winner 1 = player 1, winner 2 = player 2
long countdownTimer=0;              // countdown timer
long winnerScreenTimer=0;           // timer to show the winner screen
int winnerScreenTimeout=4000;       // so long one should see the winner screen
long highscoreScreenTimer=0;        // timer to show the highscore screen
int highscoreScreenTimeout1=4000;   // so long one should see the highscore screen without scrolling
int highscoreScreenTimeout2=18000;  // so long one should see the highscore screen scrolling
long raceoverScreenTimer=0;
int raceoverScreenTimeout=4000;

float scrollSpeed = 3.5f;           // scrollspeed

float[] curvesPositions = new float[2];  // heartrate diagrams
int curveNumber=2;                       // heartrate diagrams

boolean addedToHighscore = false;   // stores if the current race was already added to the highscore
int highscoreId = 0;                // highscore table entry id of the current race
int highscorePositionY=0;           // used to scroll the highscore up


void setup() {
  fullScreen(2);
  // size(1920, 1080);
  // size(960, 540);
  //frame.setTitle("123 abc");
  printArray(Serial.list()); // output available serial ports
  port = new Serial(this, Serial.list()[7], 250000);

  // loading fonts
  highscoreFont36 = loadFont("HighscoreHero-36.vlw");
  highscoreFont48 = loadFont("HighscoreHero-48.vlw");
  highscoreFont80 = loadFont("HighscoreHero-80.vlw");
  highscoreFont120 = loadFont("HighscoreHero-120.vlw");
  highscoreFont144 = loadFont("HighscoreHero-144.vlw");
  firaRegular24 = loadFont("FiraSans-Regular-24.vlw");
  firaRegular36 = loadFont("FiraSans-Medium-36.vlw");


  cp5 = new ControlP5(this);                                                                         // holds the input elements for player names
  cp5.addTextfield("Player1").setPosition(20, 100).setSize(200, 40).setAutoClear(false).hide();      // text field for player name 1
  cp5.addTextfield("Player2").setPosition(20, 170).setSize(200, 40).setAutoClear(false).hide();      // text field for player name 2
  cp5.addBang("Submit").setPosition(240, 170).setSize(80, 40).hide();                                // submit button

  // loading images
  for (int i=0; i<imageNumber; i++) {
    images[i] = loadImage(imageUrls[i]);
  }

  for (int i=0; i<assetNumber; i++) {
    assets[i] = loadImage(assetUrls[i]);
  }

  for (int i=0; i<sektNumber; i++) {
    sekt[i] = loadImage(sektUrls[i]);
  }

  for (int i=0; i<curveNumber; i++) {
    curves[i] = loadImage(curvesUrls[i]);
  }
  curveBGR=loadImage(curveBGRUrl);
  highscoreList=loadImage(highscoreURL);
  korken=loadImage("korken.png");

  // Load and play the video in a loop
  //movie = new Movie(this, "geenyAnimationK.mov");
  //  movie = new Movie(this, "GeenyAnimationExample.mov");
  //  movie.loop();
}

void draw() {
  //println(myState);
  switch (myState) {
  case -1:
    player1NamePositionX=1000;         // player screen animation helper variable
    player2NamePositionX=1000;         // player screen animation helper variable
    cp5.get(Textfield.class, "Player1").setVisible(false);
    cp5.get(Textfield.class, "Player2").setVisible(false);
    cp5.get(Bang.class, "Submit").hide();
    addedToHighscore = false;
    myState=0;
    break;

  case 0: // player screen ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** 
    image(images[0], 0, 0);
    textAlign(LEFT);
    fill(255);
    noStroke();
    textFont(highscoreFont144);
    if (true) {
      if (player1NamePositionX>0) player1NamePositionX-=30;
      if (player2NamePositionX>0) player2NamePositionX-=30;
    }
    text(player1Name, 142+player1NamePositionX, 442);
    textAlign(RIGHT);
    text(player2Name, 1865-player2NamePositionX, 830);
    //mouseHelper();
    break;
  case 1: // setting stage for countdown ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** ****
    countdownTimer=millis();
    myState=2;
    break;
  case 2: // countdown ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** ****
    if (int((millis()-countdownTimer)/1000)>5) {     // hier gehört 1000 rein !!! *************
      winner=0;                                    // winner 0 = no winner, winner 1 = player 1, winner 2 = player 2
      starttimeP1=millis();
      starttimeP2=starttimeP1;
      myState=3;
    }
    image(images[int((millis()-countdownTimer)/1000)+1], 0, 0);
    break;
  case 3: // racing screen ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** ****
    background(0);
    drawHeartrates();
    image(images[7], 0, 0);
    //mouseHelper();
    //valueSimulator();
    drawDiagrams();
    drawRacingTimes();
    drawNames();

    if (currentLapP1>=lapsTotal) {
      winner=1;
      myState=4;
      raceoverScreenTimer=millis();
    }
    if (currentLapP2>=lapsTotal) {
      winner=2;
      myState=4;
      raceoverScreenTimer=millis();
    }
    break;
  case 4: // prepare winner screen ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** ****
    background(0);
    drawHeartrates();
    image(images[7], 0, 0);


    //mouseHelper();
    //valueSimulator();
    drawDiagrams();
    drawRacingTimes();
    drawNames();

    if (raceoverScreenTimer+raceoverScreenTimeout<millis()) myState=5;
    //valueSimulator();
    drawDiagrams();
    drawRacingTimes();
    winnerScreenTimer=millis();
    break;
  case 5: // winner screen ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** ****
    image(images[8], 0, 0);                                                                            // background image
    fill(255);                                                                                         // set color to white
    textFont(highscoreFont120);                                                                         // set font
    textAlign(LEFT);                                                                                   // align text to left
    if (winner==1) {                                                                                   // if winner is Player 1        
      if (addedToHighscore==false) {                                                                   // if data was not entered to the highscore
        highscoreId=writeToTable(millis()-starttimeP1, player1Name, heartrateP1);                      // writing data into the highscore
        addedToHighscore=true;                                                                         // set flag it was written into
      }
      text(player1Name, 715, 487);                                                                     // write player name
    } else if (winner==2) {                                                                            // if winner is Player 2
      if (addedToHighscore==false) {                                                                   // if data was not entered to the highscore
        highscoreId=writeToTable(millis()-starttimeP2, player2Name, heartrateP2);                      // writing data into the highscore
        addedToHighscore=true;                                                                         // set flag it was written into
      }
      text(player2Name, 570, 500);                                                                     // write player name
    }
    text("wins !!", 1060, 626);                                                                       // write "wins !!"
    image(korken, (millis()-winnerScreenTimer)/50, -(millis()-winnerScreenTimer)/30);                  // animation of bottle
    image(sekt[0], (millis()-winnerScreenTimer)/60, -(millis()-winnerScreenTimer)/35);                 // animation of bottle
    image(sekt[1], (millis()-winnerScreenTimer)/61, -(millis()-winnerScreenTimer)/36);                 // animation of bottle
    image(sekt[2], (millis()-winnerScreenTimer)/72, -(millis()-winnerScreenTimer)/47);                 // animation of bottle
    if (winnerScreenTimer+winnerScreenTimeout<millis()) myState=6;                                     // after timeout continue 
    break;
  case 6: // prepare highscore screen ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** ****
    highscoreScreenTimer=millis();
    highscorePositionY=0;
    myState=7;
    break;
  case 7: // highscore screen static ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** ****
    background(0);
    //image(highscoreList, 400, highscorePositionY);
    image(images[9], 0, 0);
    drawTable(highscoreId, highscorePositionY);                                                                   // show highscore
    if (highscoreScreenTimer+highscoreScreenTimeout1<millis()) myState=8;
    break;
  case 8: // prepare highscore scrolling screen ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** ****
    highscoreScreenTimer=millis();
    myState=9;
    break;
  case 9: // highscore screen scrolling ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** ****
    background(0);
    drawTable(highscoreId, highscorePositionY);                                                                     // show highscore
    image(images[9], 0, 0);
    if (millis()%40>0) highscorePositionY-=scrollSpeed;
    if (highscoreScreenTimer+highscoreScreenTimeout2<millis()) myState=10;
    break;
  case 10: // geeny movies ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** ****
    background(0);
    geenyAnimationUpdate();
    geenyAnimationDraw();
    resetData();
    break;
  case 11: // enter player 1 name ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** ****
    image(images[9], 0, 0);                                                                            // background image
    cp5.get(Textfield.class, "Player1").setVisible(true);
    cp5.get(Textfield.class, "Player2").setVisible(true);
    cp5.get(Bang.class, "Submit").show();
    break;
  case 12: // enter player 2 name ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** **** ***** **** *** ** * ** *** ****
    image(images[9], 0, 0);                                                                            // background image
    cp5.get(Textfield.class, "Player1").setVisible(false);
    cp5.get(Textfield.class, "Player2").setVisible(false);    
    cp5.get(Bang.class, "Submit").hide();
    if (player1Name.length()>18) player1Name=player1Name.substring(0, 18);                            // if name to long, cut
    if (player2Name.length()>18) player2Name=player2Name.substring(0, 18);                            // if name to long, cut
    myState=-1;                                                                                       // goto versus screen
    break;
  }
}

void mouseHelper() {
  stroke(255);
  strokeWeight(1);
  line(mouseX, 0, mouseX, height);
  line(0, mouseY, width, mouseY);
  noStroke();
}

void mousePressed() {
  print("X= ");
  print(mouseX);
  print("\tY= ");
  println(mouseY);
}

void keyPressed() {
  //println(key);
  if (key == ENTER) {
    if (myState==0) myState=1;
    else if (myState==7) myState=-1;
    else if (myState==9) myState=-1;
    else if (myState==10) myState=11;
    //else if (myState==11) myState=12; // player textfields
    else if (myState==13) myState=-1;  // show both player names
  } else if (key == BACKSPACE) {
    if (myState==1) myState=-1;
    else if (myState==0) myState=11; // player 2 textfield go back
  }

  if ((keyCode == 49)&&((myState==3)||(myState==4))) {                         // when key 1 is pressed, car 1 passed the counter   
    if (currentLapP1<lapsTotal) {        
      if (currentLapP1==0) {
        lapStarttimeP1=starttimeP1;
      }
      totaltimeP1[currentLapP1]=millis()-starttimeP1;
      laptimeP1[currentLapP1]=millis()-lapStarttimeP1;
      heartratesP1[currentLapP1]=heartrateP1;
      currentLapP1++;
      lapStarttimeP1=millis();
    }
  } else if ((keyCode == 50)&&((myState==3)||(myState==4))) {                  // when key 2 is pressed, car 1 passed the counter
    if (currentLapP2<lapsTotal) {        
      if (currentLapP2==0) {
        lapStarttimeP2=starttimeP2;
      }
      totaltimeP2[currentLapP2]=millis()-starttimeP2;
      laptimeP2[currentLapP2]=millis()-lapStarttimeP2;
      heartratesP2[currentLapP2]=heartrateP2;
      currentLapP2++;
      lapStarttimeP2=millis();
    }
  }
}

void resetData() {
  for (int i=0; i<lapsTotal; i++) {
    heartratesP1[i] = 0;
    heartratesP2[i] = 0;
    laptimeP1[i] = 0;
    laptimeP2[i] = 0;
    totaltimeP1[i] = 0;
    totaltimeP2[i] = 0;
  }
  winner=0;
  currentLapP1=0;
  currentLapP2=0;
}

/*void movieEvent(Movie m) {
 m.read();
 }*/

void Submit() {
  print("the following text was submitted :");
  player1Name = cp5.get(Textfield.class, "Player1").getText();
  player2Name = cp5.get(Textfield.class, "Player2").getText();
  print(" textInput 1 = " + player1Name);
  print(" textInput 2 = " + player2Name);
  println();
  myState=12;
}