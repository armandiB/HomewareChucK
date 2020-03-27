Std.srand(2);

IntArrayList Crecord;
Crecord.add(0);Crecord.add(2);Crecord.add(5);Crecord.add(6);Crecord.add(7);
//spork ~ Recording.RecordWav(Crecord, "Recordings/20190808_Hart_Bar");

113 => float BPM;
(4./BPM) :: minute => ParamsM.BarTime;

0 => ParamsM.finalGain;

IntArrayList Creset;
Creset.add(4);
IOU.PlayTrig(Creset);
IntArrayList Cclock;
Cclock.add(3);
IOU.PlayClock(BPM, Cclock) @=> StepPlayer clock;


spork~ Sandbox_AK.sineTriplet_20190808(7, 0, 10, 1, 3., 4, ParamsM.BarTime);
//spork~ Sandbox_AK.sineAloneMistake(11, 6, 10, 1, 4., 4, ParamsM.BarTime);

ParamsM.BarTime => now;

Sandbox_AK.Launch.broadcast();

while(true) 1::second => now;

//clock.stop();