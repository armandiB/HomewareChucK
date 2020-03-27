public class PitchHandlerOut extends Chubgraph{
	
	PitchHandler ph;
	inlet => ph => OutGen outGen => outlet;
	outGen.setMode("freq");
	ph.setMode("exp");
	
	fun void setFreq(float f){
		ph.changeFreq(f, 0::samp);	
	}
	fun void setFreq(float f, dur cTime){
		ph.changeFreq(f, cTime);	
	}
	
	fun void _fade(PitchHandlerOut g, dur carDur){
		ph.changeFreq(g.ph.targetFreq, carDur);
	}
}