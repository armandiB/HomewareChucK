public class GainGesture extends Chubgraph{
	
	inlet => Gain g => outlet;
	Step stepAdd => Gain gAdd => g;	
	Step stepMult => Gain gMult => gAdd;
	gMult.op(3);
	1 => stepAdd.next;
	0 => stepMult.next;
	
	1 => float refVal;
	Event done;
    
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
	fun void fade(float end, dur carDur){
		fade(end, carDur, "lin");
	}
	fun void fade(float end, dur carDur, string mode){		
		refVal => float temp0;
        end - temp0 => stepMult.next;
		
		if(mode == "lin")
			fadeLinAux(carDur);
		else
			fadeLinAux(carDur);
		
		setVal(end);
        done.broadcast();
	}
	fun void fadeLinAux(dur carDur){
		Step s => Envelope e => gMult;
		carDur => e.duration;
		e.keyOn();
		carDur => now;
	}
		
	fun void link2plex(GainGesture gainG){
		1 => stepAdd.next;
		-1 => stepMult.next;
		1 - gainG.refVal => refVal;
		gainG.gAdd => gMult;
	}
}