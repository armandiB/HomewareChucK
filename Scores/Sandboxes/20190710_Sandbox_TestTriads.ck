fun static void TestTriads(int r, int s, int start_root_unit){

    12 => int ORDER_T;
    2 => int ORDER_I;
    //MathU.ListConsistentFiniteMetacyclicReps(ORDER_T, ORDER_I);

    Nint.MakePhi(r) @=> ExtFunction phi;

    Nint.MakeZeta(s, ORDER_T) @=> ExtFunction zeta;

    Impulse imp => ResonZ filt => NRev rev => Gain finalG => dac;
    rev => DelayA delay1 => Dyno feedback1 => filt;
    filt => Gain finalDry => dac;
    filt => DelayA delay2 => Gain delay2Gain => rev;
    delay2 => Gain feedback2 => delay2;
    delay2Gain => finalDry;

    finalG.gain(0.15);
    finalDry.gain(0.29);

    feedback1.gain(0.015);
    feedback1.compress();
    feedback1.slopeAbove(0.3);
    delay1.delay(13::ms);

    delay2.delay(70::ms);
    delay2Gain.gain(0.8);
    feedback2.gain(0.4);

    filt.gain(60);
    filt.Q(200);

    rev.mix(0.7);

    SinOsc sin1 => ADSR sin1Env => rev;
    sin1Env => finalDry;
    SawOsc sin2 => LPF sin2Lpf => ADSR sin2Env => rev;
    sin2Env => finalDry;

    sin1.gain(0);
    sin1Env.set(1100::ms, 300::ms, 0.2, 330::ms);
    sin2.gain(0);
    sin2Lpf.Q(0.7);
    sin2Env.set(90::ms, 70::ms, 0.7, 160::ms);

    58 => int NOTE_OFFSET;

    Nint.Make(7, ORDER_T) @=> Nint startRoot;
    Nint.Make(1, ORDER_I) @=> Nint startType;

    GTriad.Make(startRoot.makeESet(), startType.makeESet()) @=> GTriad startTriad;
    startTriad @=> GTriad triad;
    GTriad.Make(Nint.Make(start_root_unit, ORDER_T).makeESet(), Nint.Make(1, ORDER_I).makeESet()) @=> GTriad unitTriad;
    triad.setBijUnit(unitTriad);
    unitTriad.setBijUnit(unitTriad);

    EGroupExt.Make(Nint.Make(6, ORDER_T), Nint.Make(0, ORDER_I), phi, zeta) @=> EGroupExt transfo;
    EGroupExt.Make(Nint.Make(3, ORDER_T), Nint.Make(1, ORDER_I), phi, zeta) @=> EGroupExt transfoUnit;

    Nint.GetClassicTriad(triad) @=> GScale scale;
    Nint.GetClassicTriad(unitTriad) @=> GScale scaleUnit;

    0 => int loopCount;
    1 => int pos;
    0 => int doWhat;
    while(loopCount < 200){
        if(loopCount > 15 && loopCount < 71)
            sin1.gain(0.06/55*(loopCount-15));
        if(loopCount > 99 && loopCount < 180)
            sin1.gain(0.06/100*(180-loopCount+20));
        if(loopCount > 35 && loopCount < 110)
            sin2.gain(0.37*(loopCount-35)/75);
        
        //Interpolate proba function?
        if(loopCount < 80)
            MathU.Mod(1+pos,scale.subset.size()) => pos;
        else if(loopCount < 140)
            MathU.Mod(-1+pos,scale.subset.size()) => pos;
        else{
            Math.random2(0, scale.subset.size()-1) => int upDown;
            MathU.Mod(upDown-1+pos,scale.subset.size()) => pos;
        }
        
        0 => int changeUnit;
        if(loopCount%5==0)
            Math.random2(0,1) => changeUnit;
        
        10 => int modul;
        if(loopCount%modul==0){
            Math.random2(0,2) => doWhat;
            if(changeUnit){
                modul%40 + 10=> modul;
                transfo.op(transfoUnit) @=> transfo;
                sin2Env.keyOff();
                }
        }
        if(loopCount > 140)
            1 => doWhat;
        
        imp.next(pos);
        if(pos==0){
            if(doWhat==0){
                triad.lAction(transfo) @=> triad;
                sin2Env.keyOff();}
            else if(doWhat==1){
                triad.rAction(transfo) @=> triad;
                sin2Env.keyOff();}
        //triad.print();
        }
        else{
                delay2.delay() + (pos-1.5)*Math.random2f(0,1)::ms => delay2.delay;
                if(loopCount%3==0){
                if(changeUnit){
                    unitTriad.rAction(transfoUnit) @=> unitTriad;
                    triad.setBijUnit(unitTriad);
                    Nint.GetClassicTriad(unitTriad) @=> scaleUnit;
                    unitTriad.print();
                }
                sin1Env.keyOff(); 
                220::ms => now;          
            }
        }
           
        Nint.GetClassicTriad(triad) @=> scale;
        110::ms => now;
        filt.freq(Std.mtof((scale.subset.get(pos)$Nint).eqClass + NOTE_OFFSET));
        sin1.freq(Std.mtof((scaleUnit.subset.get(0)$Nint).eqClass + NOTE_OFFSET)/2);
        sin2.freq(Std.mtof((scale.subset.get(1)$Nint).eqClass + NOTE_OFFSET));
        sin2Lpf.freq(Std.mtof((scaleUnit.subset.get(2)$Nint).eqClass + NOTE_OFFSET));
        sin1Env.keyOn();
        
        delay1.delay()*(1+pos)*Math.pow(6,-1/2.9) => delay1.delay;
        imp.next(1);
        
        //Shuffle function?
        Math.random2f(-1,1)/2 => float shuffle;
        220::ms + shuffle::ms => now;
        
        if(sin2Env.state()==4)
            sin2Env.keyOn();
        loopCount++;
    }
    feedback1.gain()/10 => feedback1.gain;
    1::second=>now;
    sin1Env.releaseTime(1900::ms);
    sin2Env.releaseTime(1800::ms);
    sin1Env.keyOff();
    sin2Env.keyOff();
    5::second=>now;
}

Std.srand(2);
//spork ~ Recording.RecordWav(2, "Recordings/20190710_TestTriads_Z12xZ2_startsDb");

TestTriads(0, 11, 3);


