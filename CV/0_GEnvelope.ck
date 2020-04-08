public class GEnvelope extends Chubgraph{

    Step unit => Envelope env => GenX genX => outlet;
    inlet => env;

    env.gain(0.9997); //because bug GenX

    fun void keyOn(int i){
        env.keyOn(i);
    }

    fun float xValue(float v){
        return env.value(v);
    }
    fun float xValue(){
        return env.value();
    }

    fun dur duration(dur carDur){
        return env.duration(carDur);
    }
    fun dur duration(){
        return env.duration();
    }

    fun void setExp(){
        env =< genX =< outlet;
        new Gen5 @=> genX;
        env => genX => outlet;
        [0., 1., 1.] => genX.coefs;
    }
    fun void setLin(){
        env =< genX =< outlet;
        new Gen7 @=> genX;
        env => genX => outlet;
        [0., 1., 1.] => genX.coefs;
    }
    fun void setCurve(float coefs[]){
        env =< genX =< outlet;
        new CurveTable @=> genX;
        env => genX => outlet;
        coefs => genX.coefs;
    }

}