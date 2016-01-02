/**
  * This sketch demonstrates how to use the BeatDetect object song SOUND_ENERGY mode.<br />
  * You must call <code>detect</code> every frame and then you can use <code>isOnset</code>
  * to track the beat of the music.
  * <p>
  * This sketch plays an entire song, so it may be a little slow to load.
  * <p>
  * For more information about Minim and additional features, 
  * visit http://code.compartmental.net/minim/
  */
  
import ddf.minim.*;
import ddf.minim.analysis.*;

import processing.serial.*;

Minim minim;
BeatDetect beat;
AudioInput in;
AudioPlayer song;

int numBands = 16;
float[] eRadius;
color[] colors;
color[] beats;
float levelScale = 1;
float levelIncrement = 0.1;

String serialPortName = "COM4";
Serial serialPort = null;
int serialPortBaudRate = 115200;

void setup()
{
  
  serialPort = new Serial(this, serialPortName, serialPortBaudRate);
  
  eRadius = new float[numBands];
  colors = new color[numBands];
  beats = new color[numBands];
  for(int i = 0; i < numBands; ++i)
  {
    eRadius[i] = 20;
    colors[i] = color(0, 0, 0);
  }
  
  size(1000, 400, P3D);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO);  
  beat = new BeatDetect(in.bufferSize(), in.sampleRate());
  beat.setSensitivity(100);  
  
  //song = minim.loadFile("marcus_kellis_theme.mp3", 1024);
  //song.play();
  
  // a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  //beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  
  ellipseMode(RADIUS);  
  stroke(255, 255, 255);
}

color pixelOnColor = color(25, 25, 25, 255);
color pixelOffColor = color(0, 0, 0, 255);

boolean pixelsOn = true;
void togglePixels(int d)
{
  color pixelsColor;
  if (pixelsOn)
  {
    pixelsOn = false;
    pixelsColor = pixelOnColor;
  }
  else
  {
    pixelsOn = true;
    pixelsColor = pixelOffColor;
  }
  
  background(pixelsColor);
  for(int i = 0; i < 17; i++)
  {
    serialWritePixel(i, pixelsColor);
  }
  delay(d);
}

void toggleOnePixel(int pixelIndex)
{
  for(int i = 0; i < 17; i++)
  {
    if (i == pixelIndex)
    {
      serialWritePixel(i, pixelOnColor);
    }
    else
    {
      serialWritePixel(i, pixelOffColor);
    }
  }
}

void clockPixels(int d)
{
  for(int i = 0; i < 16; i++)
  {
    toggleOnePixel(i);
    //delay(d);
  }
}

int p = 0;

void draw()
{ 
  clockPixels(1);
  
  
  //detectBeat();
  
}

void detectBeat()
{
  if (keyPressed)
  {
     if (key == '=')
     {
       levelScale += levelIncrement;
       println(levelScale);
     }
     else if (key == '-')
     {
       levelScale -= levelIncrement;
       if (levelScale <= 0.0001)
       {
         levelScale = 0.0001;         
       }
       println(levelScale);
     }     
  }
  
  background(0);
  beat.detect(in.mix);
  int size = beat.detectSize();
  //println(size);
  int w = size / numBands;
  for (int i = 1; i <= numBands; i++)
  {
    int index = i - 1;
    
    // if it's not a beat, draw with previous color
    fill(colors[index]);
    //beats[index] = color(0, 0, 0, 255);
    
    int band = w * i - w/2;
    //println(band);
    if ( beat.isOnset(band) )
    {
      
      
      float level = abs(in.mix.level()) * levelScale * 200;      
      //println(level);
      
      //if (level > 1.0)
      //{
        beats[index] = color(255, 255, 255, 255);
      //}
      
      
      eRadius[index] = level;
      
      
      int red = 0;//(int)red(colors[index]);
      int green =  0;//(int)green(colors[index]);
      int blue = 0;//(int)blue(colors[index]);
      
      
      
      if (beat.isKick())
      {
        red = 255;
      }
      else if (beat.isSnare())
      {
        green = 255;
      }
      else if (beat.isHat())
      {
        blue = 255;
      }
      else
      {
        red = green = blue = 255;
      }
           
      colors[index] = color(red, green, blue, 200);
      beats[index] = color(red, green, blue, 255);
      serialWritePixel(index, beats[index]);
      fill(colors[index]);
      
    }
    else
    {
      color cNoBeat = beats[index];
      serialWritePixel(index, cNoBeat);
    }
            
    // draw a circle
    ellipse(width * i/(numBands + 1), height / 2.0, eRadius[index], eRadius[index]);
    
    // reduce size of circle
    eRadius[index] *= 0.8;
    color c = colors[index];
    color cBeat = beats[index];
    colors[index] = color(red(c) * 0.7, green(c) * 0.7, blue(c) * 0.7);
    beats[index] = color(red(cBeat) * 0.7, green(cBeat) * 0.7, blue(cBeat) * 0.7);
  }
  
  //writeValuesToSerial();
}

void writeValuesToSerial()
{
  for(int index = 0; index < numBands; index++)
  {
    color c = beats[index];
    serialWritePixel(index, c);
  }
}

byte[] getSerialWritePixelBytes(int pixelIndex, color c)
{
  byte[] bytes = new byte[6];
  fillSerialWritePixelBytes(bytes, pixelIndex, c);
  return bytes;
}

void fillSerialWritePixelBytes(byte[] bytes, int pixelIndex, color c)
{
  bytes[0] = '#';
  bytes[1] = (byte)pixelIndex;
  
  bytes[2] = (byte) ((c >> 24) & 0xff);
  bytes[3] = (byte) ((c >> 16) & 0xff);
  bytes[4] = (byte) ((c >> 8) & 0xff);
  bytes[5] = (byte) (c & 0xff);
}

byte[] pixelBytes = new byte[6];
void serialWritePixel(int pixelIndex, color c)
{
  //print(pixelIndex);
  //print("|");
  //println(hex(c));
   if (serialPort != null)
   {
     fillSerialWritePixelBytes(pixelBytes, pixelIndex, c);
     serialPort.write(pixelBytes);     
   }   
}

void serialWriteByte(int x)
{
  if (serialPort != null)
  {
    serialPort.write(x);
  }
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