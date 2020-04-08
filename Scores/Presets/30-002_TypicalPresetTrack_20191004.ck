public class TypicalPresetTrack extends Preset{

    StepGeneralOut sGO;
    bp.setBeatTime24(1::second);
    spork~ sGO._playTrigOnBeatPlayer(bp);
    spork~ bp._playClock();

    fun void doInit(int sid){
	    init(sid);
    }
	
	//StepOut step5 @=> go[5].general;
	//SinGeneralOut sin8 @=> go[8]; 
    
    fun void doInit2(){
        doInit2(new int[0]);
    }
    fun void doInit2(int ignore[]){
        int gs[0];
        doInit2(gs, 0, 4, ignore);
    }
    fun void doInit2(int gains[], int inSzChans, int spSize, int ignore[]){

        ignore << ParamsM.RunOut;
        sGO @=> go[ParamsM.ClockOut];
        initGains(gains);
        
        IntArrayList outSzChans; outSzChans.add(ParamsM.DirectOutL); outSzChans.add(ParamsM.DirectOutR);
        IntArrayList spChans; spChans.add(ParamsM.DirectOutL); spChans.add(ParamsM.DirectOutR); 
        if(CIO.OutSize > ParamsM.RouteOutL && CIO.OutSize > ParamsM.RouteOutR){spChans.add(ParamsM.RouteOutL); spChans.add(ParamsM.RouteOutR);}
        if(CIO.OutSize > ParamsM.ClockOut){spChans.add(ParamsM.ClockOut);}
        if(CIO.OutSize > ParamsM.TBDCVOut){spChans.add(ParamsM.IntensityOut);}
        if(CIO.OutSize > ParamsM.AddAudioOut){spChans.add(ParamsM.AddAudioOut);}
        if(CIO.OutSize > ParamsM.RunOut){spChans.add(ParamsM.RunOut);}
        //if(CIO.OutSize > ParamsM.FourierPitchOut){spChans.add(ParamsM.FourierPitchOut);}
        
        if(spSize < spChans.size())
            spChans.size(spSize);
        
        init2(inSzChans, outSzChans, spChans, ignore);
        
        "StepTrig" => sGO.type;
        
        //CIO.In[ParamsM.EffectsIn] => sz.in[0];
    
        //step5.setNext(-0.5);
        //sin8.setFreq(0.1); sin8.gen.gain(0.1); sin15.gGesture.addMode();  
    }

    fun void doInits(int sid, int ignore[]){
        doInit(sid);
        doInit2(ignore);
    }
	
    fun void _launch(){       
        _launchTrack();
    }
    
}