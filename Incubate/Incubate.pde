//cc Daniel Prohasky

import processing.serial.*;
Serial port;

String serialLine;
String[] lineArr = {"", "", ""};

boolean trig = false;

Table table;

int s = second();  // Values from 0 - 59
int m = minute();  // Values from 0 - 59
int h = hour();    // Values from 0 - 23
int d = day();    // Values from 1 - 31
int mo = month();  // Values from 1 - 12
int y = year();   // 2003, 2004, 2005, etc.
String date = y + "-" + mo + "-" + d;
String time = h + ":" + m + ":" + s;
long id = 0;

void setup() {

  table = new Table();

  table.addColumn("id");
  table.addColumn("time");
  table.addColumn("H");
  table.addColumn("P");
  table.addColumn("T");



  // open serial port if Arduino connected
  size(300, 300);
  port = new Serial(this, "COM8", 9600);
  port.bufferUntil('\n');
}

void draw() {
  if (trig) {
    print(serialLine);
    s = second();  // Values from 0 - 59
    m = minute();  // Values from 0 - 59
    h = hour();    // Values from 0 - 23
    d = day();    // Values from 1 - 31
    mo = month();  // Values from 1 - 12
    y = year();   // 2003, 2004, 2005, etc.
    date = y + "-" + mo + "-" + d;
    time = h + ":" + m + ":" + s;
    id = table.getRowCount();
    println(id + "," + date + " " + time + "," + lineArr[0] + "," + lineArr[1] + "," + lineArr[2]);
    TableRow newRow = table.addRow();

    newRow.setLong("id", id);
    newRow.setString("time", date + " " + time);
    newRow.setInt("H", int(lineArr[0]));
    newRow.setInt("P", (int(lineArr[1])<0) ? 50 : int(lineArr[1]));
    newRow.setFloat("T", float(lineArr[2]));
      saveTable(table, "data/Mycelium-" + date + ".csv");
    trig=false;
  }
  //background(map(lineArr[0],0,pow(2,lineArr[1]),0,255),0,0);
}

void serialEvent (Serial port) {
  serialLine = port.readStringUntil('\n'); //read next line of data
  lineArr = splitTokens(serialLine, "HPT \n\r");
  trig = true;
}

void keyPressed() {

}
