Std.srand(2);
//spork ~ Recording.RecordWav(7, "Recordings/20190711_H0l0_2");

//IntArrayList Creset;
//Creset.add(1);
//IOU.PlayTrig(Creset);
//IntArrayList Cclock;
//Creset.add(0);
//IOU.PlayClock(55::ms, Cclock, 24) @=> StepPlayer clock;
//IOU.PlayVolts(-2, 7) @=> StepPlayer const2;

IntArrayList empty;
IntArrayList stereo;
stereo.add(0); stereo.add(1);
IntArrayList Ctriads[4];
stereo @=> Ctriads[0]; empty @=> Ctriads[1]; empty @=> Ctriads[2]; empty @=> Ctriads[3];

440 => TestTriads.MAX_LOOP_COUNT;

<<<"TestTriads:", 0, 7, 3>>>;
TestTriads.TestTriads(0, 7, 3, Ctriads);

<<<"TestTriads:", 2, 7, 3>>>;
TestTriads.TestTriads(2, 7, 3, Ctriads);

220 => TestTriads.MAX_LOOP_COUNT;

<<<"TestTriads:", 6, 11, 3>>>;
TestTriads.TestTriads(6, 11, 3, Ctriads);

<<<"TestTriads:", 0, 11, 3>>>;
TestTriads.TestTriads(0, 11, 3, Ctriads);

200 => TestTriads.MAX_LOOP_COUNT;

<<<"TestTriads:", 0, 11, 7>>>;
TestTriads.TestTriads(0, 11, 7, Ctriads);

170 => TestTriads.MAX_LOOP_COUNT;

<<<"TestTriads:", 0, 7, 7>>>;
TestTriads.TestTriads(0, 7, 7, Ctriads);

880 => TestTriads.MAX_LOOP_COUNT;

<<<"TestTriads last:", 0, 7, 3>>>;
TestTriads.TestTriads(0, 7, 3, Ctriads);

<<<"TestTriads Ended.">>>;
//clock.stop();
while( true ) 1::second => now;
