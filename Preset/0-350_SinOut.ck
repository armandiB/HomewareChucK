public class SinOut extends Chubgraph{
	
	GainGesture freqCtrl;
	freqCtrl.addMode();
	inlet => freqCtrl => SinOsc gen => outlet;
	
	fun void setFreq(float f){
		freqCtrl.setVal(f);	
	}
	
	fun void _fade(SinOut g, dur carDur){
		freqCtrl.fade(g.freqCtrl.getVal(), carDur);
	}
}