//Cur_Sand.ts._killAllExceptFirst();


//0.2 => Cur_Sand.tc1.disAmount;
//spork~ Cur_Sand.tc1._run();
//
//1 => Cur_Sand.ts.disAmount;
//spork~ Cur_Sand.ts._run();

//Cur_Sand.tc1.playNext.broadcast();

SinOsc tune => dac.chan(10);
tune.gain(0.04);
tune.freq(440);

while(1)
    10::second => now;
