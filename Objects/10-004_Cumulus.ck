public class Cumulus{

  16 => int cloudSize;
  14::second => dur totalPeriod; //>= 4::second

  220. / 2. => float baseFreq;
  1 => float disAmount;
  5 => int modu;
  3 => int spreadFromMiddle;

  Event playNext;
  SineCloud cumulus;
  SineCloud amCumulus;
  Pan2G panCumulus;

  fun void _run(){

    cumulus.size(cloudSize);
    cumulus.fillBaseFreqsCumulus_0(baseFreq, modu, disAmount, 1);
    cumulus.baseFreqsToStratas(1);
    cumulus => panCumulus;
    panCumulus.left => dac.chan(0);
    panCumulus.right => dac.chan(1);

    amCumulus.size(cloudSize);
    SqrtFunctor sqrtFun; 3./Math.sqrt(baseFreq) => sqrtFun.factor;
    amCumulus.fillBaseFreqsFrom(cumulus, sqrtFun); 
    amCumulus.baseFreqsToStratas(2);

    cumulus.amLink(amCumulus);

    //SinOsc fmS; fmS.freq(baseFreq/3.01); fmS.gain(100); fmS => cumulus.stratas[i];

    cumulus.size() / 2 - spreadFromMiddle => int intervalNb;

    for(0 => int j; j < cloudSize; j++){ 
      panCumulus.speed(0);
      j/(cloudSize $ float)/(totalPeriod/(3::second)) => float maxSpeedAbs;
      Math.random2f(-maxSpeedAbs, maxSpeedAbs) => float panSpeed; <<<panCumulus.pan(), panSpeed>>>;
      (j )%cloudSize => int i;

      (i + intervalNb) % cloudSize => int i2;
      cumulus.durationAm(i, 50::ms); cumulus.durationAm(i2, 50::ms);
      cumulus.appear(i); cumulus.appear(i2);
      0.05::second => now;

      cumulus.durationAm(i, 10::second); cumulus.durationAm(i2, 10::second);
      panCumulus.speed(panSpeed);
      spork~ panCumulus._movePan(totalPeriod - 2::second);
      
      amCumulus.stratas[i2].fm.gain(-1.5*amCumulus.stratas[i].freq()); //1.5 because of Gen bug
      amCumulus.stratas[i2].keyOnFm(1);

      (2 - 0.05)::second => now;
      spork~ cumulus._disappear100ms(i);
      2::second => now;
      
      spork~ cumulus._disappear100ms(i2);
      (totalPeriod - 4::second - 1::second) => now;
      spork~ panCumulus._movePan(1::second, panCumulus.pan()*Math.fabs(panCumulus.pan())/2.);
      1::second => now;
      playNext => now;
    }

  }

}
