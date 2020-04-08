class WordBuffer extends Chubgraph{

    inlet => LiSa buffer => outlet;
    30::second => dur bufferDur;
    buffer.duration(bufferDur);
    100::ms => dur rampUpDur;
    500::ms => dur rampDownDur;

    100::ms => dur startDelay;
    200::ms => dur endDelay;

    for(0 => int i; i < buffer.maxVoices(); i++)
      buffer.loop(i, 1);

    buffer.loopRec(1);

    fun void _start(Event startWord, Event endWord){
      buffer.record(1);

      while(1){
        startWord => now;
        spork~ _playWord(endWord);
      }
    }

    fun void _playWord(Event endWord){
        buffer.getVoice() => int nextVoice;
        (buffer.recPos() - startDelay) % bufferDur => dur playPos;
        buffer.playPos(nextVoice, playPos);
        buffer.rampUp(nextVoice, rampUpDur);
        endWord => now;
        endDelay => now;
        buffer.rampDown(nextVoice, rampDownDur);
    }

}

class Crossfader extends Chubgraph{
  Gain ins[2];
  ins[0] => Envelope e0 => outlet;
  ins[1] => Envelope e1 => outlet;

  fun void duration(dur dura){
    e0.duration(dura);
    e1.duration(dura);
  }

  fun void ramp(float val){
    e0.target(1 - val);
    e1.target(val);
  }

  fun void _runTarget(Event go, float value, dur delay){
    while(1){
      go => now;
      delay => now;
      ramp(value);
    }
  }

}

AnalyzerG analyzer;
adc => analyzer;

0.0005 => analyzer.rmsEwmaThresholdUp;
0.00015 => analyzer.rmsEwmaThresholdDown;
100::ms => analyzer.carTimeRmsEwma;
50::ms => analyzer.carTimeRmsShortEwma;

adc => WordBuffer wordBuffer => Delay delay => Gain wordOut;

SPBundle tracks;
tracks.fillPlayers(3);

"Tracks/Hack/20200222_60_EMH_" => string pre;
".wav" => string suf;
string files[3];
"Sad" => files[0]; "Neutral" => files[1]; "Happy" => files[2];
tracks.load(pre, files, suf, 0);

Gain tracksOut => dac;
tracksOut.gain(0.2);

tracks.load(pre, files, suf, 0);
tracks.setLoop(1);

SinOsc amRate => SinOsc am => Gain offsetGain => Gain sinAM;
Step offset => offsetGain;
am.sync(3);
am.gain(0.2);
am.freq(2);
amRate.freq(0.1);
amRate.gain(3);
SinOsc sinTrack => sinAM;
sinAM.op(3); sinAM.gain(0.2);

Crossfader crossNeutral => tracksOut;
crossNeutral.duration(5::second);
tracks.players.get(1) => crossNeutral.ins[1];

Crossfader crossHS => crossNeutral.ins[0];
crossHS.duration(0.9::second);
tracks.players.get(2) => crossHS.ins[1];
tracks.players.get(0) => crossHS.ins[0];

Crossfader crossLast => tracksOut;
crossLast.duration(1::second);
sinAM => crossLast.ins[0];
wordOut => crossLast.ins[1];

1::second => dur delayTime;
delay.max(2::second);
delay.delay(delayTime);

Event startWord;
Event endWord;
Event goHappy;
Event goSad;

spork~ analyzer._run(startWord, endWord);
spork~ analyzer._centMonitor(goSad, goHappy);

spork~ wordBuffer._start(startWord, endWord);

spork~ crossLast._runTarget(startWord, 1, 0::second);
spork~ crossLast._runTarget(endWord, 0, 4::second);

spork~ crossHS._runTarget(goHappy, 0.9, 0::second);
spork~ crossHS._runTarget(goSad, 0.1, 0::second);

spork~ tracks.play(0);

crossNeutral.ramp(0);

while(1){
  50::ms => now;
  analyzer.upchuck();
}
