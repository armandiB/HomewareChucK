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
	
	fun void _fade(PitchHandlerGeneralOut go, dur carDur){
        //same as SinGeneralOut
		if(!go.active)
			go.dinit();
		
		gen._fade(go.gen, carDur);
        
        carDur => now; //Temporary, would need a done for PitchHandler
        done.broadcast();
	}
	
}