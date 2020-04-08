public class Cirrus{

  3 => int cloudSize;
  14::second => dur totalPeriod; //>= 4::second

  220. / 2. => float baseFreq;
  1 => float devAmount;
  5 => float harmonic;
  3 => int spreadFromMiddle;
  float maxPanSpeed;

  Event playNext;
  SineCloud cirrus;
  SineCloud amCirrus;
  Pan2G panCirrus;

  Gain outs[2];
  panCirrus.left => outs[0];
  panCirrus.right => outs[1];
  1 => int playing;

  fun void _run(){
    1 => maxPanSpeed;

    cirrus => panCirrus;

    cirrus.size(cloudSize);    
    
    amCirrus.size(cloudSize);
    SqrtFunctor sqrtFun; 3./Math.sqrt(baseFreq) => sqrtFun.factor;

    cirrus.amLink(amCirrus);

    cirrus.stratas[0] => cirrus.outlet;
    cirrus.stratas[1] => cirrus.outlet;
    cirrus.stratas[2] => Envelope aftertouch => cirrus.outlet;
    aftertouch.duration(10::ms); 
    //aftertouch.target();
    // => baseFreq;
    //playNext.broadcast();
    //maxPanSpeed?

    //SinOsc fmS; fmS.freq(baseFreq/3.01); fmS.gain(100); fmS => cirrus.stratas[i];

    while(playing){ 

      cirrus.fillBaseFreqsCirrus_0(baseFreq, harmonic, devAmount);
      cirrus.baseFreqsToStratas(1);

      amCirrus.fillBaseFreqsFrom(cirrus, sqrtFun); 
      amCirrus.baseFreqsToStratas(2);

      panCirrus.speed(0);
      maxPanSpeed/(totalPeriod/(3::second)) => float maxSpeedAbs;
      Math.random2f(-maxSpeedAbs, maxSpeedAbs) => float panSpeed; <<<panCirrus.pan(), panSpeed>>>;

      cirrus.durationAm(50::ms);
      cirrus.appear(0); cirrus.appear(1);
      0.05::second => now;

      cirrus.durationAm(10::second);
      cirrus.appear(2);
      panCirrus.speed(panSpeed);
      spork~ panCirrus._movePan(totalPeriod - 2::second);
      
      amCirrus.stratas[1].fm.gain(-1.5*amCirrus.stratas[1].freq()); //1.5 because of Gen bug
      amCirrus.stratas[2].fm.gain(-1.4*amCirrus.stratas[2].freq());
      amCirrus.stratas[1].keyOnFm(1);
      amCirrus.stratas[2].keyOnFm(1);

      (2 - 0.05)::second => now;
      spork~ cirrus.disappear(0);
      2::second => now;
      
      spork~ cirrus.disappear(1);
      spork~ cirrus.disappear(2);
      (totalPeriod - 4::second - 1::second) => now;
      spork~ panCirrus._movePan(1::second, panCirrus.pan()*Math.fabs(panCirrus.pan())/2.);
      
      playNext => now;
    }

    panCirrus.left =< outs[0];
    panCirrus.right =< outs[1];
    cirrus =< panCirrus;

  }

}
