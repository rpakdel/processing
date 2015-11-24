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

int numBands = 2;
float[] eRadius;
color[] colors;
color[] beats;
float levelScale = 1;

String serialPortName = "COM8";
Serial serialPort;
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
  
  size(600, 400, P3D);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO);  
  beat = new BeatDetect(in.bufferSize(), in.sampleRate());
  
  //song = minim.loadFile("marcus_kellis_theme.mp3", 1024);
  //song.play();
  
  // a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  //beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  
  ellipseMode(RADIUS);  
  stroke(255, 255, 255);
}

void draw()
{
  if (keyPressed)
  {
     if (key == '=')
     {
       levelScale += 0.1;
     }
     else if (key == '-')
     {
       levelScale -= 0.1;
       if (levelScale <= 0.0001)
       {
         levelScale = 0.0001;
       }
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
    beats[index] = color(0, 0, 0, 255);
    
    int band = w * i - w/2;
    //println(band);
    if ( beat.isOnset(band) )
    {
      beats[index] = color(255, 255, 255, 255);
      
      float level = abs(in.mix.level()) * levelScale * 100;      
      //println(level);
      
      
      eRadius[index] = 120 * level;
      
      
      int red = (int)red(colors[index]);
      int green =  (int)green(colors[index]);
      int blue = (int)blue(colors[index]);
      
      
      
      if (beat.isKick())
      {
        red = 255;
      }
      
      if (beat.isSnare())
      {
        green = 255;
      }
      
      if (beat.isHat())
      {
        blue = 255;
      }
     
      colors[index] = color(red, green, blue, 200);
      fill(colors[index]);
    }
            
    // draw a circle
    ellipse(width * i/(numBands + 1), height / 2.0, eRadius[index], eRadius[index]);
    
    // reduce size of circle
    eRadius[index] *= 0.85;
    color c = colors[index];
    colors[index] = color(red(c) * 0.85, green(c) * 0.85, blue(c) * 0.85);
  }
  
  writeValuesToSerial();
}

int count = 0;
void writeValuesToSerial()
{
  String line = "";
  //String printLine = "";
  for(int index = 0; index < numBands; index++)
  {
    if (index > 0)
    {
      //line += ",";      
    }
    color c = beats[index];
    
    line = line + hex(c);
    //printLine = printLine + (int)red(c) + "," + (int)green(c) + "," + (int)blue(c) + "|";
  }
  line += ";";
  println(count + ": " + line);
  //println(line.length());
  serialPort.write(line);

  count++;
  if (count > 1000)
  {
    count = 0;
  }
}