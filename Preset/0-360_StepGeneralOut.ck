public class StepGeneralOut extends GeneralOut{
	
    StepOut gen;
    BeatPlayer @ bpTrig;
	
	fun void setGeneral(){
		gen @=> general;
		"Step" => type;
	}
    
    fun void _playTrigOnBeatPlayer(BeatPlayer bP){
        bP @=> bpTrig;
        "StepTrig" => type;
        gen._playTrigOnEvent(bP.beat);
    }

    fun void setPlaying(int i){
        i => gen.playing;
    }
    
    fun void _fadeTrig(StepGeneralOut go){
        
        //... do nothing, bpTrig should be fading
        <<<"start _fadeTrig">>>;
        bpTrig.done => now;<<<"bpTrig.done">>>;
        gGesture.setVal(0);
		go.gGesture.setVal(1);
		0 => active;
		1 => go.active;
        0 => gen.playing;
        0 => bpTrig.playing;
        dinit();
        done.broadcast();
    }
}