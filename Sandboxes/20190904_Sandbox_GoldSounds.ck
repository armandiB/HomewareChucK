public class D_S_GS{

    static int NChanDac;
    static float BPM;
    static StepPlayer@ Clock;
	static ArrayList@ Progression;
    
    static SamplePlayer@ SP0a;
    static SamplePlayer@ SP1a;
    static SamplePlayer@ SP2a;
    static SamplePlayer@ SP3a;
    static SamplePlayer@ SP4a;
    
    static SamplePlayer@ SP0b;
    static SamplePlayer@ SP1b;
    static SamplePlayer@ SP2b;
    static SamplePlayer@ SP3b;
    static SamplePlayer@ SP4b;
	
	static Sandbox_AK@ SB_AK;
    
    fun void main(){    
        
        MBus.PInit(NChanDac);
        Event beat;
		beat @=> ParamsM.Beat;
        IntArrayList Cclock;
        Cclock.add(0);
        IOU.PlayClock(BPM, Cclock, 24, beat) @=> Clock;
        IntArrayList Creset;
        Creset.add(1);
        IOU.PlayTrig(Creset);
     
	    IntArrayList Gm;
		Gm.add(10); Gm.add(1);
		IntArrayList Em;
		Em.add(7); Em.add(1);
		IntArrayList F;
		F.add(8); F.add(0);
		ArrayList prog @=> Progression;
		Progression.add(Gm); Progression.add(Gm);
		Progression.add(Em); Progression.add(Em);
		Progression.add(Gm); Progression.add(F);
		Progression.add(Gm); Progression.add(Em);
		
        SamplePlayer sp0a @=> SP0a;
        SamplePlayer sp1a @=> SP1a;
        SamplePlayer sp2a @=> SP2a;
        SamplePlayer sp3a @=> SP3a;
        SamplePlayer sp4a @=> SP4a;
    
        SamplePlayer sp0b @=> SP0b;
        SamplePlayer sp1b @=> SP1b;
        SamplePlayer sp2b @=> SP2b;
        SamplePlayer sp3b @=> SP3b;
        SamplePlayer sp4b @=> SP4b;
        
        SP0a.setBeat(ParamsM.Beat);
        SP1a.setBeat(ParamsM.Beat);
        SP2a.setBeat(ParamsM.Beat);
        SP3a.setBeat(ParamsM.Beat);
        SP4a.setBeat(ParamsM.Beat);
        
        SP0b.setBeat(ParamsM.Beat);
        SP1b.setBeat(ParamsM.Beat);
        SP2b.setBeat(ParamsM.Beat);
        SP3b.setBeat(ParamsM.Beat);
        SP4b.setBeat(ParamsM.Beat);
        
        SP0a => MBus.PChan[3];
        SP1a => MBus.PChan[4];
        SP2a => MBus.PChan[5];
        SP3a => MBus.PChan[6];
        SP4a => MBus.PChan[7];
        
        SP0b => MBus.PChan2[3];
        SP1b => MBus.PChan2[4];
        SP2b => MBus.PChan2[5];
        SP3b => MBus.PChan2[6];
        SP4b => MBus.PChan2[7];
        
        Sandbox_AK sb_AK;
		sb_AK @=> SB_AK;
		6 => ParamsM.Transfo0_T;
		1 => ParamsM.Transfo0_I;
        
        ParamsM.BarTime => now;
        SB_AK.Launch.signal();
        
		while(true){ 
			ParamsM.Beat => now; ParamsM.Beat => now;
			ParamsM.Beat => now; ParamsM.Beat => now;
			SB_AK.Launch.signal();
	    }
    }
}