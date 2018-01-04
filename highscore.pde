
void drawTable(int myId, int myPositionY) {
  Table savedTable;
  savedTable = loadTable("highscore.csv", "header");                                                            // load highscore table

  int displayEntries=savedTable.getRowCount();                                                                   // get the total row number of the table
  if (displayEntries>20) displayEntries=20;                                                                      // if more then 20 entries, limit to 20 to display

  boolean inTopRange=false;                                                                                      // flag to memorise if player is in top range
  textFont(highscoreFont48);

  for (int i=0; i<displayEntries; i++) {                                                                          // output the top range
    //println(i+"\t"+savedTable.getString(i, 1)+"\t"+savedTable.getString(i, 2)+"\t"+savedTable.getString(i, 3));  // output entries



    if (myId==savedTable.getInt(i, 0)) {                                                                                        // if player id is found, player is in top range
      fill(92, 219, 134);                                                                                                       // set color to green
      inTopRange=true;                                                                                                          // set flag
    } else {
      fill(255);                                                                                                                // set color to white
    }

    textAlign(LEFT);
    if (savedTable.getString(i, 2).length()>18) text(savedTable.getString(i, 2).substring(0, 18), 570, 500+i*50+myPositionY);   // if name to long, cut
    else text(savedTable.getString(i, 2), 570, 500+i*50+myPositionY);                                                           // else just print it

    textAlign(RIGHT);
    text(i+1, 479, 500+i*50+myPositionY);
    text(createTimeString(savedTable.getLong(i, 1)), 1520, 500+i*50+myPositionY);
  }

  if (inTopRange==false) {                                                                                                      // if player is not in top range
    fill(92, 219, 134);                                                                                                         // set color to green
    TableRow result = savedTable.findRow(str(myId), "Id");                                                                      // get the data row
    textAlign(LEFT);

    if (result.getString(2).length()>18) text(result.getString(2).substring(0, 18), 570, 500+displayEntries*50+myPositionY);    // if name to long, cut
    else text(result.getString(2), 570, 500+displayEntries*50+myPositionY);                                                     // else just print it


    textAlign(RIGHT);
    text(displayEntries+1, 479, 500+displayEntries*50+myPositionY);
    text(createTimeString(result.getLong(1)), 1520, 500+displayEntries*50+myPositionY);
  }
}


int writeToTable(long myTime, String myName, int myPulse) {        // method returns the id of the player in the table
  Table tempTable, savedTable;

  tempTable = new Table();
  savedTable = loadTable("highscore.csv", "header");             // load highscore table

  tempTable=savedTable;

  int theId = tempTable.getRowCount();                            // stores the Id of the table entry

  TableRow newRow = tempTable.addRow();
  newRow.setInt("Id", theId);
  newRow.setLong("Time", myTime);
  newRow.setString("Name", myName);
  newRow.setInt("Heartrate", myPulse);
  tempTable.sort("Time");                                         // sort the table by time
  saveTable(tempTable, "data/highscore.csv");

  return theId;
}