public class PitchHandler extends Chugen
{
    IOU.ZeroFreq/2. => float targetFreq;
    
    string mode;
    
    IOU.ZeroFreq/2. => float memory0;
    IOU.ZeroFreq/2. => float memory1;
    
    IOU.ZeroFreq/2. => float currentFreq;
    
    0 => float cRate;
    
    fun void computecRate(dur targetTime){
        1. / 1200. => float centRatio; //Target difference
        targetTime / samp => float n;

        if(mode == "exp")
            if(currentFreq == targetFreq)
                0 => cRate;
            else
                Math.pow(Std.fabs(Math.log(1 - centRatio) / Math.log(currentFreq/targetFreq)), 1/(n+1)) => cRate;
    }
        
    fun void setMode(string m){
    m => mode;
    }
        
    fun void changeFreq(float f, dur targetTime){
        memory0 => memory1;
        currentFreq => memory0;
        f => targetFreq;
        computecRate(targetTime);
    }
       
    fun float tick(float in){
        tickMode() => currentFreq;
        return currentFreq;
    }
    
    fun float tickMode(){
        if(mode == "exp")
            return tickModeExp();
        if(mode == "log")
            return tickModeLog();
        else
            return tickModeDefault();
    }
    
    fun float tickModeDefault(){
        return targetFreq;
    }
    
    fun float tickModeExp(){
        return Math.pow(currentFreq, cRate)*Math.pow(targetFreq,1-cRate);
    }
    
    //TBC
    fun float tickModeLog(){
        return 0.;
    }
    fun static Interpolator MakePitchInterpol(int channel){
		PitchHandler pHl;
		pHl.setMode("exp");
		
		PitchHandler pHr;
		pHr.setMode("exp");
		
		Interpolator interpH; 
		interpH.setMode("lin");
		interpH.setParam(0.5);
		interpH.setTicks(pHl, pHr);
		
		pHl => blackhole;
		pHr => blackhole;
        
        if(channel >= 0){
		interpH => OutGen outGen => MBus.PChan0[channel];
		outGen.setMode("freq");
		}
            
		return interpH;
	}
	fun static Interpolator MakePitchInterpol(){
		MakePitchInterpol(-1);
	}
}
