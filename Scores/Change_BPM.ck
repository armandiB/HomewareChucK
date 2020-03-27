D_S_ Dummy;
0 => int channel;

60 => Dummy.BPM;
(4./Dummy.BPM) :: minute => ParamsM.BarTime;

Dummy.Clock.stop();
IOU.PlayClock(Dummy.BPM, channel, 24, ParamsM.Beat) @=> Dummy.Clock;

while(true) 1::second => now;