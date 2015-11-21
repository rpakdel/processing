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

Minim minim;
BeatDetect beat;
AudioInput in;
AudioPlayer song;

int numBands = 16;
float[] eRadius;

void setup()
{
  eRadius = new float[numBands];
  for(int i = 0; i < numBands; ++i)
  {
    eRadius[i] = 20;
  }
  
  size(400, 400, P3D);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO);  
  beat = new BeatDetect(in.bufferSize(), in.sampleRate());
  
  //song = minim.loadFile("marcus_kellis_theme.mp3", 1024);
  //song.play();
  
  // a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  //beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  
  ellipseMode(RADIUS);  
  
 
}

void draw()
{
  background(0);
  beat.detect(in.mix);
  int size = beat.detectSize();
  println(size);
  int w = size / numBands;
  for (int i = 1; i <= numBands; i++)
  {
    int index = i - 1;
    float a = map(eRadius[index], 20, 80, 60, 255);
    fill(60, 255, 0, a);
    
    int band = w * i - w/2;
    //println(band);
    if ( beat.isOnset(band) )
    {
      float level = in.mix.level() * 1000;
      eRadius[index] = level;
      fill(255, 255, 0, 255);
    }
    ellipse(width * i/(numBands + 1), height * i/(numBands + 1), eRadius[index], eRadius[index]);
    eRadius[index] *= 0.85;
  }
}