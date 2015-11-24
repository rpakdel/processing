import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer song;
AudioInput in;
BeatDetect beat;
 
float eRadius;
 
void setup()
{
  size(200, 200, P3D);
  minim = new Minim(this);
  minim.debugOn();
  
  //song = minim.loadFile("marcus_kellis_theme.mp3", 2048);
  //song.play();
  
    // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, int(1024));
  
  // a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  beat = new BeatDetect();
 
  ellipseMode(CENTER_RADIUS);
  eRadius = 20;
}
 
void draw()
{
  background(0);
  beat.detect(in.mix);
  float a = map(eRadius, 20, 80, 60, 255);
  fill(60, 255, 0, a);
  if ( beat.isOnset() ) eRadius = 80;
  ellipse(width/2, height/2, eRadius, eRadius);
  eRadius *= 0.95;
  if ( eRadius < 20 ) eRadius = 20;
}
 
void stop()
{
  // always close Minim audio classes when you are finished with them
  //song.close();
  in.close();
  // always stop Minim before exiting
  minim.stop();
 
  super.stop();
} 