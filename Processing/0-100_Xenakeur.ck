public class Xenakeur extends Chubgraph{
    inlet => LiSa buffer => outlet;
    
    dur totalDur;
    time startRec;
    int orderVoices[];
    0 => int voicesCount;
    
    1::second => dur timeUnitDerivatives;

    fun void init(dur TotalDur, int nbVoices){
        TotalDur => totalDur;
        totalDur => buffer.duration;
        nbVoices => buffer.maxVoices;
        
        int dummy[buffer.maxVoices()] @=> orderVoices;
        5::ms => buffer.recRamp;
    }
    fun void init(dur TotalDur){
        init(TotalDur, 50);}
    
    fun void _rec(){
        1 => buffer.record;
        now => startRec;
        totalDur => now;
        0 => buffer.record;
    }
    fun void _autorec(float gain){
        outlet => Gain g => buffer;
        g.gain(gain);
        _rec();
        g =< buffer;
        outlet =< g;
    }
    
    fun void clear(){
        buffer.clear();
    }
    
    fun float computeWaitSamp(FloatDur fd){
        return computeWaitSamp(fd.k, fd.tau);
    }
    fun float computeWaitSamp(float k, dur tau){
        if(tau < 0::samp)
            <<<"tau < 0!">>>;
        
        Math.max(0, 1 - 1/k) * totalDur => dur minWait;
        Math.max(0, (tau + minWait) / 1::samp) => float waitSamp;
        Math.ceil(waitSamp) => waitSamp;
        return waitSamp;
    }
    
    fun void _play(float k, float waitSamp, int voice){
        waitSamp::samp => now;
        voice => int realVoice;
        if(voice == -2){
            buffer.getVoice() => realVoice;
        }
            
        if(realVoice < 0){
            <<<"voice < 0!">>>;
            Argmin(orderVoices) => realVoice;
        }
        
        buffer.rate(realVoice, k);
        <<<realVoice, k>>>;
        buffer.loop(realVoice, 0);
        if(k >= 0)
            buffer.playPos(realVoice, 0::samp);
        else
            buffer.playPos(realVoice, totalDur - samp);
        
        buffer.play(realVoice, 1);
        voicesCount++;
        voicesCount => orderVoices[realVoice];
    }
    fun void _play(float k, float waitSamp){
        _play(k, waitSamp, -2);}
    
    //durs supposed to be compared to onset of recording (timeToOriginalTouch for time-shifted curve such as recording touches)
    fun FloatDur getParams(dur timeToOriginalTouch, dur timeToNewTouch, float yShiftOfTouchInOctaves, float originalDerivative, float newDerivative){
        float k;
        dur tau;
        
        newDerivative => float pNewDerivative;
        if(newDerivative == 0){
            <<<"New derivative is 0! Using 10e-10.">>>;
            0.0000000001 => pNewDerivative; //Have another mode when k small, based on absolute pitch (y) value
        }
        
        if(originalDerivative == 0.){
            <<<"Original derivative is 0! Returning k=1.">>>;
            1 => k;
        }
        else
            pNewDerivative / originalDerivative => k;
                
        timeToNewTouch - (k-1)*totalDur/k - timeToOriginalTouch/k + (Math.log2(Std.fabs(k)) - yShiftOfTouchInOctaves)/newDerivative * timeUnitDerivatives => tau;
        
        if(tau < 0::samp)
            <<<"Computed negative tau.">>>;
        
        FloatDur res;
        k => res.k; 
        tau => res.tau;
        return res;
    }
    
    //Symetric structure with .bi
    //Loop mode
    //Overdubbing effect with .loopRec and .feedback
    //Phase mod with .sync
    
    fun static int Argmin(int arr[]){
        0 => int pos;
        arr[0] => int acc;
        for(1 => int i; i < arr.cap(); i++)
            if(arr[i] < acc){
                i => pos;
                arr[i] => acc;
            }
        return pos;
    }
}

