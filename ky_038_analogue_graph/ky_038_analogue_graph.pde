import processing.serial.*;

Serial port;

void setup() 
{
  size(1024, 1024);
  background(0);
  stroke(255);
  
  String portName = "COM8";
  port = new Serial(this, portName, 9600);
}

int count = 0;
int lastH = 512;
void draw() 
{
  while (port.available() > 0) 
  {
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
    int v = int(serialData);
    
    count++;
    int h = int(map(v, 0, 1023, 0, 4098)) - 2048 + 512;
    //int h = v;
    println(h);
    line(count - 1, lastH, count, h);
    lastH = h;
    if (count >= 1024)
    {
      clear();
      count = 1;
    }
  }
}