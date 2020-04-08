public class D_S{

    static int NChanDac;
    static float BPM;
    static StepPlayer@ Clock;
    
    fun void main(){    
        Std.srand(2);

        IntArrayList CrecordDac;
        CrecordDac.add(0);CrecordDac.add(2);CrecordDac.add(3);
		IntArrayList CrecordAdc;
        CrecordDac.add(0);CrecordDac.add(1);CrecordDac.add(2);CrecordDac.add(3);
        //spork ~ Recording.RecordWavDac(CrecordDac, "Recordings/20190903_GoldSounds");
		//spork ~ Recording.RecordWavAdc(CrecordAdc, "Recordings/20190903_GoldSounds");

        2 => NChanDac;
        64 => BPM;
        (4./BPM) :: minute => ParamsM.BarTime;
        
        MBus.PInit(NChanDac);
        Event Beat;
        IntArrayList Cclock;
        Cclock.add(0);
        IOU.PlayClock(BPM, Cclock, 24, Beat) @=> Clock;
        IntArrayList Creset;
        Creset.add(1);
        IOU.PlayTrig(Creset);
     
        
        
        /*
        0 => ParamsM.finalGain;
        Sandbox_AK sb_AK;
        //spork~ sb_AK.sineTriplet_20190819(7, 0, 1, 1, 3., 4, ParamsM.BarTime);
        spork~ sb_AK.arpeggio_20190819(11, 6, 6, 1, 3., ParamsM.BarTime);
        ParamsM.BarTime => now;
        sb_AK.Launch.signal();
        */
        while(true) 1::second => now;

        me.yield();
    }
}