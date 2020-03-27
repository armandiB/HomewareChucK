public class StepGeneralOut extends GeneralOut{
	
    StepOut gen;
    BeatPlayer @ bpTrig;
	
	fun void setGeneral(){
		gen @=> general;
		"Step" => type;
	}
    
    fun void playTrigOnBeatPlayer(BeatPlayer bP){
        bP @=> bpTrig;
        gen.playTrigOnEvent(bP.beat);
        "StepTrig" => type;
    }
    
    fun void _fadeTrig(StepGeneralOut go){
        
        //... do nothing, bpTrig should be fading
        
        bpTrig.done => now;
        spork~ gGesture.fade(0, 0::samp);
		spork~ go.gGesture.fade(1, 0::samp);
		0 => active;
		1 => go.active;
		gGesture.done => now;
        done.broadcast();
		dinit();
    }
}