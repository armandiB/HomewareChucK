public class BeatPlayer{
    Event beat;
    1 => int playing;
    0 => int toReset;
    0 => int hardSync;
    Event reset;
    dur beatTime;
    1 => float barSig;
    1 => float multSig;
    Event done;
    
    fun void setBeatTime(dur t){
        t => beatTime;
    }
    
    fun void _playClock(){
        while(playing){
            if(toReset){
                reset => now;
                if(!hardSync)
                    0 => toReset;
            }
            beat.broadcast();
            beatTime*multSig => now;        
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
        beat => now;
        done.broadcast();
    }
    
    
}