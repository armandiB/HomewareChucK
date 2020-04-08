public class XenakeurConics{
        
	Xenakeur xenakeur;
	dur totalDur;
	1::second => dur timeUnit;

	dur beatTime;
    
    Event done;

	fun void changeTimeUnit(dur tu){
		tu => timeUnit;
		tu => xenakeur.timeUnitDerivatives;
	}

	fun void setBeatTime(dur bt){
		bt => beatTime;
	}

	fun void init(dur totaldur, int nbVoices, dur bt){
		totaldur => totalDur;
		bt => beatTime;
		xenakeur.init(totaldur, nbVoices);
		if(timeUnit != xenakeur.timeUnitDerivatives)
			<<<"timeUnit", timeUnit, "different from xenakeur.timeUnitDerivatives", xenakeur.timeUnitDerivatives>>>;
	}

	fun void _rec(){
		xenakeur._rec();}

    fun void _autorec(float gn){
        xenakeur._autorec(gn);}

	fun void _makeConstantStepParabola(int nbVoices, dur touchStep, dur timeFactor, dur firstPlayFromNow, float apexValRelativeStartRecording, dur originalDerivativeInTimePerOctave){
		(timeUnit/timeFactor)*Std.fabs(timeUnit/timeFactor) => float a;
		totalDur / timeUnit => float totalDurInUnits;
		touchStep / timeUnit => float stepInUnits;
		timeUnit / originalDerivativeInTimePerOctave => float originalDerivative;

		(originalDerivative/(4*totalDurInUnits) + apexValRelativeStartRecording/originalDerivative) * timeUnit => dur timeToOriginalTouch;
		//(now - xenakeur.startRec) + apexTimeFromNow => dur apexTime;
		firstPlayFromNow - (originalDerivative /(4*a))*timeUnit + apexValRelativeStartRecording*originalDerivativeInTimePerOctave => dur apexTime;
		apexTime + (0.5*originalDerivative/a)*timeUnit => dur timeToTouchK1; 

		1 => float maxWaitinSamp;
		for(0 => int i; i < nbVoices; i++){
			timeToTouchK1 + i*touchStep => dur timeToTouch;
			originalDerivative + 2*a*i*stepInUnits => float newDerivative;
			if(timeToTouchK1 < apexTime && timeToTouch >= apexTime)
				<<<"Passed Apex!", i, "at", timeToTouch, newDerivative>>>;
            
            xenakeur.getParams(timeToOriginalTouch, timeToTouch, i*stepInUnits*(a*i*stepInUnits + originalDerivative), originalDerivative, newDerivative) @=> FloatDur params;
            xenakeur.computeWaitSamp(params) => float waitSamp;
			spork~ xenakeur._play(params.k, waitSamp);
            Math.max(waitSamp, maxWaitinSamp) => maxWaitinSamp;
		}
		1.5 * maxWaitinSamp::samp => now;
	}

	fun void _makeConstantKParabola(){

	}
    
    //_makeHarmonicParabola()

	fun void _makeDoubleParabola(float ratioEndStartFreq, int nbVoicesHead, int nbVoicesTail, float stepDilationFactorHead, float aFactor, float relativePosHead, float relativePosTail){

        totalDur / Math.log2(ratioEndStartFreq) => dur originalDerivativeInTimePerOctave; 
        
        spork~ _makeConstantStepParabola(nbVoicesHead, 0.1*beatTime*stepDilationFactorHead*20/nbVoicesHead, aFactor*beatTime, (3.15)*beatTime, relativePosHead, originalDerivativeInTimePerOctave);
        ((3.15)*beatTime + 2*beatTime*stepDilationFactorHead)*0.95 => now;
        
		if(nbVoicesTail > 0){
			if(nbVoicesHead > 0)
        		spork~ _autorec(0.05);
			
			me.yield();
        	spork~ _makeConstantStepParabola(nbVoicesTail, 0.1*beatTime*50/nbVoicesTail, (-5)*beatTime/aFactor, (3.75)*beatTime, relativePosTail, originalDerivativeInTimePerOctave);
		}
        8*totalDur => now;
        done.broadcast();
    }
}
