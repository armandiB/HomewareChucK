

//Cur_Sand.ts._killAllExceptFirst();

public class Cur_Sand{
  static Stratus @ ts;
  static Cirrus @ tc1;
  static Cirrus @ tc2;
  //static EnvelopeFollower @ eF1;
  //static EnvelopeFollower @ eF2;
  //BlueBox5?
}

Std.srand(3);

new Stratus @=> Cur_Sand.ts;
new Cumulus @=> Cur_Sand.tc1;

//new EnvelopeFollower @=> Cur_Sand.eF1;
//adc.chan(0) => Cur_Sand.eF1;
//new EnvelopeFollower @=> Cur_Sand.eF2;
//adc.chan(1) => Cur_Sand.eF2;

10 => Cur_Sand.ts.cloudSize;
14::second => Cur_Sand.ts.totalPeriod;
220. / 4. => Cur_Sand.ts.baseFreq;
1 => Cur_Sand.ts.disAmount;
6 => Cur_Sand.ts.modu;

16 => Cur_Sand.tc1.cloudSize;
14::second => Cur_Sand.tc1.totalPeriod; //>= 4::second
220. / 2. => Cur_Sand.tc1.baseFreq;
1 => Cur_Sand.tc1.disAmount;
5 => Cur_Sand.tc1.modu;
3 => Cur_Sand.tc1.spreadFromMiddle;

spork~ Cur_Sand.ts._run();
//spork~ Cur_Sand.tc1._run();

while(1){
  //Cur_Sand.eF1.p.last() => Cur_Sand.tc1.eF1;
  //Cur_Sand.eF2.p.last() => Cur_Sand.ts.eF2;
  20::ms => now;
}
