public class Sandbox_AK{
   
    Event Launch;
	int count;
	float rando;
	
	fun void arpeggio_20190903(int r, int s, ArrayList progression, float globalOctave, dur BarTime){
		Launch => now;
		PitchHandler.MakePitchInterpol(2) @=> Interpolator interpH;
		
		12 => int ORDER_T;
        2 => int ORDER_I;

        BarTime / 24 => dur TargetTime;

        AK _ak;

        <<<"Init AK:", r, s>>>;
        _ak.Init(r, s, ORDER_T, ORDER_I);
        _ak.SetTransfo0(ParamsM.Transfo0_T, ParamsM.Transfo0_I);
		_ak.FillTriads(progression);
        globalOctave => _ak.octave0;
		_ak.UpdateScale0();
        spork~arpeggioUtil(_ak);

        0 => int zeroedClass;
        while(true){
			_ak.SetTransfo0(ParamsM.Transfo0_T, ParamsM.Transfo0_I);
			Math.random2f(-0.1,0.1) => rando;
            _ak.UpdateScale0();
            _ak.GetCloseFreqClassicDiatonic(zeroedClass) => float currFreq;
	        (interpH.tick0$PitchHandler).changeFreq(currFreq, Math.exp(rando)*TargetTime/6);

            (interpH.tick1$PitchHandler).changeFreq(currFreq, TargetTime/4);
	
        (zeroedClass + 3) % ORDER_T => zeroedClass;
        (1+ 1/32*Math.sin(Math.PI*count/128 + 3*Math.PI*rando))*TargetTime => now;
        }
        
	}
	fun void arpeggioUtil(AK ak){
		while(true){
			Launch => now;
			ak.ApplyTransfoTriads();
			<<<ak.GetFreqScale0(0)>>>;
		}
	}
	
     fun void sineTriplet_20190819(int r, int s, int transfo0_T, int transfo0_I, float globalOctave, int nbBars, dur BarTime){   
        Launch => now;
        
        PitchHandler.MakePitchInterpol(2) @=> Interpolator interpH0;
        PitchHandler.MakePitchInterpol(3) @=> Interpolator interpH1;
        PitchHandler.MakePitchInterpol(4) @=> Interpolator interpH2;
        
        Interpolator interpH3;
		interpH3.setMode("geo");
		interpH3.setParam(0.75);
		interpH3.setTicks(interpH1, interpH2);
        
        interpH3 => OutGen outGen3 => dac.chan(5);
		outGen3.setMode("freq");
        
        IntArrayList Ctrig;
        Ctrig.add(7);
        
        NRev rev;
        rev => Gain gOut; //=> dac.chan(2);
        gOut.gain(ParamsM.finalGain);
        rev.mix(0.2);
        
        interpH0 => SinOsc sin0 => rev;
        interpH1 => SinOsc sin1 => rev;
        interpH2 => SinOsc sin2 => rev;
        sin0.gain(0.35);
        sin0.sync(0);
        sin1.gain(0.35);
        sin1.sync(0);
        sin2.gain(0.35);
        sin2.sync(0);

        12 => int ORDER_T;
        2 => int ORDER_I;

        BarTime / 5 * 4 => dur TargetTime;

        AK _ak;

        <<<"Init AK:", r, s>>>;
        _ak.Init(r, s, ORDER_T, ORDER_I);
        _ak.SetTransfo0(transfo0_T, transfo0_I);
        globalOctave => _ak.octave0;

        2*BarTime => now;

        0 => count;
        while( count < 64 ){
            Math.random2f(-0.1,0.1) => rando;
			
            IOU.PlayTrig(Ctrig);
			gOut.gain(ParamsM.finalGain);
            Launch.signal();
            _ak.UpdateScale0();
            
            (interpH0.tick0$PitchHandler).changeFreq(_ak.GetJIFreqTriad0(0), Math.exp(rando)*TargetTime);
            (interpH0.tick1$PitchHandler).changeFreq(_ak.GetJIFreqTriad0(0), TargetTime/2);
            (interpH1.tick0$PitchHandler).changeFreq(_ak.GetJIFreqTriad0(1), TargetTime);
            (interpH1.tick1$PitchHandler).changeFreq(_ak.GetJIFreqTriad0(1), TargetTime/2);
            (interpH2.tick0$PitchHandler).changeFreq(_ak.GetJIFreqTriad0(2), TargetTime/2);
            (interpH2.tick1$PitchHandler).changeFreq(_ak.GetJIFreqTriad0(2), (1+10*rando*rando-rando)*TargetTime);
            
			if(count%4==0)
				_ak.SetTransfo0((transfo0_T+7)%ORDER_T, (transfo0_I+1)%ORDER_I);
			if(count%4==1)
				_ak.SetTransfo0(transfo0_T, transfo0_I);
			
            _ak.ApplyTransfo0();
            
            nbBars*(1+ 1/32*Math.sin(Math.PI*count/128 + 3*Math.PI*rando))*BarTime => now;
            count++;
        }
        4*BarTime => now;
        sin0.gain(0);
        sin1.gain(0);
        sin2.gain(0);
        <<<"AK Ended:", r, s>>>;
    }
    
    fun void sineTriplet_20190808(int r, int s, int transfo0_T, int transfo0_I, float globalOctave, int nbBars, dur BarTime){   
        Launch => now;
        
        PitchHandler.MakePitchInterpol(1) @=> Interpolator interpH0;
        PitchHandler.MakePitchInterpol(2) @=> Interpolator interpH1;
        PitchHandler.MakePitchInterpol(7) @=> Interpolator interpH2;
        
        Interpolator interpH3;
		interpH3.setMode("geo");
		interpH3.setParam(0.5);
		interpH3.setTicks(interpH1, interpH2);
        
        interpH3 => OutGen outGen3 => dac.chan(5);
		outGen3.setMode("freq");
        
        IntArrayList Ctrig;
        Ctrig.add(0);
        
        NRev rev;
        rev => Gain gOut; //=> dac.chan(2);
        gOut.gain(ParamsM.finalGain);
        rev.mix(0.2);
        
        interpH0 => SinOsc sin0 => rev;
        interpH1 => SinOsc sin1 => rev;
        interpH2 => SinOsc sin2 => rev;
        sin0.gain(0.35);
        sin0.sync(0);
        sin1.gain(0.35);
        sin1.sync(0);
        sin2.gain(0.35);
        sin2.sync(0);

        12 => int ORDER_T;
        2 => int ORDER_I;

        BarTime / 2 => dur TargetTime;

        AK _ak;

        <<<"Init AK:", r, s>>>;
        _ak.Init(r, s, ORDER_T, ORDER_I);
        _ak.SetTransfo0(transfo0_T, transfo0_I);
        globalOctave => _ak.octave0;

        2*BarTime => now;

        0 => count;
        while( count < 64 ){
            
            IOU.PlayTrig(Ctrig);
			gOut.gain(ParamsM.finalGain);
            Launch.signal();
            _ak.UpdateScale0();
            
            Math.random2f(-0.1,0.1) => rando;
            (interpH0.tick0$PitchHandler).changeFreq(_ak.GetFreqScale0(0), Math.exp(rando)*TargetTime);
            (interpH0.tick1$PitchHandler).changeFreq(_ak.GetFreqScale0(0), TargetTime/2);
            (interpH1.tick0$PitchHandler).changeFreq(_ak.GetFreqScale0(1), TargetTime);
            (interpH1.tick1$PitchHandler).changeFreq(_ak.GetFreqScale0(1), TargetTime/2);
            (interpH2.tick0$PitchHandler).changeFreq(_ak.GetFreqScale0(2), TargetTime/2);
            (interpH2.tick1$PitchHandler).changeFreq(_ak.GetFreqScale0(2), (1+10*rando*rando-rando)*TargetTime);
            
			if(count%8==0)
				_ak.SetTransfo0((transfo0_T+1)%ORDER_T, (transfo0_I+1)%ORDER_I);
			if(count%8==1)
				_ak.SetTransfo0(transfo0_T, transfo0_I);
			
            _ak.ApplyTransfo0();
            
            nbBars*(1+ 1/32*Math.sin(Math.PI*count/128 + 3*Math.PI*rando))*BarTime => now;
            count++;
        }
        4*BarTime => now;
        sin0.gain(0);
        sin1.gain(0);
        sin2.gain(0);
        <<<"AK Ended:", r, s>>>;
    }
    
    fun void sineAloneMistake_20190808(int r, int s, int transfo0_T, int transfo0_I, float globalOctave, int nbBars, dur BarTime){
        
        PitchHandler.MakePitchInterpol(-1) @=> Interpolator interpH0;
        PitchHandler.MakePitchInterpol(-1) @=> Interpolator interpH1;
        PitchHandler.MakePitchInterpol(-1) @=> Interpolator interpH2;

        interpH0.setParam(0);
        interpH1.setParam(0);
        interpH1.setParam(0);
        
        interpH0 => SinOsc sin0 => NRev rev => Gain gOut => dac;
        interpH1 => SinOsc sin1 => rev;
        interpH2 => SinOsc sin2 => rev;
        gOut.gain(0.3);
        rev.mix(0.2);
        sin0.gain(0.35);
        sin0.sync(0);
        sin1.gain(0.35);
        sin1.sync(0);
        sin2.gain(0.35);
        sin2.sync(0);

        12 => int ORDER_T;
        2 => int ORDER_I;

        BarTime / 2 => dur TargetTime;

        AK _ak;

        <<<"Init AK:", r, s>>>;
        _ak.Init(r, s, ORDER_T, ORDER_I);
        _ak.SetTransfo0(transfo0_T, transfo0_I);
        globalOctave => _ak.octave0;

        2*BarTime => now;

        0 => count;
        while( count < 64 ){
            _ak.UpdateScale0();
            
            Math.random2f(-0.1,0.1) => rando;
            (interpH0.tick0$PitchHandler).changeFreq(_ak.GetFreqScale0(0), Math.exp(rando)*TargetTime);
            (interpH0.tick0$PitchHandler).changeFreq(_ak.GetFreqScale0(1), TargetTime);
            (interpH0.tick0$PitchHandler).changeFreq(_ak.GetFreqScale0(2), (1+10*rando*rando-rando)*TargetTime);
            
            _ak.ApplyTransfo0();
            
            nbBars*(1+ 1/32*Math.sin(Math.PI*count/128 + 3*Math.PI*rando))*BarTime => now;
            count++;
        }
        4*BarTime => now;
        sin0.gain(0);
        sin1.gain(0);
        sin2.gain(0);
        <<<"AK Ended:", r, s>>>;
    }
}