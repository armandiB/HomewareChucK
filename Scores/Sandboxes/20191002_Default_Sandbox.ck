public class D_S_{

    static float BPM;
    static StepPlayer@ Clock;
    static ArrayList@ Progression;
    
    static Preset@ curPreset;
    static Preset@ curPresetTrack;
    
    fun static void main_0(){    
        
        Event beat;
		beat @=> ParamsM.Beat;
        
        ParamsM.gEffects.gain(0.3);
        
        PrimePitchesPreset p1;
		p1 @=> curPreset;
		//(p1.go[p1.chanPh12] $ PitchHandlerGeneralOut).setMode("superExpHarmonic");
       
        p1.openClock();

        while(1) 100::second => now;
        
    }
	
	fun static void main_1(){ //add at least one param from joystick
        curPreset.fadeIn(ParamsM.BarTime*2);
        curPreset.go[ParamsM.OscPitchOut].gGesture._fade(0, 80::ms);
		curPreset._launch();
	}
    
    fun static void main_15(){    
        133 => BPM;
        (4./BPM) :: minute => ParamsM.BarTime;
             
        PrimePitchesPreset p15;
        (curPreset $ PrimePitchesPreset).pp.f0*7/8 => p15.pp.f0;
        
        spork~ p15._launch();
        ParamsM.BarTime*4 => now;
        
        spork~ curPreset.fadeTo(p15, ParamsM.BarTime*12);
        
        p15 @=> curPreset;
        while(1) 100::second => now;
    }

    ///IOU.PlayVolts(-1, 2);
    
    fun static void main_ar(){
        
        string files[0];
		files << "20191108" << "20191108" << "20191108" << "20191108";
		curPreset.sp.loadAlternate("Tracks/Artzanburu/20190926_133_Artzanburu_", files, ".wav", 1);
        
        curPreset._launchTrack();
    }
    
    fun static void main_18(){
        TypicalPresetTrack p2;
        int ignore[0]; ignore << 2 << 3 << 4 << 5 << 6 << 7 << 13 << 14 << 15;
        p2.doInits(0, ignore);
        
        string filesMain[0];
        string filesRoute[0];
        filesMain << "EffectsStereo_A" << "EffectsStereo_A" << "null" << "null";
        filesRoute << "null" << "null" << "Percs_A" << "AltonMono_A";
        p2.sp.loadAlternate("Tracks/Alton/20190823_130_Alton_", filesMain, ".wav", 1);
        p2.sp.load("Tracks/Alton/20190823_130_Alton_", filesRoute, ".wav", 1);
        
        me.yield();
        <<<"bpm:", p2.sp.players.get(0).refBpm>>>;
        130 => p2.sp.players.get(0).refBpm;
        p2.sp.setStartDur(1296, 130);
        
        p2._fadeClockFrom(curPreset, 10::second);
        
        spork~ p2._launch();
        spork~ curPreset.fadeTo(p2, 45::second);
        
        p2 @=> curPreset;
        
        SinOsc sinMod => CIO.Out[12];
        sinMod.gain(0.7);
        sinMod.freq(130/60/128);
        
        while(1) 100::second => now; //p2.done => now;?
    }
    
	fun static void main_2(){
		TypicalPresetTrack p2;
        int ignore[0]; ignore << 2 << 3 << 4 << 5 << 6 << 7 << 13 << 14 << 15;
        p2.doInits(0, ignore);

		string filesMain[0];
        string filesRoute[0];
		filesMain << "Stereo" << "Stereo" << "null" << "null";
        filesRoute << "null" << "null" << "BassL" << "CloudsWavesR";
		p2.sp.loadAlternate("Tracks/Michael_Track_4/20190201_54_Michael_Track_4_", filesMain, ".wav", 1);
		p2.sp.load("Tracks/Michael_Track_4/20190201_54_Michael_Track_4_", filesRoute, ".wav", 1);

		me.yield();
        <<<"bpm:", p2.sp.players.get(0).refBpm>>>;
        54 => p2.sp.players.get(0).refBpm;
        
        p2._fadeClockFrom(curPreset, 10::second);

        spork~ p2._launch();
		spork~ curPreset.fadeTo(p2, 45::second);
		        
        p2 @=> curPreset;
        
        SinOsc sinMod => CIO.Out[12];
        sinMod.gain(0.7);
        sinMod.freq(54/60/128);
        
        11.5::minute => now;
        p2.sp.loopFromNow(32);

        while(1) 100::second => now; //p2.done => now;?
	}
    
    //D_S_.curPreset.sp.letFinish(1);

    fun static void main_21(){
		TypicalPresetTrack p2;
        int ignore[0]; ignore << 2 << 4 << 5 << 6 << 7 << 15;
        
        p2.doInit(0);
        int gs[0];
        p2.doInit2(gs, 0, 8, ignore);

		string filesMain[0];
        string filesRoute[0];
		filesMain << "KickStereo" << "KickStereo" << "null" << "null" << "null" << "null" << "null" << "null";
		filesRoute << "null" << "null" << "BassL" << "HighsR" << "Clock" << "UnipolLFO" << "ResoAddOut" << "PitchB";
        p2.sp.loadAlternate("Tracks/DrunkMarch/20191111_81_DrunkMarch_20191112_", filesMain, ".wav", 1);
		p2.sp.load("Tracks/DrunkMarch/20191111_81_DrunkMarch_20191112_", filesRoute, ".wav", 1);

		me.yield();
        <<<"bpm:", p2.sp.players.get(0).refBpm>>>;
        81 => p2.sp.players.get(0).refBpm;
        
        p2._fadeClockFrom(curPreset, 25::second);

        spork~ p2._launch();
		spork~ curPreset.fadeTo(p2, 45::second);
		        
        p2 @=> curPreset;
        
        SinOsc sinMod => CIO.Out[12];
        sinMod.gain(0.7);
        sinMod.freq(81/60/128);

        while(1) 100::second => now; //p2.done => now;?
	}
    
    fun static void main_22(){
        TypicalPresetTrack p2;
        int ignore[0]; ignore << 2 << 4 << 5 << 6 << 7 << 15;
        
        p2.doInit(0);
        int gs[0];
        p2.doInit2(gs, 0, 8, ignore);
        
        string filesMain[0];
        string filesRoute[0];
        filesMain << "StereoBassKick" << "StereoBassKick" << "null" << "null" << "null" << "null" << "null" << "null";
        filesRoute << "null" << "null" << "HighsL" << "CrescendoR" << "Clock" << "Intensity" << "PianoAdd" << "Run";
        p2.sp.loadAlternate("Tracks/DrunkMarch/DrunkMarchDrone_65-61/20191111_65-61_DrunkMarchDrone_", filesMain, "_20191116.wav", 1);
        p2.sp.load("Tracks/DrunkMarch/DrunkMarchDrone_65-61/20191111_65-61_DrunkMarchDrone_", filesRoute, "_20191116.wav", 1);
        
        me.yield();
        <<<"bpm:", p2.sp.players.get(0).refBpm>>>;
        65.61 => p2.sp.players.get(0).refBpm;
        
        p2._fadeClockFrom(curPreset, 25::second);
        
        spork~ p2._launch();
        spork~ curPreset.fadeTo(p2, 45::second);
        
        p2 @=> curPreset;
        
        SinOsc sinMod => CIO.Out[13];
        sinMod.gain(0.7);
        sinMod.freq(65.61/60/128);
        
        while(1) 100::second => now; //p2.done => now;?
    }


    fun static void main_3(){
        XenakeurPreset0 p3;
        ParamsM.gEffects.gain(0.05);
        
        me.yield();
        spork~ p3._launch();
        spork~ curPreset.fadeToKeepTrack(p3, 45::second, 0);
        
        //curPreset.done => now;
        //curPreset.go[ParamsM.ClockOut].done.
        
        curPreset @=> curPresetTrack;
        p3 @=> curPreset;
        while(1) 100::second => now;
    }//curPresetTrack.fadeTrackTo(curPreset, 10::second, 1);
}
