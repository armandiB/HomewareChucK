public class Preset{
	
	GeneralOut go[];
	SPBundle sp;
	IntArrayList spOutChans;
	Spatializer sz; 
	IntArrayList szOutChans;
    //OdeCV
	
	-1 => int size;
	int side;
	
    BeatPlayer bp;
	float bpm;
    Event done;
    int active;
    
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
		init2(inSzSize, outSzChans, spChans, new int[0]);}
	fun void init2(int inSzSize, IntArrayList outSzChans, IntArrayList spChans, int ignore[]){
        if(inSzSize > 0 && outSzChans.size() > 0)
            initSz(inSzSize, outSzChans);
        
        if(spChans.size() > 0)
            initSp(spChans);
        
		initGo(ignore);
        1 => active;
	}

	fun void initSz(int inSize, IntArrayList outChans){
		outChans @=> szOutChans;
		sz.init(inSize, outChans.size());
		if(outChans.size() == 2)
			sz.set2plex();
		
		for(0 => int i; i < outChans.size() ; i++){
			go[outChans.get(i)].initGain(side, outChans.get(i));
			sz.out[i] => go[outChans.get(i)];
		}

	}

	fun void initGo(){
		initGo(new int[0]);}
	fun void initGo(int ignore[]){	
		for(0 => int i; i < size; i++)
			if(go[i].type != "Gain" && !Contains(ignore, i)){
				go[i].init(side, i);
			}
	}	

	fun static int Contains(int array[], int el){
		0 => int contains;
		for(0 => int i; i < array.size(); i++)
			if(array[i] == el){
				1 => contains;
				break;
			}
		
		return contains;
	}
    fun static int Contains(IntArrayList list, int el){
        0 => int contains;
        for(0 => int i; i < list.size(); i++)
            if(list.get(i) == el){
                1 => contains;
                break;
            }
            
            return contains;
     }
	
    fun void initGains(int gains[]){
        for(0 => int i; i < gains.size(); i++){
                go[gains[i]].initGain(side, gains[i]);
            }
    }

	fun void initSp(IntArrayList chans){
		chans @=> spOutChans;
		sp.fillPlayers(chans.size());
        sp.setBeat(bp.beat);
		chans @=> sp.channels;
		for(0 => int i; i < chans.size() ; i++){
			GeneralOut gainG;
			gainG.initGain(side, chans.get(i));
			gainG @=> go[chans.get(i)];
			sp.players.get(i) => go[chans.get(i)];
		}
	}

	fun void openClock(){
		openChan(ParamsM.ClockOut);
	}
	fun void openChan(int chan){
		go[chan].gGesture.setVal(1);
	}
	
	fun pure void _launch();
	fun pure void prepare();
    
    fun void _launchTrack(){       
        bp.beat => now;
        
        spork~ sp.play(0);
        spork~ IOU.PlayTrig(ParamsM.RunOut);
        
        sp.done => now;
    }
	
	fun void activate(){
		for(0 => int i; i < size; i++)
			1 => go[i].active;
	}

	fun void deactivate(){
		for(0 => int i; i < size; i++)
			0 => go[i].active;
	}
	
	fun void fadeIn(dur carDur){
		for(0 => int i; i < size; i++)
			spork~ go[i]._fadeIn(carDur);
		
		2*carDur => now;
        done.broadcast();
	}
	fun void fadeOut(dur carDur){
		for(0 => int i; i < size; i++)
			spork~ go[i]._fadeOut(carDur);
		
		2*carDur => now;
        sp.cut(0);
        0 => active;
        done.broadcast(); 
        <<<"fadeOut done.">>>;
	}
	
    fun void fade(Preset p, dur carDur){
        fadeTo(p, carDur);
    }
	fun void fadeTo(Preset p, dur carDur){
		if(bp.playing == 1 || p.bp.playing == 0)	
        	spork~ bp._fade(p.bp, carDur);

        for(0 => int i; i < size; i++)
            FadeAux(go[i], p.go[i], carDur);
        
		2*carDur => now; //Alternatively EventBank._waitOnAll(), but no justification for that many shreds yet
		sp.cut(0);
        0 => active;
        done.broadcast(); <<<"fadeTo done.">>>;
	}
    fun void fadeFrom(Preset p, dur carDur){	
		if(bp.playing == 0 || p.bp.playing == 1)	
        	spork~ p.bp._fade(bp, carDur);

		for(0 => int i; i < size; i++)
			FadeAux(p.go[i], go[i], carDur);
        
		2*carDur => now;
        p.sp.cut(0);
        0 => p.active;
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
			return;
		}
        if(from.type == "StepTrig" && to.type == "StepTrig"){
			if(from.active == 0 && to.active == 1)
				return;

			spork~ (from $ StepGeneralOut)._fadeTrig(to $ StepGeneralOut); 
			return;
		}
		spork~ from._fade(to, carDur);
	}

	fun void _fadeClockFrom(Preset p, dur carDur){
		_fadeClockFrom(p, ParamsM.ClockOut, dur carDur);
	}
	fun void _fadeClockFrom(Preset p, int clockChan, dur carDur){
		me.yield();
        if(sp.players.size() > 0){
            sp.players.get(0).refBpm => bpm;
            bp.setBeatTime24((1/bpm)::minute); //24 PPQN
        }
        me.yield();
		spork~ p.bp._fade(bp, carDur);
        FadeAux(p.go[clockChan], go[clockChan], dur carDur);
        p.go[clockChan].done => now;

		 <<<"fadeClockFrom done.">>>;
    }
    
    fun void fadeToKeepTrack(Preset p, dur carDur, int fadeClock){	
        if(fadeClock && (bp.playing == 1 || p.bp.playing == 0))	
            spork~ bp._fade(p.bp, carDur);
        
        for(0 => int i; i < size; i++)
            if(!Contains(sp.channels, i))
                FadeAux(go[i], p.go[i], carDur);
        
        2*carDur => now;
        <<<"fadeToKeepTrack done.">>>;
    }
    
    fun void fadeTrackTo(Preset p, dur carDur, int fadeClock){	
        if(fadeClock && (bp.playing == 1 || p.bp.playing == 0))	
            spork~ bp._fade(p.bp, carDur);
        
        for(0 => int i; i < size; i++)
            if(Contains(sp.channels, i)){
                FadeAux(go[i], p.go[i], carDur);}
                
                2*carDur => now;
                sp.cut(0);
                //0 => active;
                //done.broadcast();
                <<<"fadeTrackTo done.">>>;
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