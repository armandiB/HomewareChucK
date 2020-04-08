public class SinGeneralOut extends GeneralOut{
	
	SinOut gen;
	
	fun void setGeneral(){
		gen @=> general;
		"Sin" => type;
	}
	
	fun void setFreq(float f){
		gen.setFreq(f);
	}
	
	fun void _fade(SinGeneralOut go, dur carDur){
		//To remove?
        if(!go.active)
			go.dinit();
			
		gen._fade(go.gen, carDur);
        
        //match phase with chugen if (a.last - b.last)*(a.next - b.next) <= 0 then init and change (need blackhole), or match phases or something
        
        done.broadcast();
	}
	
}