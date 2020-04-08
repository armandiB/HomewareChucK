public class GainGesture extends Chubgraph{
	
	inlet => Gain g => outlet;
	Step stepAdd => Gain gAdd => g;	
	Step stepMult => Gain gMult => gAdd;
	gMult.op(3);
	1 => stepAdd.next;
	0 => stepMult.next;
	
	1 => float refVal;
	Event done;
	0 => int fading;
    
	fun void multMode(){
		3 => g.op;
	}
	fun void addMode(){
		1 => g.op;
	}
	fun void cvMode(){
		addMode();
		setVal(0);
	}
    fun void gainMode(float gn){
        3 => g.op;
        setVal(gn);
    }
	
	fun void setVal(float f){
		stepAdd.next(f);
		stepMult.next(0);
		f => refVal;
	}
	
	fun float getVal(){
		return refVal;
	}
	
	fun void zeroMult(){
		g.op(3);
		setVal(0);
	}
	fun void zeroAdd(){
		g.op(1);
		g.gain(0);
		setVal(0);
	}
	fun void one(){
		g.gain(1);
		setVal(1);
	}
	
	//To spork
	fun void _fade(float end, dur carDur){
		_fade(end, carDur, "lin");
	}
	fun void _fade(float end, dur carDur, string mode){
		if(fading)
			done => now;
		1 => fading;				
		if(mode == "lin")
			_fadeLinAux(end, carDur);
		else if(mode == "exp")
			_fadeExpAux(end, carDur);
		else
			_fadeLinAux(end, carDur);
		
		setVal(end);
		0 => fading;
        done.broadcast();
	}
	fun void _fadeLinAux(float end, dur carDur){
		end - refVal => stepMult.next;
		Step s => Envelope e => gMult;
		carDur => e.duration;
		0. => e.value;
		e.keyOn();
		carDur => now;
	}
	fun void _fadeExpAux(float end, dur carDur){
		end => stepMult.next;
		0 => stepAdd.next;
		Step s => Envelope e => Gen5 g5 => gMult;
		[refVal/end, 1., 1.] => g5.coefs;
		carDur => e.duration;
		0. => e.value;
		e.keyOn();
		carDur => now;
	}
	
	//Linear link (constant sum=1), other possibilities (power law panning)
	fun void link2plex(GainGesture gainG){
		link2plexlin(gainG);
	}
	fun void link2plexlin(GainGesture gainG){
		1 => stepAdd.next;
		-1 => stepMult.next;
		1 - gainG.refVal => refVal;
		gainG.gAdd => gMult;
	}
}
