int PointR=20;
PVector PVectorR=new PVector(PointR,PointR);
float MaxXLocal;
float MinXLocal;
float MaxYLocal;
float MinYLocal;
ArrayList<Man> ManList = new ArrayList<Man>();
int DeadManCount=0;
boolean DeathEnable=false;
String TextBuffer="";
int TotalE=0;
boolean ReDraw=false;
int[] PIXNearbyPointCount;
int CCount=1;
boolean BasicModel=false;
boolean DrawELine=false;
int[] TotalEList=new int[1];
int[] AreaSizeList=new int[1];
int[] ManListLenthList=new int[1];
int[] InsideRPointCount=new int[1];
int MaxManCount=100000;
int lineLength=1000;

void setup()
{
  size(1000,1000);
  background(250);
  PIXNearbyPointCount=new int[height*width];
  for(int i=0;i<height*width;i++)
  {
    PIXNearbyPointCount[i]=0;
  }
  //fill(125,125);
  //ellipse(400,400,2*PointR,2*PointR);
  Man NewMan=new Man();
  NewMan.Local=new PVector(height/2,width/2);
  MaxXLocal=NewMan.Local.x +PointR;
  MinXLocal=NewMan.Local.x -PointR;
  MaxYLocal=NewMan.Local.y +PointR;
  MinYLocal=NewMan.Local.y -PointR;
  NewMan.FillColor=color(random(255),random(255),random(255),125);
  NewMan.BrithFrame=frameCount;
  ManList.add(NewMan);
  TotalEList[0]=0;
  AreaSizeList[0]=1324;
  ManListLenthList[0]=ManList.size();
  if(!BasicModel)
  {
    PIXNearbyPointCountAdd(NewMan.Local);
  }
  if(ReDraw==false)
  {
    fill(NewMan.FillColor);
    noStroke();
    ellipse(NewMan.Local.x,NewMan.Local.y,PointR*2,PointR*2);
  }
  frameRate(200);
}

void draw()
{   
  //boolean a = false;
  if(ReDraw)
  {
    background(250);
  }  
  else
  {
    noStroke();
    fill(250,255);
    rect(0, 0, 160, 200);
    //text(TextBuffer,20,20);
  }
  fill(0);
  PVector NewLocal;
  if(BasicModel)
  {
    NewLocal=new PVector(random(width),random(height));
    TextBuffer="Basic Model.\r\n";
  }
  else
  {
    NewLocal=randomProducing();
    TextBuffer="Improved Model.\r\n";
  }
  TextBuffer+="Map Width=:"+width+"\r\n";
  TextBuffer+="Map Height=:"+height+"\r\n";
  TextBuffer+="A Man's R=:"+PointR+"\r\n";
  TextBuffer+="Frame Rate:"+frameRate+"\r\n";
  TextBuffer+="Draw E Link:"+DrawELine+"\r\n";
  TextBuffer+="Frame:"+frameCount+"\r\nLive Man:"+ManList.size() + "\r\nDead Man:"+DeadManCount+"\r\nReDraw:"+ReDraw;
  if(ManList.size()>0)
  {
    for(Man OldMan:ManList)
    {
      //PVector Length=OldMan.sub(NewMan);
      if(dist(NewLocal.x,NewLocal.y,OldMan.Local.x,OldMan.Local.y)<PointR)
      {
        Man NewMan=new Man();
        NewMan.Local=NewLocal;
        if(NewMan.Local.x-PointR <MinXLocal)
        {
          MinXLocal=NewMan.Local.x-PointR;
          if(MinXLocal<0)
          {
            MinXLocal=0;
          }
        }
        else if(NewMan.Local.x +PointR>MaxXLocal)
        {
          MaxXLocal=NewMan.Local.x+PointR;
          if(MaxXLocal>width)
          {
            MaxXLocal=width;
          }
        }
        if(NewMan.Local.y-PointR <MinYLocal)
        {
          MinYLocal=NewMan.Local.y-PointR;
          if(MinYLocal<0)
          {
            MinYLocal=0;
          }
        }
        else if(NewMan.Local.y +PointR>MaxYLocal)
        {
          MaxYLocal=NewMan.Local.y +PointR;
          if(MaxXLocal>height)
          {
            MaxXLocal=height;
          }
        }
        NewMan.FillColor=color(random(255),random(255),random(255),125);
        NewMan.BrithFrame=frameCount;
        for(Man OtherMan:ManList)
        {
          if(dist(OtherMan.Local.x,OtherMan.Local.y,NewMan.Local.x,NewMan.Local.y)<PointR)
          {
            TotalE+=2;
            if(DrawELine)
            {
              OtherMan.E.add(OldMan.Local);
              NewMan.E.add(OtherMan.Local);
            }            
          }
        }        
        if(ReDraw==false)
        {
          fill(NewMan.FillColor);
          noStroke();
          ellipse(NewMan.Local.x,NewMan.Local.y,PointR*2,PointR*2);
          if(DrawELine)
          {
            fill(0);
            stroke(0);
            for(PVector link:NewMan.E)
            {
              line(link.x,link.y,NewMan.Local.x,NewMan.Local.y);
            }            
          }          
        }
        ManList.add(NewMan);
        if(!BasicModel)
        {
          PIXNearbyPointCountAdd(NewMan.Local);
        }
        break;
      }
      
    }
    TextBuffer+="\r\nTotal E:"+TotalE;
    if(DeathEnable)
    {
      if(frameCount - ManList.get(0).BrithFrame>1000)
      {
        ManList.remove(0);
        DeadManCount++;
      }
      TextBuffer+="\r\nDeath Enable!";
    }
    else
    {
      TextBuffer+="\r\nLive Forever!";
    }        
    if(ReDraw)
    {
      for(Man AllMan:ManList)
      {
        fill(AllMan.FillColor);
        noStroke();
        ellipse(AllMan.Local.x,AllMan.Local.y,PointR*2,PointR*2);
        if(frameCount-AllMan.BrithFrame<200)
        {
          fill(0);
          stroke(0);
          for(PVector link:AllMan.E)
          {
            line(link.x,link.y,AllMan.Local.x,AllMan.Local.y);
          }
        }      
      }
    }
    
    if(ManList.size()>=MaxManCount)
    {
      TextBuffer+="\r\nMan Win!";      
      noLoop();
      //TextBuffer+="\r\nArea Size:"+AreaSize;
      fill(0);
      text(TextBuffer,20,20);
      saveFrame("Pic/LastFrame.png");
      FileExport();
      DrawXYCoordinate();
    }
  }
  else 
  {
    TextBuffer+="\r\nSaDan Win!";
    noLoop();
  }
  loadPixels();
  int AreaSize=0;
  for(int x=int(MinXLocal);x<=MaxXLocal;x++)
  {
    for(int y=int(MinYLocal);y<=MaxYLocal;y++)
    {
      if(pixels[x*width +y]!=color(250))
      {
        AreaSize++;
      }
    }
  }
  //for(int i=0;i<height*width;i++)
  //{
  //  if(pixels[i]!=color(250))
  //  {
  //    AreaSize++;
  //  }
  //  //if(pixels[i]==color(0))
  //  //{
  //  //  pixels[i]=color(250);
  //  //}
  //}
  updatePixels();
  TextBuffer+="\r\nArea Size:"+AreaSize;
  fill(0);
  text(TextBuffer,20,20);
  TotalEList=append(TotalEList,TotalE);
  AreaSizeList=append(AreaSizeList,AreaSize);
  ManListLenthList=append(ManListLenthList,ManList.size());
}

void PIXNearbyPointCountAdd(PVector PointAddress)
{
  for(int x=int(PointAddress.x-PointR);x<=int(PointAddress.x+PointR);x++)
  {
    for(int y=int(PointAddress.y-PointR);y<=int(PointAddress.y+PointR);y++)
    {
      if(x>=0 && x<width && y>=0&& y<height)
      {
        if(dist(x,y,PointAddress.x,PointAddress.y)<PointR)
        {
          PIXNearbyPointCount[width*x +y]++;
        }
      }      
    }
  }  
}
PVector randomProducing()
{
  long sum=0;
  for(int PointCount:PIXNearbyPointCount)
  {
    sum+=PointCount+CCount;
  }
  float randomCount=random(sum);
  sum=0;
  int CountBack=0;
  for(int PixNumber=0;PixNumber<PIXNearbyPointCount.length;PixNumber++)
  {
    sum+=PIXNearbyPointCount[PixNumber]+CCount;
    if(sum>=randomCount)
    {
      CountBack=PixNumber;
      break;
    }
  }
  return(new PVector(CountBack/width,CountBack%width));
}

void FileExport()
{
  saveStrings("DataExport/AreaSize.txt", str(AreaSizeList));  
  saveStrings("DataExport/TotalE.txt", str(TotalEList));  
  saveStrings("DataExport/PIXNearbyPointCount.txt",str(PIXNearbyPointCount));
  saveStrings("DataExport/ManListLenthList.txt",str(ManListLenthList));
  RProcessing();
}
void RProcessing()
{

  float Farthest=max(max(MinXLocal-width/2,MaxXLocal-width/2),max(MinYLocal-height/2,MinYLocal-height/2));
  for(int R=1;R<Farthest;R++)
  {
    int TotalPointCount=0;
    for(Man OnePoint:ManList)
    {
      if(dist(OnePoint.Local.x,OnePoint.Local.y,width/2,height/2)<=R)
      {
        TotalPointCount++;
      }
    }
    InsideRPointCount=append(InsideRPointCount,TotalPointCount);
  }
  saveStrings("DataExport/InsideRPointCount.txt",str(InsideRPointCount));
}

void DrawXYCoordinate()
{
  int[] FrameNumber=new int[frameCount];
  for(int i=1;i<frameCount;i++)
  {
    FrameNumber[i]=i;
  }
  drawCoordinate(float(FrameNumber),float(AreaSizeList),false);
  saveFrame("Pic/AreaSizeList.png");
  drawCoordinate(float(FrameNumber),float(TotalEList),false);
  saveFrame("Pic/TotalEList.png");
  drawCoordinate(float(FrameNumber),float(ManListLenthList),false);
  saveFrame("Pic/ManListLenthList.png");
  int[] RCount=new int[InsideRPointCount.length];
  for(int i=1;i<RCount.length;i++)
  {
    RCount[i]=i;
  }
  drawCoordinate(float(RCount),float(InsideRPointCount),false);
  saveFrame("Pic/InsideRPointCount.png");
  
  float[] LogManCount=new float[ManListLenthList.length];
  for(int i=0;i<LogManCount.length;i++)
  {
    if(ManListLenthList[i]!=0 &&FrameNumber[i]>1)
    {
      LogManCount[i]=(log(ManListLenthList[i])/log(FrameNumber[i]));
    }
    else
    {
      LogManCount[i]=0;
    }
  }
  
  float[] LogAreaSize=new float[AreaSizeList.length];
  for(int i=0;i<LogAreaSize.length;i++)
  {
    if(AreaSizeList[i]!=0 &&FrameNumber[i]>1)
    {
      LogAreaSize[i]=(log(AreaSizeList[i])/log(FrameNumber[i]));
    }
    else
    {
      LogAreaSize[i]=0;
    }    
  }
  
  float[] LogTotalE=new float[TotalEList.length];
  for(int i=0;i<LogAreaSize.length;i++)
  {
    if(TotalEList[i]!=0 &&FrameNumber[i]>1)
    {
      LogTotalE[i]=(log(TotalEList[i])/log(FrameNumber[i]));
    }
    else
    {
      LogTotalE[i]=0;
    } 
    
  }
  saveStrings("DataExport/LogManCount.txt", str(LogManCount));  
  saveStrings("DataExport/LogTotalE.txt", str(LogTotalE));  
  saveStrings("DataExport/LogAreaSize.txt", str(LogAreaSize));  
  
  drawCoordinate(LogManCount,LogAreaSize,true);
  saveFrame("Pic/LogAreaSize.png");
  
  drawCoordinate(LogManCount,LogTotalE,true);
  saveFrame("Pic/LogTotalE.png");
  
}


void drawCoordinate(float[] XCount,float[] YCount,Boolean IntOrFloat)
{
  background(250);
  stroke(126);
  float MaxXCount=max(XCount);
  float MaxYCount=max(YCount);
  float MinXCount=min(XCount);
  float MinYCount=min(YCount);
  fill(250,0,0);
  for(int x=width/20;x<width;x+=width/20)
  {
    line(x,height,x,height-lineLength);
    if(IntOrFloat)
    {
      text((MinXCount+(x/(width/20))*(MaxXCount-MinXCount)/20),x,width);
    }
    else
    {
      text(int(MinXCount+(x/(width/20))*(MaxXCount-MinXCount)/20),x,width);
    }
  }
  for(int y=height/20;y<height;y+=height/20)
  {
    line(0,y,lineLength,y);
    if(IntOrFloat)
    {
      text((MinYCount+(y/(width/20))*(MaxYCount-MinYCount)/20),0,height-y);
    }
    else
    {
      text(int(MinYCount+(y/(width/20))*(MaxYCount-MinYCount)/20),0,height-y);
    }
    
  }
  stroke(255);
  loadPixels();
  int TrueXCount=0;
  int TrueYCount=0;
  
  for(int i=0;i<XCount.length;i++)
  {
    TrueXCount=int(map(XCount[i],MinXCount,MaxXCount,0,width-1));
    TrueYCount=int(map(YCount[i],MinYCount,MaxYCount,0,height-1));
    pixels[TrueXCount*width+height-TrueYCount]=color(0);
  }
  updatePixels();
}