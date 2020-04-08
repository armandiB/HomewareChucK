public class BeatPlayer{
    Event beat;
    1 => int playing;
    0 => int toReset;
    0 => int hardSync;
    Event reset;
    1::second => dur beatTime;
    1 => float barSig;
    1 => float multSig;
    Event done;
    
    dur accError;
    0 => float jitterFactor;
    time lastBeat;
    
    fun void setBeatTime(dur t){
        t => beatTime;
    }

    fun void setBeatTime24(dur t){
        t/24 => beatTime;
    }
    
    fun void _playClock(){
        float rand;
        float jit;
        dur jitStep;
        while(playing){
            if(toReset){
                reset => now;
                if(!hardSync)
                    0 => toReset;
            }
            beat.broadcast(); now => lastBeat;
            
            beatTime*multSig => jitStep;
            if(jitterFactor != 0){
                accError/(beatTime*multSig) => float relError;
                Math.random2f(-1, 1)*jitterFactor + 0.05*relError => rand;
                Math.exp((rand - relError)*Math.fabs(rand)*0.5-Math.log(jitterFactor)*relError) => jit;
                (jit-1)*jitStep +=> accError;
                jit *=> jitStep;
            }
            jitStep => now;   
        }
    }
    
    fun void setReset(Event r){
        r @=> reset;
        1 => toReset;
    }

    fun void _fade(BeatPlayer bp, dur carDur){
        _fade(bp, carDur, 1);
    }
    fun void _fade(BeatPlayer bp, dur carDur, int adjustC){
        _fadeLin(bp, carDur, adjustC);
    }
    fun void _fadeLin(BeatPlayer bp, dur carDur, int adjustC){
        dur c;
        int N;
        carDur - beatTime*multSig => dur realCarDur; //Assuming fade launched right after beat
        (beatTime*multSig + bp.beatTime*bp.multSig)/2 => dur mean;
        bp.beatTime*bp.multSig - beatTime*multSig => dur diff;
        
        if(adjustC == 1){
            1 + (Math.floor(realCarDur/mean) $ int) => N;
            2*(carDur - (N-1)*beatTime*multSig)/N/(N-1) => c;
        }
        else if(adjustC == -1){
            1 + (Math.ceil(realCarDur/mean) $ int) => N;
            2*(carDur - (N-1)*beatTime*multSig)/N/(N-1) => c;
        }
        else{
            1 + (Math.floor(realCarDur/mean) $ int) => N;
            diff / N => c;
        }
        
        for(1 => int i; i < N; i++){
            c/multSig +=> beatTime;
            beat => now;
        }
        bp.beatTime => beatTime;
        bp.multSig => multSig;
        setReset(bp.beat);
        me.yield();
        beat => now;
        beat => now;
        done.broadcast();
    }
    
    fun void _fadeFollow(BeatPlayer bp, float factor){
        time bp0;
        time bp1;
        float timeRatio;
        float phaseRatio;
        bp.beat => now; now => bp0;
        bp.beat => now; now => bp1;
        (bp1 - bp0)/(beatTime*multSig) => timeRatio;
        (bp0 - lastBeat)/(beatTime*multSig) => float bp0Phase;
        (bp1 - lastBeat)/(beatTime*multSig) => float bp1Phase;
        if(Math.fabs(bp0Phase) > Math.fabs(bp1Phase))
            bp1Phase => phaseRatio;
        else
            bp0Phase => phaseRatio;
        while(Math.fabs(timeRatio) > 0.01 && Math.fabs(phaseRatio) < 0.01){
            bp.beat => now;
            bp0 => bp1;
            now => bp0;
            (bp1 - bp0)/(beatTime*multSig) => timeRatio;
            (bp0 - lastBeat)/(beatTime*multSig) => float bp0Phase;
            (bp1 - lastBeat)/(beatTime*multSig) => float bp1Phase;
            if(Math.fabs(bp0Phase) > Math.fabs(bp1Phase))
                bp1Phase => phaseRatio;
            else
                bp0Phase => phaseRatio;
             
            beatTime*(timeRatio + phaseRatio*0.2)*factor +=> beatTime;
        }
        bp.beatTime => beatTime;
        bp.multSig => multSig;
        setReset(bp.beat);
        me.yield();
        beat => now;
        done.broadcast();
    }
    
}