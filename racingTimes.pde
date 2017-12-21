void heartbeatSimulator() {
  if (millis()%100>0) {
    curvesPositions[0]+=heartrateP1/16f;
    curvesPositions[1]+=heartrateP2/16f;
  }
  //curvesPositions;
  if (curvesPositions[0]>328) curvesPositions[0]=0;
  if (curvesPositions[1]>328) curvesPositions[1]=0;
  drawHeartrates();
}

void drawHeartrates() {
  image(curveBGR, 60, 181);
  image(curveBGR, 1081, 181);
  if (heartrateP1>maxHeartrate) {
    image(curves[1], 60-curvesPositions[0], 232f);
    image(curves[1], 388-curvesPositions[0], 232f);
  } else {
    image(curves[0], 60-curvesPositions[0], 232f);
    image(curves[0], 388-curvesPositions[0], 232f);
  }
  
  if (heartrateP2>maxHeartrate) {
    image(curves[1], 1220-curvesPositions[1], 232f);
    image(curves[1], 1548-curvesPositions[1], 232f);
  } else {  
    image(curves[0], 1220-curvesPositions[1], 232f);
    image(curves[0], 1548-curvesPositions[1], 232f);
  }
}

void valueSimulator() {
  /*heartrateP1=BPM1;//int(map(mouseX, 0, 1920, 0, 240));
  heartrateP2=130;*/

  heartrateIndicatorP1=map(constrain(heartrateP1, minHeartrate, maxHeartrate), 0, 1920, 0, 1);
  heartrateIndicatorP2=map(constrain(heartrateP2, minHeartrate, maxHeartrate), 0, 1920, 0, 1);

  speedP1=int(minSpeed+map(constrain(heartrateP1, minHeartrate, maxHeartrate), minHeartrate, maxHeartrate, 0, 100-minSpeed));
  speedP2=int(minSpeed+map(constrain(heartrateP2, minHeartrate, maxHeartrate), minHeartrate, maxHeartrate, 0, 100-minSpeed));

  /*throttleP1=int(map(mouseY, 0, 1080, 100, 0));
  throttleP2=30;*/
}

void drawDiagrams() {
  stroke(92, 219, 134);
  strokeWeight(20);
  strokeCap(PROJECT);
  noFill();
  if (heartrateP1>maxHeartrate) stroke(249, 87, 103);
  else stroke(92, 219, 134);
  arc(580, 292, 162, 162, PI/2, PI/2+(PI*2)*(trottleP1/100f));

  if (heartrateP2>maxHeartrate) stroke(249, 87, 103);
  else stroke(92, 219, 134);
  arc(1770, 292, 162, 162, PI/2, PI/2+(PI*2)*(trottleP2/100f));
  noStroke();


  if (heartrateP1>maxHeartrate) fill(249, 87, 103);
  else fill(92, 219, 134);
  rect(182, 422, map(constrain(heartrateP1, minHeartrate, maxHeartrate), minHeartrate, maxHeartrate, 0, 196), 22);
  rect(182, 458, map(speedP1, 0, 100, 0, 196), 22);

  if (heartrateP2>maxHeartrate) fill(249, 87, 103);
  else fill(92, 219, 134);
  rect(1590, 422, map(constrain(heartrateP2, minHeartrate, maxHeartrate), minHeartrate, maxHeartrate, 0, 196), 21);
  rect(1590, 458, map(speedP2, 0, 100, 0, 196), 21);

  textAlign(LEFT);
  fill(255);
  textFont(firaRegular24);
  text(heartrateP1, 405,442);
  text(int(speedP1)+"%", 405,478);
  text(heartrateP2, 1806, 442);
  text(int(speedP2)+"%", 1806, 478);

  textAlign(RIGHT);
  textFont(firaRegular36);
  text(int(trottleP1)+"%", 602, 304);  // was 653, 320  -- -51   -16
  text(int(trottleP2)+"%", 1814, 320);

  // show gimmicks for to high and to low heartrates

  // low heartrate
  if (heartrateP1<minHeartrate) {
    if ((millis()/500)%2>0) image(assets[0], 760, 222);
    else image(assets[1], 760, 222);
  }
  if (heartrateP2<minHeartrate) {
    if ((millis()/500)%2>0) image(assets[0], 990, 222);
    else image(assets[1], 990, 222);
  }
  // high heartrate
  if (heartrateP1>maxHeartrate) {
    if ((millis()/200)%2>0) image(assets[2], 760, 222);
  }
  if (heartrateP2>maxHeartrate) {
    if ((millis()/200)%2>0) image(assets[2], 990, 222);
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