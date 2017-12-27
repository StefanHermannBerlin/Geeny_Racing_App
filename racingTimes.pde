void drawHeartrates() {                                                // drawing the heart curves
  if (millis()%100>0) {                                                  // timer
    curvesPositions[0]+=heartrateP1/16f;                                 // calculate later curve image position dependent on heartrate
    curvesPositions[1]+=heartrateP2/16f;                                 // calculate later curve image position dependent on heartrate 
  }
  if (curvesPositions[0]>328) curvesPositions[0]=0;                      // if position out of range, flip to 0 
  if (curvesPositions[1]>328) curvesPositions[1]=0;                      // if position out of range, flip to 0
  image(curveBGR, 60, 181);                                              // drawing background image
  image(curveBGR, 1393, 181);                                            // drawing background image
  if (heartrateP1>maxHeartrate) {                                        // if heartrate ok, load normal color images
    image(curves[1], 60-curvesPositions[0], 232f);                       // draw image
    image(curves[1], 388-curvesPositions[0], 232f);                      // draw image to create a long image with several waves
  } else {                                                               // if heartrate to high, load warning color images
    image(curves[0], 60-curvesPositions[0], 232f);                       // draw image
    image(curves[0], 388-curvesPositions[0], 232f);                      // draw image to create a long image with several waves
  }
  if (heartrateP2>maxHeartrate) {                                        // if heartrate ok, load normal color images
    image(curves[1], 1220-curvesPositions[1], 232f);                     // draw image
    image(curves[1], 1548-curvesPositions[1], 232f);                     // draw image to create a long image with several waves
  } else {                                                               // if heartrate to high, load warning color images  
    image(curves[0], 1470-curvesPositions[1], 232f);                     // draw image
    image(curves[0], 1798-curvesPositions[1], 232f);                     // draw image to create a long image with several waves
  }
}

void drawNames(){                                                      // showing names on racing screen
  textFont(highscoreFont80);
  textAlign(LEFT);
  text(player1Name, 60, 123);                // show player 1 name

  textAlign(RIGHT);
  text(player2Name, 1870, 123);                // show player 2 name
}

void drawDiagrams() {                                                  // drawing diagrams of the racing screen
  //                                                                   // draw trottle arcs
  stroke(92, 219, 134);                                                  // formating
  strokeWeight(20);                                                      // formating
  strokeCap(PROJECT);                                                    // formating
  noFill();                                                              // formating
  if (heartrateP1>maxHeartrate) stroke(249, 87, 103);                    // set color
  else stroke(92, 219, 134);                                             // if heartrate to high, change color 
  arc(580, 292, 162, 162, PI/2, PI/2+(PI*2)*(trottleP1/100f));           // draw arc for trottle
  if (heartrateP2>maxHeartrate) stroke(249, 87, 103);                    // set color
  else stroke(92, 219, 134);                                             // if heartrate to high, change color
  arc(1339, 292, 162, 162, PI/2, PI/2+(PI*2)*(trottleP2/100f));          // draw arc for trottle
  noStroke();                                                            // formating
  //                                                                   // draw trottle text 
  textAlign(RIGHT);                                                      // formating
  textFont(firaRegular36);                                               // formating
  text(int(trottleP1)+"%", 614, 304);                                    // draw trottle % player 1
  text(int(trottleP2)+"%", 1372, 304);                                   // draw trottle % player 2
  //                                                                   // draw bar graphs heartrate and max speed
  if (heartrateP1>maxHeartrate) fill(249, 87, 103);                      // set color
  else fill(92, 219, 134);                                               // if heartrate to high, change color
  rect(182, 422, map(constrain(heartrateP1, minHeartrate, maxHeartrate), minHeartrate, maxHeartrate, 0, 196), 22);    // draw heartrate
  rect(182, 458, map(maxSpeedP1, 0, 100, 0, 196), 22);                   // draw max speed
  if (heartrateP2>maxHeartrate) fill(249, 87, 103);                      // set color
  else fill(92, 219, 134);                                               // if heartrate to high, change color
  rect(1590, 422, map(constrain(heartrateP2, minHeartrate, maxHeartrate), minHeartrate, maxHeartrate, 0, 196), 21);    // draw heartrate
  rect(1590, 458, map(maxSpeedP2, 0, 100, 0, 196), 21);                  // draw max speed
  //                                                                   // draw text for bar graphs
  textAlign(LEFT);                                                       // formating
  fill(255);                                                             // formating
  textFont(firaRegular24);                                               // formating
  text(heartrateP1, 405, 442);                                           // output text heartrate player 1
  text(int(maxSpeedP1)+"%", 405, 478);                                   // output text max speed player 1
  text(heartrateP2, 1806, 442);                                          // output text heartrate player 2
  text(int(maxSpeedP2)+"%", 1806, 478);                                  // output text max speed player 2
  //                                                                   // show gimmicks for to high and to low heartrates

  if (heartrateP1<minHeartrate) {                                        // low heartrate player 1
    if ((millis()/500)%2>0) image(assets[0], 683, 206);                  // display animation picture
    else image(assets[1], 683, 206);                                     // display animation picture
  }
  if (heartrateP2<minHeartrate) {                                        // low heartrate player 2
    if ((millis()/500)%2>0) image(assets[0], 1072, 206);                 // display animation picture
    else image(assets[1], 1072, 206);                                    // display animation picture
  }
  // high heartrate
  if (heartrateP1>maxHeartrate) {                                        // high heartrate player 1          
    if ((millis()/200)%2>0) image(assets[2], 685, 206);                  // display animation picture            
  }
  if (heartrateP2>maxHeartrate) {                                        // high heartrate player 2
    if ((millis()/200)%2>0) image(assets[2], 1065, 206);                 // display animation picture
  }
}

void drawRacingTimes() {
  for (int i=0; i<10; i++) {
    textFont(highscoreFont36);
    fill(255);
    textAlign(LEFT);
    if (currentLapP1>i) text(heartratesP1[i], 59, 700+(i*36)); // heartrate

    textAlign(CENTER);

    if (winner==1) fill(92, 219, 134);
    if (currentLapP1>i) text(createTimeString(laptimeP1[i]), 349, 700+(i*36));
    if (currentLapP1>i) text(createTimeString(totaltimeP1[i]), 627, 700+(i*36));
    fill(255);
    text(i+1, 961, 700+(i*36));
    if (winner==2) fill(92, 219, 134);

    if (currentLapP2>i) text(createTimeString(totaltimeP2[i]), 1293, 700+(i*36));
    if (currentLapP2>i) text(createTimeString(laptimeP2[i]), 1574, 700+(i*36));

    textAlign(RIGHT);
    if (currentLapP2>i) text(heartratesP2[i], 1862, 700+(i*36)); // heartrate
  }
}

String createTimeString(long milliseconds) {
  String myMilliSeconds=""; 
  String mySeconds="";
  String myMinutes="";  

  if ((milliseconds%1000)<10) {
    myMilliSeconds="00"+(milliseconds%1000);
  } else if ((milliseconds%1000)<100) {
    myMilliSeconds="0"+(milliseconds%1000);
  } else {
    myMilliSeconds=""+(milliseconds%1000);
  }

  if (((milliseconds%60000)/(1000))<10) {
    mySeconds="0"+((milliseconds%60000)/(1000));
  } else {
    mySeconds=""+((milliseconds%60000)/(1000));
  }


  if ((milliseconds/(60000))<10) {
    myMinutes="0"+(milliseconds/(60000));
  } else {
    myMinutes=""+(milliseconds/(60000));
  }

  return myMinutes+":"+mySeconds+":"+myMilliSeconds;
}