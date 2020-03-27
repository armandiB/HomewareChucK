MBus.PInit();

IntArrayList CrecordDac;
CrecordDac.add(0);CrecordDac.add(2);
IntArrayList CrecordAdc;
CrecordAdc.add(0);CrecordAdc.add(1);CrecordAdc.add(2);CrecordAdc.add(3);CrecordAdc.add(4);CrecordAdc.add(5);

//spork ~ Recording.RecordWavDac(CrecordDac, "20190905_H0l0");
//spork ~ Recording.RecordWavAdc(CrecordAdc, "20190905_H0l0");

Std.srand(2);

D_S_ Dummy;

35 => Dummy.BPM;
(4./Dummy.BPM) :: minute => ParamsM.BarTime;

spork~ CIO.Tuning(220);

Dummy.main_0();
