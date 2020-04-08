public class PitchHandler extends Chugen
{
    float targetFreq[1];
    IOU.ZeroFreq => targetFreq[0];
    
    string mode;
    
    IOU.ZeroFreq => float memory0;
    IOU.ZeroFreq => float memory1;
    
    IOU.ZeroFreq => float currentFreq;
    
    float cRate[1];
    0 => cRate[0];

    2 => float harmonicFactor;
    
    fun void computecRate(dur targetTime){
        1. / 1200. => float centRatio; //Target difference
        targetTime / samp => float n;

        if(mode == "superExp" || mode == "superExpHarmonic")
            if(currentFreq == targetFreq[0])
                0 => cRate[0];
            else
                Math.pow(Std.fabs(Math.log(1 - centRatio) / Math.log(currentFreq/targetFreq[0])), 1/(n+1)) => cRate[0];
        if(mode == "realExp" || mode == "exp" || mode == "realExpHarmonic")
            if(n == 0)
                0 => cRate[0]; //cRate = tau in samp
            else
                1 - 1 / n => cRate[0];
    }
        
    fun void setMode(string m){
        m => mode;
    }
        
    fun void changeFreq(float f, dur targetTime){
        memory0 => memory1;
        currentFreq => memory0;
        f => targetFreq[0];
        computecRate(targetTime);
    }
       
    fun float tick(float in){
        tickMode() => currentFreq;
        return currentFreq;
    }
    
    fun float tickMode(){
        if(mode == "superExp")
            return tickModeSuperExp();
        if(mode == "realExp" || mode == "exp")
            return tickModeRealExp();
        if(mode == "log")
            return tickModeLog();
        if(mode == "superExpHarmonic")
            return tickModeSuperExpHarmonic();
        if(mode == "realExpHarmonic")
            return tickModeRealExpHarmonic();
        else
            return tickModeDefault();
    }
    
    fun float tickModeDefault(){
        return targetFreq[0];
    }
    
    fun float tickModeSuperExp(){
        return Math.pow(currentFreq, cRate[0])*Math.pow(targetFreq[0],1-cRate[0]);
    }
    
    fun float tickModeRealExp(){
        return currentFreq*cRate[0] + targetFreq[0]*(1-cRate[0]);
    }
    
    //Add influence of current/memory?
    fun float tickModeRealExpHarmonic(){
        float targetRatio;
        if(currentFreq >= targetFreq[0])
            currentFreq / targetFreq[0] => targetRatio;
        else
            targetFreq[0] / currentFreq => targetRatio;
        Math.floor(targetRatio) => float targetRatioFloor;
        
        cRate[0]*Math.pow(harmonicFactor*(1 + 1/targetRatio), 4*(targetRatio - Math.round(targetRatioFloor)) - 1) => float cRateNew;
        return currentFreq*cRateNew + targetFreq[0]*(1-cRateNew);
    }
    fun float tickModeSuperExpHarmonic(){
        float targetRatio;
        if(currentFreq >= targetFreq[0])
            currentFreq / targetFreq[0] => targetRatio;
        else
            targetFreq[0] / currentFreq => targetRatio;
        Math.floor(targetRatio) => float targetRatioFloor;
        
        cRate[0]*Math.pow(harmonicFactor*(1 + 1/targetRatio), 4*(targetRatio - Math.round(targetRatioFloor)) - 1) => float cRateNew;
        return Math.pow(currentFreq, cRateNew)*Math.pow(targetFreq[0],1-cRateNew);
    }
    
    //TBC
    fun float tickModeLog(){
        return 0.;
    }
    
    fun static Interpolator MakePitchInterpol(int channel){
		PitchHandler pHl;
		pHl.setMode("superExp");
		
		PitchHandler pHr;
		pHr.setMode("realExp");
		
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
