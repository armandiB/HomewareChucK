public class Interpolator extends Chugen
{
    string mode;
    
    Chugen tick0;
    Chugen tick1;
    
    0.5 => float param;
    
    float currentValue;
    
    fun void setMode(string m){
    m => mode;
    }
    
    fun void setParam(float p){
    p => param;
    }
    
    fun void setTicks(Chugen t0, Chugen t1){
        t0 @=> tick0;
        t1 @=> tick1;
    }
    
    fun float tick(float in){
        //simplify In
                
        if(mode == "lin"){
            (1-param)*tick0.last() + param*tick1.last() => currentValue;
        }
        if(mode == "linIn"){
            in => param;
            (1-param)*tick0.last() + param*tick1.last() => currentValue;
        }
        if(mode == "geo"){          
            Math.pow(tick0.last(),1-param)*Math.pow(tick1.last(),param) => currentValue; 
        }      
        if(mode == "geoIn"){           
            in => param;         
            Math.pow(tick0.last(),1-param)*Math.pow(tick1.last(),param) => currentValue;
            
        }
        else
            (tick0.last()+tick1.last())/2. => currentValue;
        
        return currentValue;
    }
  

}