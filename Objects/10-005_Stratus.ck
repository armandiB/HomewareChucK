public class Stratus{

  10 => int cloudSize;
  28::second => dur totalPeriod; //>= 4::second

  220. / 4. => float baseFreq;
  1 => float disAmount;
  6 => int modu;
  1 => float panRandomAmount;

  1 => int playing;
  Gain outs[2];
  Gain globalGainL => outs[0];
  Gain globalGainR => outs[1];

  0.5 => float eF2;

  SineCloud stratus;
  SineCloud amStratus;

  Pan2G panStratus; panStratus.gain(0.15);
  panStratus.left => globalGainL;
  panStratus.right => globalGainR;
  Gain neg; neg.gain(-1);
  panStratus.left => Gain mid; panStratus.right => mid; mid.gain(0.5);
  panStratus.left => Gain side; panStratus.right => neg => side; side.gain(0.5);

  Gen17 bassCheb; [1., 0.5, 0.3, 0.2] => bassCheb.coefs; bassCheb.gain(0.05);
  bassCheb => globalGainL; bassCheb => globalGainR;
  mid => Gen17 midCheb;  [0.2, 0.5, 0., 0.3] => midCheb.coefs; midCheb.gain(0.2);
  side => Gen17 sideCheb; [1., 0.3, 0.25, 0.125, 0, 0.03, 0.005, 0, 0.1] => sideCheb.coefs; sideCheb.gain(0.3);
  Gain neg2; neg2.gain(-1);
  midCheb => globalGainL; sideCheb => globalGainL;
  midCheb => globalGainR; sideCheb => neg2 => globalGainR;

  Noise fmS; fmS.gain(20); 

  fun void _run(){
    stratus.size(cloudSize);
    stratus.fillBaseFreqsStratus_0(baseFreq, modu, disAmount, 1);
    stratus.baseFreqsToStratas(1);
    
    amStratus.size(cloudSize);
    SqrtFunctor sqrtFun; 0.2/Math.sqrt(baseFreq) => sqrtFun.factor;
    amStratus.fillBaseFreqsFrom(stratus, sqrtFun); 
    amStratus.baseFreqsToStratas(2, 0.2);

    stratus.amLink(amStratus);

    fmS => stratus.stratas[modu-3]; fmS => stratus.stratas[modu-2];

      for(0 => int i ; i < cloudSize; i++){
        if(i != modu - 2 && i < modu){
          stratus.stratas[i] => globalGainL;
          stratus.stratas[i] => globalGainR;
          stratus.stratas[i] => bassCheb;
        }
        else{
          fmS => stratus.stratas[i] => panStratus;
        }
      }

      for(0 => int i; i < cloudSize; i++){ 
        amStratus.stratas[i].fm.gain(-0.9*amStratus.stratas[i].freq()); //1.5 because of Gen bug
        stratus.durationAm(i, 24::second); stratus.durationFm(i, 5::second);

        amStratus.stratas[i].keyOnFm(1);
        stratus.appear(i);
        1::second => now;
        while(eF2 < 0.2)
          200::ms => now;
      }

      //change pan depending on flux/centroid
      while(playing){
        spork~ panStratus._movePan(totalPeriod/2, eF2*(-panStratus.pan()*2 + panRandomAmount*Math.random2f(-0.1, 0.1)));
        (totalPeriod/2)=> now;
      }  
      
      globalGainL =< outs[0];
      globalGainR =< outs[1];
  }

  fun void _killAllExceptFirst(){
    for(cloudSize - 1 => int i ; i > 0; i--){
      spork~ stratus._disappear100ms(i);
      totalPeriod/3 => now;
    }
  }

}
