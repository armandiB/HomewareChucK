Std.srand(2);

IntArrayList Crecord;
Crecord.add(0);Crecord.add(2);Crecord.add(3);Crecord.add(4);Crecord.add(5);Crecord.add(6);
//spork ~ Recording.RecordWav(Crecord, "Recordings/20190819_Synesthesia");

62 => float BPM;
(4./BPM) :: minute => ParamsM.BarTime;

0 => ParamsM.finalGain;

IntArrayList Cclock;
Cclock.add(0);
IOU.PlayClock(BPM, Cclock, 24) @=> StepPlayer clock;
IntArrayList Creset;
Creset.add(1);

IOU.PlayTrig(Creset);

Sandbox_AK sb_AK;

spork~ sb_AK.sineTriplet_20190819(7, 0, 1, 1, 3., 4, ParamsM.BarTime);
spork~ sb_AK.arpeggio_20190819(11, 6, 6, 1, 3., ParamsM.BarTime);

ParamsM.BarTime => now;

sb_AK.Launch.signal();

while(true) 1::second => now;

//clock.stop();