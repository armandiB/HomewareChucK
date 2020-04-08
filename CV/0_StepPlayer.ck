public class StepPlayer{
    Step step;
    1 => int playing;
    0 => step.next;
    
    fun void setNext(float val){
        val => step.next;
    }
    
    fun float getNext(){
        return step.next();
    }
    
    fun void playConst(){
        while( playing ) 1::second => now;
    }
    
    fun void playTrig(){
        if(playing){
            setNext(0.8);
            5::ms => now;
            setNext(0);
        }
    }
    
    fun void playClock(dur timeStep){
        while(playing){
            spork ~ playTrig();
            timeStep => now;
        }
    }
    
    fun void playTrigOnEvent(Event e){
        while(playing){
            e => now;
            spork ~ playTrig();
        }
    }

    fun void playTrigOnOneEvent(Event e){
        e => now;
        spork ~ playTrig();
    }
    
    fun float stop(){
        step.next() => float res;
        setNext(0);
        0 => playing;
        return res;
    }
}