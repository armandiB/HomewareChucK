public class OdeCV extends Chugen{
    
    1::samp => dur stepSize;
    1::second => dur unitTime;
    stepSize / unitTime => float unitStep;
    
    0 => int nbWait;
    OdeFunction f;
    
    int size;
    Step outs[];
    float lastValues[];
    
    Event done;
    
    fun void init(int siz){
        siz => size;
        new Step[siz] @=> outs;
        new float[siz] @=> lastValues;
        new float[siz] @=> f.lastValues;
        this => blackhole;
    }
    
    fun void dinit(){
        this =< blackhole;
        done.broadcast();
    }
    
    fun void setLastValues(float vals[]){
        for(0 => int i; i < vals.cap(); i++)
            vals[i] => lastValues[i];
    }
    
    fun void setStepSize(dur val){
        val => stepSize;
        stepSize / unitTime => unitStep;
    }
    
    fun void setMode(string mode){
        mode => f.mode;
    }
    
    fun void setParams(float params[]){
        params @=> f.params;
    }
    
    fun float tick(float in){
        if(nbWait){
            nbWait--;
            return 0.1;
        }
        in::samp => dur t; //in is in nb of samp (chuck now/(1::samp) for classic behavior)
        
        RungeKutta4(t);          
        
        Math.round(stepSize/samp - 1) $ int => nbWait;
        return 0.0;
    }
    
    fun void RungeKutta4(dur t){
        f.f(t, lastValues);
        float k1[size];
        MultAndAssign(unitStep, f.lastValues, k1);
        
        f.f(t + stepSize/2, lastValues, k1, 0.5);
        float k2[size];
        MultAndAssign(unitStep, f.lastValues, k2);
        
        f.f(t + stepSize/2, lastValues, k2, 0.5);
        float k3[size];
        MultAndAssign(unitStep, f.lastValues, k3);
        
        f.f(t + stepSize, lastValues, k3);
        float k4[size];
        MultAndAssign(unitStep, f.lastValues, k4);
        
        for(0 => int i; i < size; i++){
            lastValues[i] + (k1[i] + 2*k2[i] + 2*k3[i] + k4[i])/6 => lastValues[i];
            lastValues[i] => outs[i].next;
        }
    }  
    fun static void MultAndAssign(float constant, float in[], float out[]){
        for(0 => int i; i < in.cap(); i++)
            constant*in[i] => out[i];
    }
    
    fun void _fadeTo(OdeCV to, dur carDur){
        to.f @=> f.next;
        GainGesture gNext @=> f.weightNext;
        f.weightNext.zeroAdd();
        f.weightNext => blackhole;
        f.weightNext._fade(1, carDur);
        f.weightNext =< blackhole;
    }
}

//f in dy/dt = f(t, y), in unitTime^-1
class OdeFunction{  
    "constant" => string mode;
    float params[];
    float lastValues[];
    
    OdeFunction @ next; //For interpolating
    GainGesture @ weightNext; 
    
    fun void f(dur t, float y[]){
        if(next != null && weightNext.last() == 1)
            return interpolate(t, y);
        
        if(mode == "constant"){
            for(0 => int i; i < lastValues.cap(); i++)
                0 => lastValues[i];
        }
        if(mode == "lorenz")
            fLorenz(t, y);
        
        if(next != null)
            interpolate(t, y);
    }
    fun void interpolate(dur t, float y[]){
            weightNext.last() => float wNext;
            if(wNext != 0){
                next.f(t, y);
                for(0 => int i; i < next.lastValues.cap(); i++)
                    (1-wNext)*lastValues[i] + wNext*next.lastValues[i] => lastValues[i];
            }
    }
    fun void f(dur t, float y[], float toAdd[], float factor){
        float newY[y.cap()];
        for(0 => int i; i < y.cap(); i++)
            y[i] + toAdd[i]*factor => newY[i];
        f(t, newY);
    }
    fun void f(dur t, float y[], float toAdd[]){
        float newY[y.cap()];
        for(0 => int i; i < y.cap(); i++)
            y[i] + toAdd[i] => newY[i];
        f(t, newY);
    }
    
    fun void fLorenz(dur t, float y[]){
        vec3 y3; y[0] => y3.x; y[1] => y3.y; y[2] => y3.z;
        Chaos.LorenzFunction(y3, params[0], params[1], params[2]) => vec3 out;
        out.x => lastValues[0];
        out.y => lastValues[1];
        out.z => lastValues[2];
    }
}