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
  serialPort.write('#');
  serialPort.write(index);
  
  print(index);
  print(":");
  int m = index % 4;
  r = 0;
  g = 0;
  b = 0;
  a = 0;
  if (m == 0)
  {
    r = 255;  
    print("R:");
  }
  
  else if (m == 1)
  {
    g = 255;
    print("G:");
  }
  else if (m == 2)
  {
    b = 255;
    print("B:");
  }
  else if (m == 3)
  {
    a = 255;
    print("A:");
  }
  
  color c = color(r, g, b, a);
  print(c);
  serialWriteColor(c);
  
  println();
  index++;
  if (index >= 16)
  {
    index = 0;
  }
  delay(3000);
}

void serialWriteByte(int x)
{
  serialPort.write(x);
}

void serialWriteColor(color c)
{
  print(':');
  int i0 = (c >> 24) & 0xff;
  print(binary(i0, 8));
  serialWriteByte(i0);
  
  
  print('|');
  int i1 = (c >> 16) & 0xff;
  print(binary(i1, 8));
  serialWriteByte(i1);
  
  print('|');
  int i2 = (c >> 8) & 0xff;
  print(binary(i2, 8));
  serialWriteByte(i2);
  
  print('|');
  int i3 = c & 0xff;
  println(binary(i3, 8));
  serialWriteByte(i3);
}