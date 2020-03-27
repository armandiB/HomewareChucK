public class Xenakeur extends Chubgraph{
    inlet => LiSa buffer => outlet;
    
    dur totalDur;
    time startRec;
    int orderVoices[];
    0 => int voicesCount;
    
    fun void init(dur TotalDur){
        TotalDur => totalDur;
        totalDur => buffer.duration;
        50 => buffer.maxVoices;
        0 => buffer.loop;
        int dummy[buffer.maxVoices()] @=> orderVoices;
        5::ms => buffer.recRamp;
    }
    
    fun void rec(){
        1 => buffer.record;
        now => startRec;
        totalDur => now;
        0 => buffer.record;
    }
    
    fun void clear(){
        buffer.clear();
    }
    
    fun void play(float k, dur tau, int voice){
        if(tau < 0::samp)
            <<<"tau < 0!">>>;
        
        voice => int realVoice;
        
        if(voice < 0){
            <<<"voice < 0!">>>;
            Argmin(orderVoices) => realVoice;
        }
        
        buffer.rate(realVoice, k);
        
        Math.max(0, 1 - 1/k) * totalDur => dur minWait;
        Math.max(0, (tau + minWait - (now - startRec)) / 1::samp) => float waitSamp;
        Math.ceil(waitSamp)::samp => now;
        
        buffer.playPos(realVoice, 0::samp);
        buffer.play(realVoice, 1);
        voicesCount++;
        voicesCount => orderVoices[realVoice];
    }
    fun void play(FloatDur res, int voice){
        play(res.k, res.tau, voice);}
    fun void play(FloatDur res){
        <<<"1", buffer.getVoice()>>>;
        <<<"2", buffer.getVoice()>>>;
        play(res.k, res.tau, buffer.getVoice());}
    
    fun FloatDur getParams(dur timeToOriginalTouch, dur timeToNewTouch, float yShiftOFTouchInOctaves, float originalDerivative, float newDerivative, dur timeUnitDerivatives){
        float k;
        dur tau;
        
        newDerivative => float pNewDerivative;
        if(newDerivative == 0){
            <<<"New derivative is 0! Using 10e-10.">>>;
            0.0000000001 => pNewDerivative;
        }
        
        if(originalDerivative == 0.){
            <<<"Original derivative is 0! Returning k=1.">>>;
            1 => k;
        }
        else
            pNewDerivative / originalDerivative => k;
                
        timeToNewTouch - (k-1)*totalDur/k + timeToOriginalTouch/k + (Math.log2(k) - yShiftOFTouchInOctaves)/newDerivative * timeUnitDerivatives => tau;
        
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

