public class D_S_{

    static float BPM;
    static StepPlayer@ Clock;
    static ArrayList@ Progression;
    
    static Preset@ curPreset;
    
    fun static void main_0(){    
        
        Event beat;
		beat @=> ParamsM.Beat;
		
		PrimePitchesPreset p1;
		
		p1 @=> curPreset;
		
		curPreset.fadeIn(ParamsM.BarTime*2);
		
		while(1) 100::second => now;
    }
	
	fun static void main_1(){
		curPreset.launch();
	}
	
	fun static void main_2(){
		TypicalPreset p2;

		string files[2];
		"64_BorisDanArmand_3" => files[0]; files[0] => files[1];
		p2.sp.load("20190911_", files, ".wav", 1);
		
		"null" => p2.go[12].type;
		"null" => p2.go[14].type;
		
		spork~ curPreset.fade(p2, 20::second);
		spork~ p2.sp.play(0);
		
		p2 @=> curPreset;
		
		while(1) 100::second => now;
	}
}
