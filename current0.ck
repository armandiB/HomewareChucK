Std.srand(1);
1::second => dur beatTime;
5*beatTime => dur totalDurRecording;

XenakeurConics xenC;
xenC.init(totalDurRecording, 90, beatTime);

SinOut sin => Gain sinG => xenC.xenakeur => MBus.PChan0[0];
xenC.xenakeur => MBus.PChan0[1];
XenakeurConics xenC2;
//...

XenakeurConics xenC1;
xenC1.init(totalDurRecording, 80, beatTime);
CIO.In[ParamsM.EffectsIn] => GainGesture xenG1 => xenC1.xenakeur => D_S_.curPreset.go[ParamsM.EffectsOut];
xenG1.gainMode(0.1);

sinG.gain(0.02);
45 => float startFreq;
360 => float endFreq;
sin.setFreq(startFreq);

totalDurRecording / Math.log2(endFreq / startFreq) => dur originalDerivativeInTimePerOctave;

1.2 => float aFactor;//-1.2 => float aFactor; //absolute value is speed factor 
0 => float relativePosHead;
1.5 => float pitchDirectionQueue;

1::second => dur fadeDur;
spork~ xenG1._fade(0.1, fadeDur, "lin");

spork~ xenC1._rec();

totalDurRecording - fadeDur => now;
spork~ xenG1._fade(0, fadeDur, "lin");
//spork~ sin.freqCtrl._fade(endFreq, totalDurRecording, "exp");
//20::second => now;

spork~ xenC1._makeConstantStepParabola(20, 0.1::second, aFactor*1::second, 3.15::second, relativePosHead, originalDerivativeInTimePerOctave);
((3.15)*beatTime + 2*beatTime*1)*0.95 => now;

//sinG =< xenC.xenakeur;
spork~ xenC1._autorec(0.06);
spork~ xenC1._makeConstantStepParabola(50, 0.1::second, 1/aFactor*(-5)::second, 3.75::second, pitchDirectionQueue, originalDerivativeInTimePerOctave);

40::second => now;