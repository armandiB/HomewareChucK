public class ParamsM
{
    static Dummy @ CurrentPath;
    static dur BarTime;

    static float finalGain;

    static int Transfo0_T;
    static int Transfo0_I;

    static Event @ Beat;
    
    static time TimeA;
    static time TimeB;

	//Patch Params
	static int Alt3In;
	static int Alt4In;
	static int Mic1In;
	static int Mic2In;
	//
	static int EffectsIn;
	static int ReverbIn;
	static int ClockIn;
	static int TBDIn;
	static int JoystickXIn;
	static int JoystickYIn;
		
	static int DirectOutL;
	static int DirectOutR;
	static int OscPitchOut;
	static int FourierPitchOut;
	static int EnvelopeOut;
  static int FilterPitchOut;
  static int ProgressionOut;
	static int EffectsOut;
	//
	static int RouteOutL;
	static int RouteOutR;
	static int ClockOut;
	static int RunOut;
	static int IntensityOut; //Speed and agitation
    static int TBDCVOut;
    static int AddAudioOut;
	static int TBDCVOut2;

	static Gain @ gLeftReverb;
	static Gain @ gEffects;

    fun static void SetCurrentPath(string path){
		Dummy du;
		path => du.dummy;
		du @=> CurrentPath;
	}
	
	fun static string GetCurrentPath(){
		return CurrentPath.dummy;
	}
    
}
4::second => ParamsM.BarTime;
new Gain @=> ParamsM.gLeftReverb;
new Gain @=> ParamsM.gEffects;

0 => ParamsM.Alt3In;
1 => ParamsM.Alt4In;
2 => ParamsM.Mic1In;
3 => ParamsM.Mic2In;
//
4 => ParamsM.EffectsIn;
5 => ParamsM.ReverbIn;
6 => ParamsM.ClockIn;
7 => ParamsM.TBDIn;	//From matrix?
8 => ParamsM.JoystickXIn; //Send to spatializer?
9 => ParamsM.JoystickYIn; //Down can move a lot, more Y more sensitive
		
0 => ParamsM.DirectOutL;
1 => ParamsM.DirectOutR;
2 => ParamsM.OscPitchOut;
3 => ParamsM.FourierPitchOut;
4 => ParamsM.EnvelopeOut;
5 => ParamsM.FilterPitchOut;
6 => ParamsM.ProgressionOut;
7 => ParamsM.EffectsOut;
//
8 => ParamsM.RouteOutL;
9 => ParamsM.RouteOutR;
10 => ParamsM.ClockOut;
11 => ParamsM.RunOut;
12 => ParamsM.IntensityOut;
13 => ParamsM.TBDCVOut;
14 => ParamsM.AddAudioOut;
15 => ParamsM.TBDCVOut2;

class Dummy{
	string dummy;
}
