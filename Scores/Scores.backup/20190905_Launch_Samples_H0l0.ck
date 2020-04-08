//spork~ D_S_GS.SB_AK.arpeggio_20190903(5, 0, Progression, 3., ParamsM.BarTime);
//IntArrayList offChan; offChan.add(5);
//IOU.PlayVolts(-1, offChan);

"20190829_64_Feedback_Piano_0_Nb" => string pre;
"_20190903.wav" => string suf;

IntArrayList chans;
chans.add(3);chans.add(4);chans.add(5);
chans.add(6);chans.add(7);

0.3 => float gainA;
0.3 => float gainB;
8 => float loopALen;
16 => float loopBLen;
20::second => dur durCF;

32 => float nbBeatsStartA;
24 => float nbBeatsStartB;

string files3[5];
"3_ES8-2" => files3[0]; "3_5" => files3[1]; "3_WA1" => files3[2]; 
"3_3+6+10S_L" => files3[3]; "3_3+6+10S_R" => files3[4]; 

string files5[5];
"5_ES8-3" => files5[0]; "5_3" => files5[1]; "5_5+WA1" => files5[2]; 
"5_6+10S_L" => files5[3]; "5_6+10S_R" => files5[4]; 

D_S_GS.SPa.load(pre, files3, suf, 0);
D_S_GS.SPb.load(pre, files5, suf, 0);

D_S_GS.SPa.setLenBeats(loopALen);
D_S_GS.SPb.setLenBeats(loopBLen);

// Intro

D_S_GS.SPa.setStartDur(nbBeatsStartA, D_S_GS.BPM);

D_S_GS.SPa.play();

D_S_GS.SPa.letFinish(1);

MBus.PChanCF12(chans, gainB, durCF)


// Intro B

D_S_GS.SPb.setStartDur(nbBeatsStartB, D_S_GS.BPM);

D_S_GS.SPb.play();


// Part A

D_S_GS.SPb.letFinish(1);

//<<<(now - ParamsM.TimeB)/(1::minute)>>>;

// Part B

//-> Intro

D_S_GS.SPa.play();

D_S_GS.SPa.letFinish(1);

now - ParamsM.TimeA => dur startDurA;
D_S_GS.SPa.setStartDur(startDurA);

D_S_GS.SPa.setLoop(1);

0.5 => gainA;
MBus.PChanCF(chans, gainA, gainB, durCF)

MBus.PChanCF21(chans, gainA, durCF)


// Prep Eb Dorian

D_S_GS.SPb.load(pre, files3, suf, 0);

4 => loopBLen;

D_S_GS.SPb.setLenBeats(loopBLen);

D_S_GS.SPb.setStartDur(8 :: minute);

D_S_GS.SPb.play();
D_S_GS.SPb.setMinDur(2 :: minute);

//<<<(now - ParamsM.TimeA)/(1::minute)>>>;

// Eb Dorian

0.4 => gainB;
MBus.PChanCF12(chans, gainB, durCF)


//MBus.PCutAll(durCF)

//while(1) 1::second => now;
