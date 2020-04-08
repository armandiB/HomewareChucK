public class CIO{
  static int InSize;
  static int OutSize;

  static float InOffsetVals[];
  static float OutOffsetVals[];

  static Step @ InOffsets[];
  static Step @ OutOffsets[];

  static Gain @ In[];
  static Gain @ Out[];

  static int OffsetsSet;

  fun static void Init(){
    new Step[InSize] @=> InOffsets;
    new Step[OutSize] @=> OutOffsets;
    new Gain[InSize] @=> In;
    new Gain[OutSize] @=> Out;
    new float[InSize] @=> InOffsetVals;
    new float[OutSize] @=> OutOffsetVals;
  }
  
  fun static void SetOffsets(){
  	if(OffsetsSet)
  		return;
  	
    for(0 => int i; i < InSize; i++){
      InOffsetVals[i] => InOffsets[i].next;
      InOffsets[i] => In[i];
      if(InSize > 1)
          adc.chan(i) => In[i];
      else
          adc => In[i];
    }
    
    for(0 => int i; i < OutSize; i++){
      OutOffsetVals[i] => OutOffsets[i].next;
      OutOffsets[i] => Out[i];
      if(OutSize > 1)
          Out[i] => dac.chan(i);
      else
          Out[i] => dac;
    }
	
	1 => OffsetsSet;
  }

fun static void IgnoreIns(int chans[]){
    for(0 => int i; i < chans.size(); i++){
        InOffsets[chans[i]] =< In[chans[i]];
    }
}

fun static void IgnoreOuts(int chans[]){
    for(0 => int i; i < chans.size(); i++){
        OutOffsets[chans[i]] =< Out[chans[i]];
    }
}

  fun static void ReadFile(string path){
    FileIO fio;
    fio.open(path, FileIO.READ);

    if(!fio.good()) {
          <<<"Can't open file:", path, "for calibration!">>>; 
          fio.close();
          return;
    }
    
    0 => int count;
    while(true){
      fio.readLine() => string line;
      if(line == "/")
        break;
      if(count < InOffsetVals.cap())
        Std.atof(line) => InOffsetVals[count];

      count++;
    }
    
    0 => count;
    while(true){
      fio.readLine() => string line;
      if(line == "/")
        break;
      if(count < OutOffsetVals.cap())
        Std.atof(line) => OutOffsetVals[count];

      count++;
    }

    fio.close();
  }

  fun static void WriteOffsets(string path){
    FileIO fio;
    fio.open(path, FileIO.WRITE);

    for(0 => int i; i < InOffsetVals.cap(); i++){
      fio <= InOffsetVals[i] <= IO.newline();
    }
    fio <= "/" <= IO.newline();

    for(0 => int i; i < OutOffsetVals.cap(); i++){
      fio <= OutOffsetVals[i] <= IO.newline();
    }
    fio <= "/" <= IO.newline();

    fio.close();
  }

  fun static void RecordInOffsets(int nbSamp){
    for(0 => int i; i < InOffsetVals.cap(); i++){
      adc.chan(i) => blackhole;
      0 => float mean;
      for(0 => int j; j < nbSamp; j++){
        1::samp => now;
        adc.chan(i).last() +=> mean;
      }
      adc.chan(i) =< blackhole;
      -1 * mean / nbSamp => InOffsetVals[i];
    }
  }

  fun static void RecordOutOffsets(int nbSamp, int begChan, int nbChan){
    for(0 => int i; i < nbChan; i++){
      adc.chan(i) => blackhole;
      Step zero => dac.chan(i+begChan);
      0 => zero.next;

      0 => float mean;
      for(0 => int j; j < nbSamp; j++){
        1::samp => now;
        adc.chan(i).last() +=> mean;
      }
      adc.chan(i) =< blackhole;
      zero =< dac.chan(i+begChan);
      -1 * mean / nbSamp - InOffsetVals[i] => OutOffsetVals[i+begChan];
    }
  }
  
  fun static void Tuning(float f){
  	SinOsc s => dac.chan(0);
  	s.gain(0.25);
  	s.freq(f);
  	while(1) 100::second => now;
  }
}
adc.channels() => CIO.InSize;
dac.channels() => CIO.OutSize;
0 => CIO.OffsetsSet;

CIO.Init();

