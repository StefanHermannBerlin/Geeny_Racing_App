void serialEvent(Serial port) {

  /*
  
   P1= output bpm
   T1= output trottle
   S1= output car speed
   X1= output maximal possible car speed
   P2= output bpm
   T2= output trottle
   S2= output car speed
   X2= output maximal possible car speed
   
   */

  try {
    String inData = port.readStringUntil('\n');
    inData = trim(inData);                 // cut off white space (carriage return)

    if (inData.charAt(0) == 'P') {             // P = bpm, T = trottle, S = Car Speed, X = maximal possible Car speed 
      if (inData.charAt(1) == '1') {           // 1 = player 1
        inData = inData.substring(3);          // cut off the leading 'XX='
        heartrateP1=int(inData);               // set heartrate of player
      } else if (inData.charAt(1) == '2') {    // 2 = player 2
        inData = inData.substring(3);          // cut off the leading 'XX='
        heartrateP2=int(inData);               // set heartrate of player
      }
    }

    if (inData.charAt(0) == 'T') {             // P = bpm, T = trottle, S = Car Speed, X = maximal possible Car speed 
      if (inData.charAt(1) == '1') {           // 1 = player 1
        inData = inData.substring(3);          // cut off the leading 'XX='
        trottleP1=int(inData);                // set trottle of player
      } else if (inData.charAt(1) == '2') {    // 2 = player 2
        inData = inData.substring(3);          // cut off the leading 'XX='
        trottleP2=int(inData);                // set trottle of player
      }
    }

    if (inData.charAt(0) == 'S') {             // P = bpm, T = trottle, S = Car Speed, X = maximal possible Car speed 
      if (inData.charAt(1) == '1') {           // 1 = player 1
        inData = inData.substring(3);          // cut off the leading 'XX='
        speedP1=int(inData);                   // set speed of player
      } else if (inData.charAt(1) == '2') {    // 2 = player 2
        inData = inData.substring(3);          // cut off the leading 'XX='
        speedP2=int(inData);                   // set speed of player
      }
    }

    if (inData.charAt(0) == 'X') {             // P = bpm, T = trottle, S = Car Speed, X = maximal possible Car speed 
      if (inData.charAt(1) == '1') {           // 1 = player 1
        inData = inData.substring(3);          // cut off the leading 'XX='
        maxSpeedP1=int(map(float(inData),0,400,0,100));
        //heartrateP1=int(inData);             // set max speed of player
      } else if (inData.charAt(1) == '2') {    // 2 = player 2
        inData = inData.substring(3);          // cut off the leading 'XX='
        maxSpeedP2=int(map(float(inData),0,400,0,100));
        //heartrateP2=int(inData);             // set max speed of player
      }
    }

    if (inData.charAt(0) == 'C') {                                                // Breaking a light barrier 
      if ((inData.charAt(1) == '1')&&((myState==3)||(myState==4))) {              // when key 1 is pressed, car 1 passed the counter   
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
      } else if ((inData.charAt(1) == '2')&&((myState==3)||(myState==4))) {       // when key 2 is pressed, car 1 passed the counter
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
  } 
  catch(Exception e) {
    //println(e.toString());
  }
}// END OF SERIAL EVENT