public class OutGen extends Chugen
{
    string mode;
    
    fun void setMode(string m){
    m => mode;
    }
    
    fun float tick(float in){
        if(mode == "freq")
            return IOU.FreqToOut(in);
        else
            return in;
    }
  

}