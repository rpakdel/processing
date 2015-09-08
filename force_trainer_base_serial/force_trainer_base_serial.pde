import org.gicentre.utils.stat.*;        // For chart classes.
import processing.serial.*;
import org.gicentre.utils.colour.*;

// Sketch to demonstrate the use of the BarChart class to draw simple bar charts.
// Version 1.2, 14th January, 2011.
// Author Jo Wood, giCentre.

// --------------------- Sketch-wide variables ----------------------

BarChart barChart;
PFont titleFont,smallFont;
String portName = "COM14";
Serial port;

// ------------------------ Initialisation --------------------------

// Initialises the data and bar chart.
void setup()
{
  port = new Serial(this, portName, 57600);
  
  size(800,300);
  smooth();
    
  titleFont = loadFont("Helvetica-22.vlw");
  smallFont = loadFont("Helvetica-12.vlw");
  textFont(smallFont);

  barChart = new BarChart(this);
  barChart.setData(new float[] {0, 0, 0});
  barChart.setBarLabels(new String[] {"Attention","Meditation","Conn"});
  ColourTable ctb = new ColourTable();
  ctb.addDiscreteColourRule(0, color(0, 255, 0));
  ctb.addDiscreteColourRule(1, color(0, 0, 255));
  ctb.addDiscreteColourRule(2, color(255, 0, 0));
  barChart.setBarColour(new float[] {0, 1, 2}, ctb);
  barChart.setBarGap(2); 
  barChart.setValueFormat("###");
  barChart.showValueAxis(true); 
  barChart.showCategoryAxis(true); 
  
  barChart.setMinValue(0);
  barChart.setMaxValue(100);
}

// ------------------ Processing draw --------------------

void drawChart()
{
  clear();
  background(255);
  fill(120);
  barChart.draw(10,10,width-20,height-20);
}

int att = 0;
int med = 0;
int con = 0;

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
    int[] nums = int(split(serialData, ' '));
    if (nums.length < 3)
    {
      continue;
    }
    att = nums[0];
    med = nums[1];
    con = nums[2];
    
  } 
  
  barChart.setData(new float[] {att, med, con});
  drawChart();
}