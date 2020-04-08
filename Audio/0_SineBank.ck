public class SineBank extends Chubgraph{
    20 => int size;
    SinOsc oscs[];
    GainGesture gFreqs[];
    GainGesture gGains[];
    1 => float refFreq;
    0.5 => float refGain;
    
    fun void init(int siz){
        siz => size;
        new SinOsc[size] @=> oscs;
        new GainGesture[size] @=> gFreqs;
        new GainGesture[size] @=> gGains;
        for(0=> int i; i< size; i++){
            gGains[i].multMode();
            oscs[i].freq(0);
            gFreqs[i].cvMode(); //could have a mode with chucked input where they are in multMode to change input freq by a certain amount of notes
            gGains[i].setVal(0);
            gFreqs[i] => oscs[i] => gGains[i] => outlet;
        }
        inlet => gFreqs;
    }
   
    fun void dinit(int chan){
      gGains[chan] =< outlet;
    }

    fun void setFreqs(float freqs[]){
        for(0=> int i; i< size; i++)
            gFreqs[i].setVal(freqs[i]*refFreq);       
    }
    
    fun void setGains(float gn){
        for(0=> int i; i< size; i++)
            gGains[i].setVal(refGain*gn);
    }
    fun void setGains(int chan, float gn){
        gGains[chan].setVal(refGain*gn);
    }
    fun void setGains(float gains[]){
        for(0=> int i; i< size; i++)
            gGains[i].setVal(gains[i]*refGain);      
    }
    
    fun void printFreqs(){
        for(0=> int i; i< size; i++)
            <<<oscs[i].freq()>>>;  
    }

    //fade freqs, gains
}
