public class ParamsM
{
    static Dummy @ CurrentPath;
    4::second => static dur BarTime;

    static float finalGain;

    static int Transfo0_T;
    static int Transfo0_I;

    static Event @ Beat;
    
    static time TimeA;
    static time TimeB;
	
	fun static void SetCurrentPath(string path){
		Dummy du;
		path => du.dummy;
		du @=> CurrentPath;
	}
	
	fun static string GetCurrentPath(){
		return CurrentPath.dummy;
	}
    
}

class Dummy{
	string dummy;
}
