public class XenakeurPreset0 extends TypicalPresetTrack{
    doInit(0);
    
    1::second => dur beatTime;

    me.yield();
	bp.setBeatTime24(beatTime);

    int gains[0]; gains << ParamsM.EffectsOut;
    int ignore[0];
	ignore << 4 << 5 << 6 << 8 << 9 << 13 << 14 << 15;
    doInit2(gains, 0, 0, ignore);

    Std.srand(1);

    5*beatTime => dur totalDurRecording;

    XenakeurConics xenC1;
    xenC1.init(totalDurRecording, 80, beatTime);
    CIO.In[ParamsM.EffectsIn] => GainGesture xenG1 => xenC1.xenakeur => go[ParamsM.EffectsOut];
    xenG1.gainMode(0);

    XenakeurConics xenC2;
    xenC2.init(totalDurRecording, 40, beatTime);
    CIO.In[ParamsM.EffectsIn] => GainGesture xenG2 => xenC2.xenakeur => go[ParamsM.EffectsOut];  
    xenG2.gainMode(0);

    Event goNext;

    Step stp => ADSR env => CIO.Out[12];
    env.set(3::second, 9::second, 0.8, 4::second);

    //Bug when play after rec
    //couple with envelope, pitch (parnharm relative). Envelope delay = 3.15*beatTime, Envelope dur = T*2*beatTime*stepDilationFactorHead, pitch = relativePos. Osc makes the sweep.

    //idea: send (after wait) log2(k) to panHarm
    
    fun void _launch(){
        Math.log2(3) - 1 => float fifth;

        spork~ _waitOnKeys(1.15*beatTime, 0.6*beatTime, 0);

        //rec1 (,) up 1 oct
        goNext => now; //(`)
        spork~ xenC1._makeDoubleParabola(2, 2, 0, 1, 1, 0, 0);

        //rec1? up 1 oct
        goNext => now;
        spork~ xenC1._makeDoubleParabola(2, 4, 0, 1, 1, 0, 0);

        //rec2 (;) down 2 oct
        goNext => now;
        spork~ xenC2._makeDoubleParabola(-4, 4, 0, 1, 2, 0, 0);

        goNext => now;
        spork~ xenC2._makeDoubleParabola(-4, 8, 0, 0.4, 2, 0, 0);

        //rec1? up 1 oct
        goNext => now;
        spork~ xenC1._makeDoubleParabola(2, 6, 6, 1, 2, 0, 1 + fifth);

        goNext => now;
        spork~ xenC2._makeDoubleParabola(-4, 20, 0, 1, 2, 0, 0);

        //rec1 up 3 oct
        //rec2? down 2 oct
        goNext => now;
        spork~ xenC1._makeDoubleParabola(8, 0, 30, 1, 1, -fifth, 1);
        ((3.15)*beatTime + 2*beatTime)*0.9 => now;
        spork~ xenC2._makeDoubleParabola(-4, 0, 17, 1, 1.2, 0, 1 + fifth);
        (3*beatTime + 2*beatTime)*0.9 => now;
        spork~ xenC1._makeDoubleParabola(-4, 10, 0, 1, -1, 1, 1);
        ((3.15)*beatTime + 2*beatTime)*0.9 => now;
        spork~ xenC2._makeDoubleParabola(-4, 5, 20, 0.8, 1.5, 0, 1);

        //rec2 down 3 oct
        //rec1? up 3 oct
        goNext => now;
        spork~ xenC1._makeDoubleParabola(8, 20, 0, 1, 0.9, 0, 1 + fifth);
        ((3.15)*beatTime + 2*beatTime*0.9)*0.87 => now;
        spork~ xenC2._makeDoubleParabola(-8, 20, 0, 1, 1.1, 0.5, 0);
        ((3.)*beatTime + 2*beatTime)*0.9 => now;
        spork~ xenC1._makeDoubleParabola(8, 18, 0, 1, 1.07, 0.5, 0);
        ((3.15)*beatTime + 2*beatTime)*0.9 => now;
        spork~ xenC2._makeDoubleParabola(-8, 22, 0, 1, -1.05, 0, 0);
        ((2.8)*beatTime + 2*beatTime)*0.9 => now;
        spork~ xenC1._makeDoubleParabola(8, 20, 0, 1, 1, 0.5, 0);
        ((2.9)*beatTime + 2*beatTime)*0.9 => now;
        spork~ xenC2._makeDoubleParabola(-8, 15, 0, 1, -0.95, 0, 0);
        (2.5*beatTime + 2*beatTime)*0.9 => now;
        spork~ xenC1._makeDoubleParabola(8, 20, 30, 1, 1, 0, 1 + fifth);

        //rec2 down 2 oct 7 semis
        goNext => now;
        spork~ xenC2._makeDoubleParabola(-6, 17, 25, 1, -0.85, 0, 1.5);

        //rec1 up 1 oct 7 semis
        goNext => now;
        spork~ xenC1._makeDoubleParabola(3, 20, 40, 1, -1.2, 0, 1.5);

    }

    fun void _waitOnKeys(dur fadeDur1, dur fadeDur2, int instant){
        Hid hi;
        HidMsg msg;

        if(!hi.openKeyboard(0))
            <<<"Keyboard failure.">>>;

        while(true){
            hi => now;

            while(hi.recv(msg)){              
                if(msg.isButtonDown()){
                    msg.ascii => int K;
                    <<<K>>>;

                    if(K == 96){
                        bp.beat => now;
                        env.keyOn();
                        goNext.broadcast();
                    }
                    else if(K == 44){
                        bp.beat => now;
                        spork~ _rec1(fadeDur1*Math.random2f(0.8, 1.2), instant);
                    }
                    else if(K == 59){
                        bp.beat => now;
                        spork~ _rec2(fadeDur2*Math.random2f(0.8, 1.2), instant);
                    }
                }
            }
        }
    }

    fun void _rec1(dur fadeDur, int instant){
        if(instant)
            spork~ _printBeat(0);
        else{
            spork~ _printBeat(-2);
            2*beatTime => now;
        }
        spork~ xenG1._fade(0.3, fadeDur, "lin");
        spork~ xenC1._rec();
        totalDurRecording - fadeDur => now;
        spork~ xenG1._fade(0, fadeDur, "lin");
        xenG1.done => now;
        <<<"_rec1 done.">>>;
    }
    fun void _rec2(dur fadeDur, int instant){
        if(instant)
            spork~ _printBeat(0);
        else{
            spork~ _printBeat(-2);
            2*beatTime => now;
        }
        spork~ xenG2._fade(0.3, fadeDur, "lin");
        spork~ xenC2._rec();
        totalDurRecording - fadeDur => now;
        spork~ xenG2._fade(0, fadeDur, "lin");
        xenG2.done => now;
        <<<"_rec2 done.">>>;
    }

    fun void _printBeat(int startI){
        startI => int i;
        while(i < totalDurRecording/beatTime){
            <<<"Beat", i>>>;
            i++;
            beatTime => now;
        }
    }

}