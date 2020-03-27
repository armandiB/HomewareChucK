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
        new GainGesture[size] @=> gOuts;
        for(0=> int i; i< size; i++){
            gOuts[i].multMode();
            inlet => gFreqs[i] => oscs[i] => gOuts[i] => outlet;
        }
    }
    
    fun void setFreqs(float freqs[]){
        for(0=> int i; i< size; i++)
            gFreqs.setVal(freqs[i]*refFreq);       
    }
    
    fun void setGains(float gains[]){
        for(0=> int i; i< size; i++)
            gGains.setVal(gains[i]*refGain);      
    }
    
    //fade freqs, gains
}