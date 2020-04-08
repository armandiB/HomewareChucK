class SineStrata extends Chubgraph{
  SinOsc osc; osc.sync(2);
  Gain am; am.op(3);
  Gain fm; fm.op(3);

  inlet => fm => osc => am => outlet;

  GEnvelope fmEnv => fm;
  GEnvelope amEnv => am; //For rise shape != fall shape, define 2 GEnvelope if risk of superposition

  //Default values
  fmEnv.duration(1::second); fmEnv.setLin();
  amEnv.duration(5::second); amEnv.setExp();

  Step offsetStep; //offset post gain
  WarpTable warpFm;

  //Event endOfRiseAm;
  //Event startOfFallAm;
  //Event endOfFallAm;

  fun void offsetOn(int i){
    if(i)
      offsetStep => outlet;
    else
      offsetStep =< outlet;
  }
  fun float offset(float v){
      return offsetStep.next(v);
  }
  fun float offset(){
      return offsetStep.next();
  }

  fun void amLink(SineStrata s){
    s.amEnv.xValue(1);
    s.offsetOn(1);
    s => am;
    amEnv => warpFm => s; [2., 1.] => warpFm.coefs;
  }

  fun void keyOnAm(int i){
    amEnv.keyOn(i);
  }
  fun dur durationAm(dur dura){
    return amEnv.duration(dura);
  }
  fun dur durationAm(){
    return amEnv.duration();
  }

  fun void keyOnFm(int i){
    fmEnv.keyOn(i);
  }
  fun dur durationFm(dur dura){
    return fmEnv.duration(dura);
  }
  fun dur durationFm(){
    return fmEnv.duration();
  }
  
  fun float gain(float g){
    return am.gain(g);
  }
  fun float gain(){
    return am.gain();
  }

  fun float freq(float f){
    return osc.freq(f);
  }
  fun float freq(){
    return osc.freq();
  }

}

public class SineCloud extends Chubgraph{

    10 => int _size;
    SineStrata stratas[];

    float baseFreqs[];

    fun int size(int siz){
      siz => _size;
      new SineStrata[siz] @=> stratas;
      new float[siz] @=> baseFreqs;
      for(0 => int i; i < siz; i++)
        inlet => stratas[i];
      return siz;
    }
    fun int size(){
      return _size;
    }

    fun void appear(int i){
      if(!stratas[i].isConnectedTo(outlet))
        stratas[i] => outlet;
      stratas[i].keyOnAm(1);
    }
    fun void disappear(int i){
      stratas[i].keyOnAm(0);
    }
    fun void _disappear100ms(int i){
      stratas[i].keyOnAm(0);
      while(stratas[i].amEnv.last() != 0)
        0.1::second => now;
      stratas[i] =< outlet;
    }
    //appear down-top, top-down, order with modulo

    fun void amLink(SineCloud amCloud){
      MakeLinkIndexes(_size, amCloud._size) @=> IntArrayList idxs;
      for(0 => int i; i < idxs.size(); i++){
          stratas[i].amLink(amCloud.stratas[idxs.get(i)]);
      }
    }

    fun static IntArrayList MakeLinkIndexes(int sizeBase, int sizeLink){ //Could have random rest distribution or euclidian rhythm like
      sizeBase/sizeLink => int k;
      sizeBase % sizeLink => int rest;
      IntArrayList res;
      0 => int i;
      while(i < sizeBase){
        if(i < (k+1)*rest)
          res.add(i/(k+1));
        else
          res.add((i-(k+1)*rest)/k+rest);
        
        i++;
      }
      return res;
    }

    fun dur durationAm(int i, dur dura){
        return stratas[i].durationAm(dura);
      }
    fun dur durationAm(int i){
      return stratas[i].durationAm();
    }
    fun dur durationAm(dur dura){
        for(1 => int i; i < _size; i++)
          stratas[i].durationAm(dura);
        return stratas[0].durationAm(dura);
    }
    fun dur durationFm(int i, dur dura){
        return stratas[i].durationFm(dura);
      }
    fun dur durationFm(int i){
      return stratas[i].durationFm();
    }

    fun float gainStrata(int i, float g){
        return stratas[i].gain(g);
    }
    fun float gainStrata(int i){
        return stratas[i].gain();
    }

    fun void baseFreqsToStratas(int normalizeGain, float gainFactor){
      for(0 => int i ; i < _size; i++)
        baseFreqsToStratas(i, normalizeGain, gainFactor);
    }
    fun void baseFreqsToStratas(int normalizeGain){
      for(0 => int i ; i < _size; i++)
        baseFreqsToStratas(i, normalizeGain);
    }
    fun void baseFreqsToStratas(int i, int normalizeGain, float gainFactor){
      baseFreqs[i] => float freqI;
      stratas[i].freq(freqI);
      if(normalizeGain == 1){
        0.5*gainFactor*Math.log2(1 + baseFreqs[0])/Math.log2(1 + freqI)/_size => float gainI;
        gainStrata(i, gainI);
        <<<i, freqI, gainI>>>;
      }
      else if(normalizeGain == 2){
        gainFactor*Math.log2(1 + baseFreqs[0])/Math.log2(1 + freqI) => float gainI;
        gainStrata(i, gainI);
        <<<i, freqI, gainI>>>;
      }
      else
        <<<i, freqI>>>;
    }
    fun void baseFreqsToStratas(int i, int normalizeGain){
      baseFreqsToStratas(i, normalizeGain, 1.);
    }

    fun void fillBaseFreqsFrom(SineCloud cloud, FloatFunction func){
      MakeLinkIndexes(_size, cloud._size) @=> IntArrayList idxs;
      for(0 => int i; i< _size; i++)
        func.evaluate(cloud.baseFreqs[idxs.get(i)]) => baseFreqs[i];
    }

    fun void fillBaseFreqsCumulus_0(float baseFreq, int modu, float disAmount, float devAmount){
      1 => float mult;
      1 => float mult2;
      for(0 => int i ; i < _size; i++){
          baseFreq*mult*mult2 + 0.5*devAmount*(i%modu)*Math.log(i%modu+mult) => baseFreqs[i];
          if(i%modu==1){
            if(modu <= disAmount + 2)
              (1+ 1/(disAmount+2.+3-modu)) => mult2;
            
            mult + 1 => mult;
            if(modu > 2)
              modu--;
          }
      }
    }

    fun void fillBaseFreqsStratus_0(float baseFreq, int modu, float disAmount, float devAmount){
      1 => float mult;
      1 => float mult2;
      for(0 => int i ; i < _size; i++){
          baseFreq*mult*mult2 + 0.5*devAmount*(i%modu)*Math.log((i%modu+mult)*(disAmount+3)) => baseFreqs[i];
          if(i%modu==((modu - 1 + mult - Math.floor(2*disAmount))%modu)){
            if(modu <= disAmount + 2)
              (1+ 1/(disAmount+2.+3-modu)) => mult2;
            
            mult + 2 => mult;
            if(modu > 2)
              modu--;
          }
      }
    }

    fun void fillBaseFreqsCirrus_0(float baseFreq, float harmonic, float devAmount){
      if(_size > 0)
        baseFreq => baseFreqs[0];

      for(1 => int i ; i < _size; i++){
          baseFreq*harmonic + 0.5*devAmount*i*Math.log(i) => baseFreqs[i];
      }
    }

}


