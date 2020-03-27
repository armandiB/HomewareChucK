//spork~ D_S_GS.SB_AK.arpeggio_20190903(5, 0, Progression, 3., ParamsM.BarTime);

"20190829_64_Feedback_Piano_0_Nb" => string pre;
"_20190903.wav" => string suf;

0.4 => float gainA;
0.4 => float gainB;
8 => float loopALen;
16 => float loopBLen;
20::second => dur durCF;

32 => float nbBeatsStartA;
24 => float nbBeatsStartB;

D_S_GS.SP0a.load(pre+"3_ES8-2"+suf, 0);
D_S_GS.SP1a.load(pre+"3_5"+suf, 0);
D_S_GS.SP2a.load(pre+"3_WA1"+suf, 0);
D_S_GS.SP3a.load(pre+"3_3+6+10S_L"+suf, 0);
D_S_GS.SP4a.load(pre+"3_3+6+10S_R"+suf, 0);

D_S_GS.SP0b.load(pre+"5_ES8-3"+suf, 0);
D_S_GS.SP1b.load(pre+"5_3"+suf, 0);
D_S_GS.SP2b.load(pre+"5_5+WA1"+suf, 0);
D_S_GS.SP3b.load(pre+"5_6+10S_L"+suf, 0);
D_S_GS.SP4b.load(pre+"5_6+10S_R"+suf, 0);

D_S_GS.SP0a.setLenBeats(loopALen);
D_S_GS.SP1a.setLenBeats(loopALen);
D_S_GS.SP2a.setLenBeats(loopALen);
D_S_GS.SP3a.setLenBeats(loopALen);
D_S_GS.SP4a.setLenBeats(loopALen);

D_S_GS.SP0b.setLenBeats(loopBLen);
D_S_GS.SP1b.setLenBeats(loopBLen);
D_S_GS.SP2b.setLenBeats(loopBLen);
D_S_GS.SP3b.setLenBeats(loopBLen);
D_S_GS.SP4b.setLenBeats(loopBLen);

// Intro

D_S_GS.SP0a.setStartDur((nbBeatsStartA/D_S_GS.BPM) :: minute);
D_S_GS.SP1a.setStartDur((nbBeatsStartA/D_S_GS.BPM) :: minute);
D_S_GS.SP2a.setStartDur((nbBeatsStartA/D_S_GS.BPM) :: minute);
D_S_GS.SP3a.setStartDur((nbBeatsStartA/D_S_GS.BPM) :: minute);
D_S_GS.SP4a.setStartDur((nbBeatsStartA/D_S_GS.BPM) :: minute);


now => ParamsM.TimeA;
spork~ D_S_GS.SP0a.play();
spork~ D_S_GS.SP1a.play();
spork~ D_S_GS.SP2a.play();
spork~ D_S_GS.SP3a.play();
spork~ D_S_GS.SP4a.play();


1 => D_S_GS.SP0a.letFinish;
1 => D_S_GS.SP1a.letFinish;
1 => D_S_GS.SP2a.letFinish;
1 => D_S_GS.SP3a.letFinish;
1 => D_S_GS.SP4a.letFinish;



MBus.PChanCF12(3, gainB, durCF)
MBus.PChanCF12(4, gainB, durCF)
MBus.PChanCF12(5, gainB, durCF)
MBus.PChanCF12(6, gainB, durCF)
MBus.PChanCF12(7, gainB, durCF)


// Intro B

//D_S_GS.SP0b.setStartDur((nbBeatsStartB/D_S_GS.BPM) :: minute);
//D_S_GS.SP1b.setStartDur((nbBeatsStartB/D_S_GS.BPM) :: minute);
//D_S_GS.SP2b.setStartDur((nbBeatsStartB/D_S_GS.BPM) :: minute);
//D_S_GS.SP3b.setStartDur((nbBeatsStartB/D_S_GS.BPM) :: minute);
//D_S_GS.SP4b.setStartDur((nbBeatsStartB/D_S_GS.BPM) :: minute);



now => ParamsM.TimeB;
spork~ D_S_GS.SP0b.play();
spork~ D_S_GS.SP1b.play();
spork~ D_S_GS.SP2b.play();
spork~ D_S_GS.SP3b.play();
spork~ D_S_GS.SP4b.play();


// Part A


1 => D_S_GS.SP0b.letFinish;
1 => D_S_GS.SP1b.letFinish;
1 => D_S_GS.SP2b.letFinish;
1 => D_S_GS.SP3b.letFinish;
1 => D_S_GS.SP4b.letFinish;


//<<<(now - ParamsM.TimeB)/(1::minute)>>>;

// Part B

//-> Intro
//Play
//LetFinish


now - ParamsM.TimeA => dur startDurA;
D_S_GS.SP0a.setStartDur(startDurA);
D_S_GS.SP1a.setStartDur(startDurA);
D_S_GS.SP2a.setStartDur(startDurA);
D_S_GS.SP3a.setStartDur(startDurA);
D_S_GS.SP4a.setStartDur(startDurA);

D_S_GS.SP0a.setLoop(1);
D_S_GS.SP1a.setLoop(1);
D_S_GS.SP2a.setLoop(1);
D_S_GS.SP3a.setLoop(1);
D_S_GS.SP4a.setLoop(1);




0.4 => gainA;
MBus.PChanCF(3, gainA, gainB, durCF)
MBus.PChanCF(4, gainA, gainB, durCF)
MBus.PChanCF(5, gainA, gainB, durCF)
MBus.PChanCF(6, gainA, gainB, durCF)
MBus.PChanCF(7, gainA, gainB, durCF)

MBus.PChanCF21(3, gainA, durCF)
MBus.PChanCF21(4, gainA, durCF)
MBus.PChanCF21(5, gainA, durCF)
MBus.PChanCF21(6, gainA, durCF)
MBus.PChanCF21(7, gainA, durCF)


// Prep Eb Dorian

D_S_GS.SP0b.load(pre+"3_ES8-2"+suf, 0);
D_S_GS.SP1b.load(pre+"3_5"+suf, 0);
D_S_GS.SP2b.load(pre+"3_WA1"+suf, 0);
D_S_GS.SP3b.load(pre+"3_3+6+10S_L"+suf, 0);
D_S_GS.SP4b.load(pre+"3_3+6+10S_R"+suf, 0);

4 => loopBLen;

D_S_GS.SP0b.setLenBeats(loopBLen);
D_S_GS.SP1b.setLenBeats(loopBLen);
D_S_GS.SP2b.setLenBeats(loopBLen);
D_S_GS.SP3b.setLenBeats(loopBLen);
D_S_GS.SP4b.setLenBeats(loopBLen);

D_S_GS.SP0b.setStartDur(8 :: minute);
D_S_GS.SP1b.setStartDur(8 :: minute);
D_S_GS.SP2b.setStartDur(8 :: minute);
D_S_GS.SP3b.setStartDur(8 :: minute);
D_S_GS.SP4b.setStartDur(8 :: minute);

spork~ D_S_GS.SP0b.play();
spork~ D_S_GS.SP1b.play();
spork~ D_S_GS.SP2b.play();
spork~ D_S_GS.SP3b.play();
spork~ D_S_GS.SP4b.play();


//<<<(now - ParamsM.TimeA)/(1::minute)>>>;

// Eb Dorian


0.4 => gainB;
MBus.PChanCF12(3, gainB, durCF)
MBus.PChanCF12(4, gainB, durCF)
MBus.PChanCF12(5, gainB, durCF)
MBus.PChanCF12(6, gainB, durCF)
MBus.PChanCF12(7, gainB, durCF)



2 :: minute => dur secDur;
secDur => D_S_GS.SP0b.minDur;
secDur => D_S_GS.SP1b.minDur;
secDur => D_S_GS.SP2b.minDur;
secDur => D_S_GS.SP3b.minDur;
secDur => D_S_GS.SP4b.minDur;


//MBus.PCutAll(durCF)

while(1) 1::second => now;
