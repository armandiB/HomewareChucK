Std.srand(1);

int CrecordDac[0];
CrecordDac << ParamsM.OscPitchOut << ParamsM.FourierPitchOut << ParamsM.FilterPitchOut << ParamsM.EffectsOut << ParamsM.ClockOut << ParamsM.RunOut << ParamsM.IntensityOut;
int CrecordAdc[0];
CrecordAdc << ParamsM.Alt3In << ParamsM.Alt4In << ParamsM.Mic1In << ParamsM.Mic2In << ParamsM.EffectsIn << ParamsM.ReverbIn << ParamsM.ClockIn << ParamsM.JoystickXIn;

spork ~ Recording.RecordWavDac(CrecordDac, "20191116_RakitClub");
spork ~ Recording.RecordWavAdc(CrecordAdc, "20191116_RakitClub");

D_S_ Dummy;

50 => Dummy.BPM;
(4./Dummy.BPM) :: minute => ParamsM.BarTime;

//spork~ CIO.Tuning(220.0*3/2);
//spork~ CIO.Tuning(277.183);
//spork~ CIO.Tuning(246.94);

D_S_.main_0();
//D_S_.main_22();

//IOU.PlayVolts(- 2./12, ParamsM.OscPitchOut);
