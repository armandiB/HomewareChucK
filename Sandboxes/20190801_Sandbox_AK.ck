Std.srand(2);

IntArrayList Crecord;
Crecord.add(0);Crecord.add(5);Crecord.add(6);Crecord.add(7);
//spork ~ Recording.RecordWav(Crecord, "Recordings/20190801_H0l0_3_op2_FUCK");

61 => float BPM;
(4./BPM) :: minute => dur BarTime;

IntArrayList Creset;
Creset.add(1);
IOU.PlayTrig(Creset);
IntArrayList Cclock;
Cclock.add(0);
IOU.PlayClock(BPM, Cclock) @=> StepPlayer clock;

AK.MakePitchInterpol(5) @=> Interpolator interpH0;
AK.MakePitchInterpol(6) @=> Interpolator interpH1;
AK.MakePitchInterpol(7) @=> Interpolator interpH2;

12 => int ORDER_T;
2 => int ORDER_I;

BarTime / 2 => dur TargetTime;

AK _ak;

<<<"Init AK:", 11, 6>>>;
_ak.Init(11, 6, ORDER_T, ORDER_I);
_ak.SetTransfo0(10,1);

2*BarTime => now;

0 => int count;
while( count < 64 ){
    _ak.UpdateScale0();
	
	Math.random2f(-0.1,0.1) => float rando;
    (interpH0.tick0$PitchHandler).changeFreq(_ak.GetFreqScale0(0), Math.exp(rando)*TargetTime);
	(interpH0.tick0$PitchHandler).changeFreq(_ak.GetFreqScale0(1), TargetTime);
	(interpH0.tick0$PitchHandler).changeFreq(_ak.GetFreqScale0(2), (1+10*rando*rando-rando)*TargetTime);
	
    _ak.ApplyTransfo0();
    
    4*(1+ 1/32*Math.sin(Math.PI*count/128 + 3*Math.PI*rando))*BarTime => now;
	count++;
}


<<<"Init AK:", 11, 0>>>;

_ak.Init(11, 0, ORDER_T, ORDER_I);

_ak.SetTransfo0(10,1);



2*BarTime => now;


0 => count;

while( count < 64 ){
	
	_ak.UpdateScale0();
	
	Math.random2f(-0.1,0.1) => float rando;
	
	(interpH0.tick0$PitchHandler).changeFreq(_ak.GetFreqScale0(0), Math.exp(rando)*TargetTime);
	(interpH0.tick0$PitchHandler).changeFreq(_ak.GetFreqScale0(1), TargetTime);
	(interpH0.tick0$PitchHandler).changeFreq(_ak.GetFreqScale0(2), (1+10*rando*rando-rando)*TargetTime);
	
	
	_ak.ApplyTransfo0();
	
	
	
	4*(1+ 1/32*Math.sin(Math.PI*count/128 + 3*Math.PI*rando))*BarTime => now;
	count++;
	
}



<<<"Init AK:", 7, 0>>>;

_ak.Init(7, 0, ORDER_T, ORDER_I);

_ak.SetTransfo0(10,1);



2*BarTime => now;


0 => count;

while( count < 64 ){
	
	_ak.UpdateScale0();
	
	Math.random2f(-0.1,0.1) => float rando;
	
	(interpH0.tick0$PitchHandler).changeFreq(_ak.GetFreqScale0(0), Math.exp(rando)*TargetTime);
	(interpH0.tick0$PitchHandler).changeFreq(_ak.GetFreqScale0(1), TargetTime);
	(interpH0.tick0$PitchHandler).changeFreq(_ak.GetFreqScale0(2), (1+10*rando*rando-rando)*TargetTime);
	
	
	_ak.ApplyTransfo0();
	
	
	
	4*(1+ 1/32*Math.sin(Math.PI*count/128 + 3*Math.PI*rando))*BarTime => now;
	count++;
	
}


<<<"AK Ended.">>>;
//clock.stop();
