public class Preset{
	
	GeneralOut go[];
	SPBundle sp;
	IntArrayList spOutChans;
	Spatializer sz; 
	IntArrayList szOutChans;
	
	-1 => int size;
	int side;
	
    BeatPlayer bp;
	float bpm;
    Event done;
    
	fun void init(){
		init(side);
	}
	fun void init(int sid){
		if(size == -1)
			init(CIO.OutSize, sid);
		else
			init(size, sid);
	}
	fun void init(int siz, int sid){
		sid => side;
		siz => size;
		new GeneralOut[size] @=> go;
	}
	
	fun void init2(int inSzSize, IntArrayList outSzChans, IntArrayList spChans){
		initSz(inSzSize, outSzChans);
		initSp(spChans);
		initGo();
	}
	fun void initSz(int inSize, IntArrayList outChans){
		outChans @=> szOutChans;
		sz.init(inSize, outChans.size());
		if(outChans.size() == 2)
			sz.set2plex();
		
		for(0 => int i; i < outChans.size() ; i++){
			GeneralOut gainG;
			gainG.initGain(side, outChans.get(i));
			gainG @=> go[outChans.get(i)];
			sz.out[i] => go[outChans.get(i)];
			1 => go[outChans.get(i)].active;
		}

	}
	fun void initGo(){	
		for(0 => int i; i < size; i++)
			if(go[i].type != "Gain"){
				go[i].init(side, i);
				1 => go[i].active;
			}
	}	
	fun void initSp(IntArrayList chans){
		chans @=> spOutChans;
		sp.fillPlayers(chans.size());
        sp.setBeat();
		chans @=> sp.channels;
		for(0 => int i; i < chans.size() ; i++){
			GeneralOut gainG;
			gainG.initGain(side, chans.get(i));
			gainG @=> go[chans.get(i)];
			sp.players.get(i) => go[chans.get(i)];
			1 => go[chans.get(i)].active;
		}
	}
	
	fun pure void launch();
	fun pure void prepare();
	
	fun void activate(){
		for(0 => int i; i < size; i++)
			1 => go[i].active;
	}
	
	fun void fadeIn(dur carDur){
		for(0 => int i; i < size; i++)
			spork~ go[i]._fadeIn(carDur);
		
		2*carDur => now;
	}
	fun void fadeOut(dur carDur){
		for(0 => int i; i < size; i++)
			spork~ go[i]._fadeOut(carDur);
		
		2*carDur => now;
        done.broadcast(); <<<"fadeOut done.">>>;
	}
	
    fun void fade(Preset p, dur carDur){
        fadeTo(p, carDur);
    }
	fun void fadeTo(Preset p, dur carDur){		
		for(0 => int i; i < size; i++)
			FadeAux(go[i], p.go[i], dur carDur);
		
        spork~ bp._fade(p.bp, carDur);
        
		2*carDur => now;
        done.broadcast(); <<<"fadeTo done.">>>;
	}
    fun void fadeFrom(Preset p, dur carDur){		
		for(0 => int i; i < size; i++)
			FadeAux(p.go[i], go[i], dur carDur);
		
        spork~ p.bp._fade(bp, carDur);
        
		2*carDur => now;
        p.done.broadcast(); <<<"fadeFrom done.">>>;
	}
	fun static void FadeAux(GeneralOut from, GeneralOut to, dur carDur){
		if(from.type == "Sin" && to.type == "Sin"){
			spork~ (from $ SinGeneralOut)._fade(to $ SinGeneralOut, carDur); 
			from @=> to;
			return;
		}
		if(from.type == "PitchHandler" && to.type == "PitchHandler"){
			spork~ (from $ PitchHandlerGeneralOut)._fade(to $ PitchHandlerGeneralOut, carDur); 
			from @=> to;
			return;
		}
        if(from.type == "StepTrig" && to.type == "StepTrig"){
			spork~ (from $ StepGeneralOut)._fadeTrig(to $ StepGeneralOut); 
			return;
		}
		spork~ from._fade(to, carDur);
	}
    
	fun void copyFrom(Preset p){
		p.side => side;
		p.size => size;
		p.go @=> go;
		p.sp @=> sp;
		p.sz @=> sz;
        p.bp @=> bp;
        p.bpm @=> bpm;
	}
	
}