import processing.serial.*;

String serialPortName = "COM11";
Serial serialPort;
int serialPortBaudRate = 115200;

void setup()
{
  serialPort = new Serial(this, serialPortName, serialPortBaudRate);
}

byte index = 0;
int r = 0;
int g = 0;
int b = 0;
int a = 0;
void draw()
{ 
 
  
  
  
  boolean inc = false;
  if (r < 256)
  {
    r++;
    inc = true;
  }
  else if (g < 256)
  {
    g++;
    inc = true;
  }
  else if (b < 256)
  {
    b++;
    inc = true;
  }
  
  if (inc)
  {
     serialPort.write('#');
     //print('#');
  
     serialPort.write(index);    
    // print(index);
  
    // print(":");
    color c = color(r, g, b, a);
    //print(c);
    serialWriteColor(c);
  
    //println();    
  }
  
  //delay(3);
}

void serialWriteByte(int x)
{
  serialPort.write(x);
}

void serialWriteColor(color c)
{
  //print(':');
  int i0 = (c >> 24) & 0xff;
  //print(binary(i0, 8));
  serialWriteByte(i0);
  
  
  //print('|');
  int i1 = (c >> 16) & 0xff;
  //print(binary(i1, 8));
  serialWriteByte(i1);
  
  //print('|');
  int i2 = (c >> 8) & 0xff;
  //print(binary(i2, 8));
  serialWriteByte(i2);
  
  //print('|');
  int i3 = c & 0xff;
  //println(binary(i3, 8));
  serialWriteByte(i3);
}