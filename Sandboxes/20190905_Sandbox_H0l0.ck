public class D_S_GS{

    static float BPM;
    static StepPlayer@ Clock;
    static ArrayList@ Progression;
    
    static SPBundle@ SPa;
    static SPBundle@ SPb;
	
    static Sandbox_AK@ SB_AK;
    
    fun void main(){    
        
        Event beat;
		beat @=> ParamsM.Beat;
        IOU.PlayClock(BPM, 0, 24, beat) @=> Clock;
        IOU.PlayTrig(1);
     
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
		
        SPBundle spa @=> SPa;
        SPBundle spb @=> SPb;
        
        SPa.init(3, 5, 1);
        SPb.init(3, 5, 2);
        
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
