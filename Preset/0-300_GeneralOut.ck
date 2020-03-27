public class GeneralOut extends Chubgraph{
	
	Chubgraph general;
	GainGesture gGesture;
	string type;
	
	int side;
	int channel;
	int active;
    Event done;
	
	fun void init(int sid, int chan){
		sid => side;
		chan => channel;
		
		setGeneral();
		inlet => general => gGesture => outlet;
		
		gGesture.zeroMult();
		if(side == 0)
			this => MBus.PChan0[channel];
		if(side == 1)
			this => MBus.PChan1[channel];
		if(side == 2)
			this => MBus.PChan2[channel];
	}
	fun void initGain(int sid, int chan){
		sid => side;
		chan => channel;
		
		setGainGeneral();
		inlet => general => gGesture => outlet;
		
		gGesture.zeroMult();
		if(side == 0)
			this => MBus.PChan0[channel];
		if(side == 1)
			this => MBus.PChan1[channel];
		if(side == 2)
			this => MBus.PChan2[channel];
	}

	
	fun void dinit(){
		if(side == 0)
			this =< MBus.PChan0[channel];
		if(side == 1)
			this =< MBus.PChan1[channel];
		if(side == 2)
			this =< MBus.PChan2[channel];
		0 => active;
	}
	
	fun void _fadeIn(dur carDur){
		gGesture.fade(1, carDur);
	}
	
	fun void _fadeOut(dur carDur){
		gGesture.fade(0, carDur);
	}
	
	fun pure void setGeneral();
	
	fun void setGainGeneral(){
		GainOut g @=> general;
		"Gain" => type;
	}
	
	fun void _fade(GeneralOut go, dur carDur){
		spork~ gGesture.fade(0, carDur);
		spork~ go.gGesture.fade(1, carDur);
		0 => active;
		1 => go.active;
		gGesture.done => now;
        done.broadcast();
		dinit();
	}
}