public class PitchHandlerGeneralOut extends GeneralOut{
	
	PitchHandlerOut gen;
	
	fun void setGeneral(){
		gen @=> general;
		"PitchHandler" => type;
	}
	
	fun void setFreq(float f){
		gen.setFreq(f);
	}
	fun void setFreq(float f, dur carTime){
		gen.setFreq(f, carTime);
	}

	fun void setMode(string md){
		gen.setMode(md);
	}
	
	fun void _fade(PitchHandlerGeneralOut go, dur carDur){

		spork~ gen._fade(go.gen, carDur*3/4);     
        carDur*3/4 => now; 

		gGesture.link2plexlin(go.gGesture);
		spork~ go.gGesture._fade(1, carDur/4);
		0 => active;
		1 => go.active;
		gGesture.done => now;

		dinit();
        done.broadcast();	
	}
	
}