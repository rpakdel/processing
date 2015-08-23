/**
 * Simple Read
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 */


import processing.serial.*;

Serial port;

void setup() 
{
  size(600, 600);
  String portName = "COM8";
  port = new Serial(this, portName, 9600);
}

void draw()
{
  while (port.available() > 0) 
  {  // If data is available,
    int lf = 10; // Linefeed in ASCII
    String serialData = port.readStringUntil(lf);
    if (serialData == null)
    {
      continue;
    }
    serialData = serialData.substring(0, serialData.length() - 2);
    print("(");
    print(serialData);
    println(")");
    int[] nums = int(split(serialData, ','));
    if (nums.length < 3)
    {
      continue;
    }
    int red = nums[0];
    int green = nums[1];
    int blue = nums[2];
    background(red, green, blue);
  }
}