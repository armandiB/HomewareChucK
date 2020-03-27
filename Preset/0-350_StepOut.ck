public class StepOut extends Chubgraph{
	
	inlet => Step gen => outlet;
	gen.next(0);
    1 => int playing;
    
	fun void setNext(float f){
		gen.next(f);	
	}
	
    fun void _playTrig(){
        if(playing){
            gen.next(0.9);
            5::ms => now;
            gen.next(0);
        }
    }
    
    fun void playTrigOnEvent(Event e){
        while(playing){
            e => now;
            spork~ _playTrig();
        }
    }
}