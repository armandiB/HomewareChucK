Std.srand(3);

220 => float tuningFreq;

0 => int fullMode;

//spork~ CIO.Tuning(tuningFreq);
//spork~ CIO.Tuning(tuningFreq*3./5*14/9);
//1::minute => now;

/*
int CrecordDac[0];
CrecordDac << ParamsM.DirectOutL << ParamsM.DirectOutR << ParamsM.EffectsOut << ParamsM.ClockOut << ParamsM.RunOut << ParamsM.TBDCVOut << ParamsM.FourierPitchOut << ParamsM.EnvelopeOut;
spork ~ Recording.RecordWavDac(CrecordDac, "20191205_H0l0", 0);
spork ~ Recording.RecordWavAdc([0, 1, 2, 3, ParamsM.EffectsIn, ParamsM.TBDIn, ParamsM.JoystickXIn, ParamsM.JoystickYIn], "20191205_H0l0", 0);
*/

15 => int nbParticules;

220.*3/5*14/9 => float unitFreq;

3::second => dur unitDur; //10::second

float voltsArp[1];
24*4 => int trigDivArp;
0 => float jitterArp;

//SinOsc sO => Gain gO => dac; gO.gain(0.005);

Event next;
BeatPlayer trig;
trig.setBeatTime24(5./4.*unitDur/4);

StepPlayer trigPlayer; 
StepPlayer runPlayer; 
StepPlayer rarePlayer; 
StepPlayer trigOscPlayer; 

if(fullMode){
  trigPlayer.step => dac.chan(ParamsM.ClockOut);
  runPlayer.step => dac.chan(ParamsM.RunOut);
  rarePlayer.step => dac.chan(ParamsM.TBDCVOut);
  trigOscPlayer.step => dac.chan(ParamsM.TBDCVOut2);
}

Gain globalS; globalS.op(3); 
Gain globalSQuad; globalSQuad.op(3); globalSQuad => Gain globalSQuadMix;
globalSQuadMix.gain(0.5); Step globalStepQuad => globalSQuadMix;

if(fullMode){
  globalS => dac.chan(ParamsM.FourierPitchOut);
  globalSQuadMix => dac.chan(ParamsM.EnvelopeOut);
}

0.1 => float progStepVal;
Step progStep => Gain progGain;
progStep.next(0); progGain.gain(progStepVal);
SinOsc progSin => Envelope progEnv => progGain;
Step progOff => progEnv;
progEnv.gain(0.5); progEnv.value(0); globalSQuad => progSin; progEnv.keyOn();

if(fullMode){
  progGain => dac.chan(ParamsM.ProgressionOut); 
}

fun void stepProgression(dur envTime){
  1 + progStep.next() => progStep.next;
  progEnv.value(0); progEnv.keyOn(); progEnv.duration(envTime);
}
fun void stepProgression(){
  stepProgression(15*unitDur);
}

SamplePlayer sp;
if(fullMode){
  sp => dac.chan(ParamsM.RouteOutL);
}
sp.setBeat(trig.beat);
sp.load("Tracks/JI_Sines/20191205_JI_Sines_Piano.wav");
spork~ sp.play();

spork~ trig._playClock();
spork~ trigPlayer.playTrigOnEvent(trig.beat);

spork~ _oscilOutputs();
spork~ _arpAux();

if(fullMode){
  spork~ oscilSine(unitFreq, 5./4.*unitDur, next, 1., 0, 1, 0.5); <<<"1">>>;
  next => now; stepProgression();
  spork~ oscilSine(unitFreq*2/3., 13./12.*unitDur, next, 1., 0, 0, 0.6); <<<"2">>>;
  next => now; 
  spork~ oscilSine(unitFreq/2., 2*unitDur, next, 0., 1, 0, 0.9); <<<"3">>>;
  next => now; stepProgression();
  spork~ oscilSine(unitFreq*5/8., unitDur, next, 0.5, 0, 1, 1.); <<<"4">>>;
  next => now; stepProgression();
  6*unitDur => now; 
  spork~ oscilSine(unitFreq*5/3., 5./6.*unitDur, next, 2./3., 1, 1, 1.); <<<"5">>>;
  next => now; stepProgression();
  spork~ oscilSine(unitFreq*3/5., 4./5.*unitDur, next, Math.sqrt(3./2.), 1, 0, 0.8); <<<"6">>>; 
  next => now; stepProgression();
}
else{
  spork~ oscilSine(unitFreq, 5./4.*unitDur, next, 1., 0, 1, 0.9); <<<"1">>>;
  next => now; stepProgression();
  spork~ oscilSine(unitFreq*2/3., 13./12.*unitDur, next, 1., 0, 0, 1); <<<"2">>>;
  next => now; 
  spork~ oscilSine(unitFreq/2., 2*unitDur, next, 0., 1, 0, 1); <<<"3">>>;
  next => now; stepProgression();
  spork~ oscilSine(unitFreq*5/8., unitDur, next, 0.5, 0, 1, 1.); <<<"4">>>;
  next => now; stepProgression();
  6*unitDur => now; 
  spork~ oscilSine(unitFreq*5/3., 5./6.*unitDur, next, 2./3., 1, 1, 1.); <<<"5">>>;
  next => now; stepProgression();
  spork~ oscilSine(unitFreq*3/5., 4./5.*unitDur, next, Math.sqrt(3./2.), 1, 0, 1); <<<"6">>>; 
  next => now; stepProgression();
}

9*unitDur => now;

9 => nbParticules;
GazParams gazParams;
gazParams.init(nbParticules, 3, 1, 200::samp); 
-30 => gazParams.borders[0][0][0]; 30 => gazParams.borders[0][0][1];
0 => gazParams.borders[0][1][0]; 10 => gazParams.borders[0][1][1];
-0.99 => gazParams.borders[0][2][0]; 0.99 => gazParams.borders[0][2][1];
10 => gazParams.visibleParticulesFactor;

0 => gazParams.globalDevNewPos[0][0];

GazParamsFreqOut freqOut;
freqOut.init(gazParams, 0);
freqOut.setValMode("unit");

GazParamsSpaceOut spaceOut;
spaceOut.init(gazParams, [1, 2]);
Gain mixGazL => Gain gGazL => dac.chan(ParamsM.DirectOutL); gGazL.op(3); Gain mixGazR => Gain gGazR => dac.chan(ParamsM.DirectOutR); gGazR.op(3); 
for(0 => int o; o < spaceOut.outs.size(); o++ ){
  spaceOut.outs[o].left => mixGazL;
  spaceOut.outs[o].right => mixGazR;
}

spork~ gazParams._run();
if(fullMode)
  spork~ _updateParamsGaz(); 

0.000000001 => gazParams.temperatures[0][0];
0.000000001 => gazParams.temperatures[0][1];
0.000000001 => gazParams.temperatures[0][2];

spork~ oscilSineGaz(unitFreq*3/5., 4*unitDur, next, -0.5, 0, 1, 1., 3); <<<"7">>>;

next => now; stepProgression();
spork~ oscilSineGaz(unitFreq*3/2, 1.5*unitDur, next, 0., 1, 1, 0.8, 2); <<<"8">>>;
next => now; stepProgression();
spork~ oscilSineGaz(unitFreq, 2.*unitDur, next, -1., 1, 0, 1., 1); <<<"9">>>;
next => now; stepProgression();

17 => nbParticules;
spork~ oscilSine(unitFreq, unitDur/4., next, -0.99, 0, 0, 1.); <<<"10">>>;
next => now;

SinOsc sinEndF => SinOsc sinEnd => Gain gEnd => dac.chan(ParamsM.DirectOutL); gEnd => dac.chan(ParamsM.DirectOutR); 
if(fullMode)
  gEnd => dac.chan(ParamsM.RouteOutR);
Step sEnd => sinEnd;
gEnd.op(3);
SinOsc gEndSin => gEnd;
sinEndF => gEndSin;
sEnd.next(49./5.*unitFreq);
sinEndF.freq((0.5::second)/(11::second));
sinEndF.gain(2);
sinEnd.gain(0.04);

2*unitDur => now;

0 => gazParams.running;
while(1)
  unitDur => now;

fun void _oscilOutputs(){
  //1
  IOU.FreqToOut(unitFreq*9/28, tuningFreq) => voltsArp[0]; 
  
  next => now; //2

  next => now; //3
  unitDur*10 => now;
  IOU.FreqToOut(unitFreq*9/28*8/9, tuningFreq) => voltsArp[0]; 

  next => now; //4
  unitDur*5 => now;
  IOU.FreqToOut(unitFreq*9./28*5/4, tuningFreq) => voltsArp[0]; 
  24 => trigDivArp;
  voltsArp << IOU.FreqToOut(unitFreq*9./28*5/4, tuningFreq) << IOU.FreqToOut(unitFreq*9./28*5/4, tuningFreq) << IOU.FreqToOut(unitFreq*9./28*5/4*3/4, tuningFreq);

  next => now; //5
  2*unitDur => now;
  voltsArp.size(1);
  0.01 => jitterArp;
  24*12 => trigDivArp;
  voltsArp << IOU.FreqToOut(unitFreq*9./28*5/3*4, tuningFreq);
  3*unitDur => now;
  voltsArp.size(1);
  voltsArp << IOU.FreqToOut(unitFreq*9./28*5/3*8, tuningFreq);
  0.025 => jitterArp;
  IOU.FreqToOut(unitFreq*5/8*16, tuningFreq) => voltsArp[0];
  4*unitDur => now;
  voltsArp << IOU.FreqToOut(unitFreq*9./28*5/4*16, tuningFreq);

  next => now; //6
  0.05 => jitterArp;
  24/3 => trigDivArp;
  float tempfreqs[0];
  tempfreqs << IOU.FreqToOut(unitFreq*9./28*15/8, tuningFreq) << IOU.FreqToOut(unitFreq*9./28*3/2, tuningFreq) << IOU.FreqToOut(unitFreq*9./28, tuningFreq) << IOU.FreqToOut(unitFreq*9./28*9/8, tuningFreq) << IOU.FreqToOut(unitFreq*9./28*4/3, tuningFreq) << IOU.FreqToOut(unitFreq*9./28*7/4, tuningFreq) << IOU.FreqToOut(unitFreq*9./28*7/6, tuningFreq) << IOU.FreqToOut(unitFreq*9./28*5/4, tuningFreq) << IOU.FreqToOut(unitFreq*9./28*5/3, tuningFreq);
  for(0=> int i; i < 18; i++){
     tempfreqs[i%9] + (3 - (i+1)/9)/IOU.OutScaleFactor => voltsArp[i%3];
    unitDur/3 => now;
  }
  0.1 => jitterArp;
  
  next => now; //7
  0.5*unitDur => now;
  2 => trigDivArp;
  0.5*unitDur => now;
  voltsArp[2] - 1 /IOU.OutScaleFactor => voltsArp[1];
  unitDur/4 => now;
  voltsArp.size(2);
  unitDur/4 => now;
  0.2 => jitterArp;
  IOU.FreqToOut(unitFreq*9./28*49/16, tuningFreq) => tempfreqs[7];
  IOU.FreqToOut(unitFreq*9./28*3/2, tuningFreq) => tempfreqs[8];
  for(0=> int i; i < 18; i++){
    tempfreqs[i%9]+(Math.log2(2./3)*(i%3) + 2 - (i+6)/9)/IOU.OutScaleFactor => voltsArp[i%3];
    unitDur/18 => now;
  }
  voltsArp << IOU.FreqToOut(unitFreq, tuningFreq);
  0.007 => jitterArp;
  5 => trigDivArp;

  next => now; //8
  voltsArp.size(2);
  11 => trigDivArp;
  unitDur => now;
  voltsArp.size(1);
  24*4 => trigDivArp;
  unitDur*4 => now;
  IOU.FreqToOut(unitFreq*49/80, tuningFreq) => voltsArp[0];
}
fun void _arpAux(){
  0 => int pos;
  float jit;
  Step stepArp;
  if(fullMode)
    stepArp => dac.chan(ParamsM.OscPitchOut);

  while(1){
    if(pos >= voltsArp.size() )
      0 => pos;
    
    float rand;
    if(fullMode) //TBC not optimized
      adc.chan(ParamsM.JoystickXIn).last() => rand;

    rand*rand*jitterArp*(1-jit) => jit; 
    trig.beatTime*jit => now;
    
    trigOscPlayer.playTrig();
    stepArp.next(voltsArp[pos]);

    pos++;
    for(0 => int i; i < trigDivArp; i++)
      trig.beat => now;
  }
}

fun void oscilSine(float baseFreq, dur oscilTime, Event next, float disAmount, int upDown, int upDownEnd, float sparseFactor){
  nbParticules => int curNbParticules;
  SineBank sineBank;
  sineBank.init(curNbParticules);
  sineBank.setGains(0);


  float freqs[0];
  1 => float mult;
  5 => int modu;
  1 => float mult2;
  for(0 => int i ; i < curNbParticules; i++){
      freqs << baseFreq*mult*mult2 + 0.5*(i%modu)*Math.log(i%modu+mult);
      if(i%modu==1){
        if(modu <= 3)
          (1+ 1/(disAmount+2.+3-modu)) => mult2;
        
        mult + 1 => mult;
        if(modu > 2)
          modu--;
      }
  }
  sineBank.setFreqs(freqs);

  SinOsc s2Quad => SinOsc sQuad => globalSQuad;
  s2Quad.freq(second/oscilTime);
  s2Quad.gain(1.5/Math.PI);
  sQuad.phase(0.25);

  Envelope s2Env;
  s2Env.value(1);
  SinOsc s2 => SinOsc s => Gain gMix => Envelope eMix => Gain g; g.op(3); s => globalS;
  s => s2Env; s2Env => sineBank.gFreqs[0]; s2Env => sineBank.gFreqs[3]; s2 => sineBank.gFreqs[7]; s2Env => sineBank.gFreqs[11]; s2 => sineBank.gGains[14]; sineBank.gGains[14].multMode();
  s2.freq(second/oscilTime);
  s.gain(baseFreq/22);
  s2.gain(1/Math.PI);
  oscilTime => eMix.duration;

  if(fullMode)
    spork~ _updateParamsSine(gMix);

  sineBank => g => dac.chan(ParamsM.DirectOutL); g => dac.chan(ParamsM.DirectOutR); 
  if(fullMode)
    g => dac.chan(ParamsM.RouteOutR);

  BeatPlayer localTrig;
  localTrig.setBeatTime24(oscilTime/4);
  spork~ localTrig._playClock();
  spork~ trig._fade(localTrig, 1.5*oscilTime);
  spork~ runPlayer.playTrigOnOneEvent(trig.done);

  samp => now;
  sineBank.printFreqs();
  float sparseNb;
  eMix.keyOn();
  for(0 => int par; par < curNbParticules; par++){
    par => int realPar;
    if(upDown)
      curNbParticules - par - 1 => realPar;

    if(par == 2)
      0 => localTrig.playing;

    int sparseKeys[0];

    Math.random2f(0, 1)/sparseFactor*par/curNbParticules => sparseNb;
    for(0 => int spi ; spi < Math.floor(sparseNb); spi++){//If I don't find the bug, could have only one fade, permanent, non-zero. Ok.
      int sparseKey;
      if(upDown)
        Math.random2(realPar+1, curNbParticules-1) => sparseKey;
      else
        Math.random2(0, realPar-1) => sparseKey;
      Math.max(sparseNb*Math.random2f(-0.004, 0.004), 0) => float trgGain;
      spork~ sineBank.gGains[sparseKey]._fade(trgGain, sparseNb/par*oscilTime);<<<sparseKey, trgGain>>>;
      sparseKeys << sparseKey;
    }

    sineBank.setGains(realPar, 0.01/(Math.sqrt(0.7*realPar+1)));

    dur sparseOffset;
    0 => int haveSparse;
    if(sparseNb*curNbParticules/par >= 1){
      1 => haveSparse;
      Math.min(par*sparseNb,0.8)*oscilTime => sparseOffset;
    }

    if(par > 3)
      oscilTime*((par+1)%3+1) - sparseOffset  => now;
    else
      oscilTime  -sparseOffset => now;

      for( 0 => int spi; spi < sparseKeys.size(); spi++){
        spork~ sineBank.gGains[sparseKeys[spi]]._fade(sineBank.refGain*0.8*0.01/(Math.sqrt(0.7*sparseKeys[spi]+1)), sparseNb/par*oscilTime);
      }

      if(haveSparse){
        spork~ rarePlayer.playTrig();
        sparseNb*Math.random2f(0.25, 0.37)*oscilTime => eMix.duration;
        eMix.duration() => s2Env.duration;
        s2Env.keyOff();
        eMix.keyOff();
        sparseOffset + 0.5*oscilTime => now;
        eMix.keyOn();
        3*s2Env.duration() => s2Env.duration;
        s2Env.keyOn();
        0.5*oscilTime => now;
      }
  }

  s => Gain gSTri => SawOsc tri => Envelope eTri => gMix;
  gSTri.gain(-0.5);
  oscilTime => eTri.duration;
  Step stepTri => tri;
  stepTri.next(baseFreq);
  tri.gain(0.4);
  eTri.keyOn();
  oscilTime => now;

  next.broadcast();
  3*oscilTime => now;
  eTri.keyOff();
  
  //if(upDown && upDownEnd)
  //  0.5*oscilTime => now;

  for(0 => int par; par < curNbParticules; par++){
    par => int realParEnd;
    if(upDownEnd)
      curNbParticules - par - 1 => realParEnd;
    sineBank.setGains(realParEnd, 0.);
    sineBank.dinit(realParEnd);
    if(par > 3)
      oscilTime*((par+1)%3+1)*0.5 => now;
    else
      oscilTime => now;
  }
}

fun void oscilSineGaz(float baseFreq, dur oscilTime, Event next, float disAmount, int upDown, int upDownEnd, float sparseFactor, int color){
  nbParticules => int curNbParticules;
  SineBank sineBank;
  sineBank.init(curNbParticules);
  sineBank.setGains(0);

  float freqs[0];
  1 => float mult;
  5 => int modu;
  1 => float mult2;
  for(0 => int i ; i < curNbParticules; i++){
      freqs << baseFreq*mult*mult2 + 0.5*(i%modu)*Math.log(i%modu+mult);
      if(i%modu==1 || i%modu == color){
        if(modu <= 3)
          (1+ 1/(disAmount+2.+3-modu)) => mult2;
        
        mult + 1 => mult;
        if(modu > 2)
          modu--;
      }
  }
  sineBank.setFreqs(freqs);

  SinOsc s2Quad => SinOsc sQuad => globalSQuad;
  s2Quad.freq(second/oscilTime);
  s2Quad.gain(1.5/Math.PI);
  sQuad.phase(0.25);

  Envelope s2Env;
  s2Env.value(1);
  SinOsc s2 => SinOsc s => Envelope eMix => gGazL; eMix => gGazR; s => globalS;
  s => s2Env; s2Env => sineBank.gFreqs[0]; s2Env => sineBank.gFreqs[3]; s2 => sineBank.gFreqs[7]; //s2Env => sineBank.gFreqs[11]; s2 => sineBank.gGains[14]; sineBank.gGains[14].multMode();
  s2.freq(second/oscilTime);
  s.gain(baseFreq/22);
  s2.gain(1/Math.PI);
  oscilTime => eMix.duration;

  if(color == 2)
    eMix.gain(0.8);

  freqOut.outs => sineBank.gFreqs; //See SineBank line 16
  for(0 => int o; o < curNbParticules; o++)
    sineBank.gGains[o] => spaceOut.outs[o];

  BeatPlayer localTrig;
  localTrig.setBeatTime24(oscilTime/4);
  spork~ localTrig._playClock();
  spork~ trig._fade(localTrig, 1.5*oscilTime);
  spork~ runPlayer.playTrigOnOneEvent(trig.done);

  samp => now;
  sineBank.printFreqs();
  float sparseNb;
  eMix.keyOn();
  for(0 => int par; par < curNbParticules; par++){
    par => int realPar;
    if(upDown)
      curNbParticules - par - 1 => realPar;

    if(par == 2)
      0 => localTrig.playing;

    int sparseKeys[0];

    Math.random2f(0, 1)/sparseFactor*par/curNbParticules => sparseNb;
    for(0 => int spi ; spi < Math.floor(sparseNb); spi++){//If I don't find the bug, could have only one fade, permanent, non-zero. Ok.
      int sparseKey;
      if(upDown)
        Math.random2(realPar+1, curNbParticules-1) => sparseKey;
      else
        Math.random2(0, realPar-1) => sparseKey;
      Math.max(sparseNb*Math.random2f(-0.004, 0.004), 0) => float trgGain;
      //spork~ sineBank.gGains[sparseKey]._fade(trgGain, sparseNb/par*oscilTime);<<<sparseKey, trgGain>>>;
      sparseKeys << sparseKey;
    }

    gazParams.createParticule(realPar, 0);
    sineBank.setGains(realPar, 0.01/(Math.sqrt(0.7*realPar+1)));

    dur sparseOffset;
    0 => int haveSparse;
    if(sparseNb*curNbParticules/par >= 1){
      1 => haveSparse;
      Math.min(par*sparseNb,0.8)*oscilTime => sparseOffset;
    }

    if(par > 3)
      oscilTime*((par+1)%3+1) - sparseOffset  => now;
    else
      oscilTime  -sparseOffset => now;

      /*
      for( 0 => int spi; spi < sparseKeys.size(); spi++){
        spork~ sineBank.gGains[sparseKeys[spi]]._fade(sineBank.refGain*0.8*0.01/(Math.sqrt(0.7*sparseKeys[spi]+1)), sparseNb/par*oscilTime);
      }
      */

      if(haveSparse){
        spork~ rarePlayer.playTrig();
        sparseNb*Math.random2f(0.25, 0.37)*oscilTime => eMix.duration;
        eMix.duration() => s2Env.duration;
        s2Env.keyOff();
        eMix.keyOff();
        sparseOffset + 0.5*oscilTime => now;
        eMix.keyOn();
        3*s2Env.duration() => s2Env.duration;
        s2Env.keyOn();
        0.5*oscilTime => now;
      }
  }
  
  Step offset => eMix;
  eMix.gain(0.5);
  4*oscilTime => now;
  eMix.gain(1);
  offset.next(0.02);
  next.broadcast();
  
  if(upDown && upDownEnd)
    0.5*oscilTime => now;

  for(0 => int par; par < curNbParticules; par++){
    par => int realParEnd;
    if(upDownEnd)
      curNbParticules - par - 1 => realParEnd;
    sineBank.setGains(realParEnd, 0.);
    sineBank.dinit(realParEnd);
    if(par > 3)
      oscilTime*((par+1)%3+1)*0.25 => now;
    else
      oscilTime*0.5 => now;
  }
}


fun void _updateParamsSine(Gain gmix){
  adc.chan(ParamsM.TBDIn) => blackhole;
  while(1){
    gmix.gain(1.5*adc.chan(ParamsM.TBDIn).last());
    200*samp => now;
  }
}

fun void _updateParamsGaz(){
  adc.chan(ParamsM.JoystickXIn) => blackhole;
  adc.chan(ParamsM.JoystickYIn) => blackhole;
  while(gazParams.running){
    Math.max(0.00000000001, Math.exp((adc.chan(ParamsM.JoystickXIn).last() - 0.5)*10)) => float temp;
    temp*temp => gazParams.temperatures[0][0]; temp => gazParams.temperatures[0][1]; temp => gazParams.temperatures[0][2];
    adc.chan(ParamsM.JoystickYIn).last() => float bord;
    -50*bord => gazParams.borders[0][0][0]; 50*bord => gazParams.borders[0][0][1];
    2 - 2*bord*bord => gazParams.borders[0][1][0]; 5 + 5*bord => gazParams.borders[0][1][1];
    -bord => gazParams.borders[0][2][0]; bord => gazParams.borders[0][2][1];
    200*samp => now;
  }
}

fun void trigMorph(Event trig, dur time0, Event next, float factor, dur time1, Event kill){
  dur step[1];
  time0 => step[0];
  spork~ trigAux(trig, step);
  next => now;
  while(Math.fabs((step[0] - time1)/time1) > 0.001){
    Math.random2f(-1, 1) => float rand;
    step[0] + (time1 - step[0])*factor*rand*rand => step[0];
  }
  time1 => step[0];
  kill => now;
}
fun void trigAux(Event trig, dur step[]){
  while(1){
    trig.broadcast();
    step[0] => now;
  }
}

