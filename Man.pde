class Man
{
  PVector Local;
  int BrithFrame;
  color FillColor;
  ArrayList<PVector> E = new ArrayList<PVector>();

  Man ManBirth(PVector Local,int BrithFrame,color FillColor)
  {
    Man NewMan=new Man();
    NewMan.Local=Local;
    NewMan.BrithFrame=BrithFrame;
    NewMan.FillColor=FillColor;
    return NewMan;
  }
}