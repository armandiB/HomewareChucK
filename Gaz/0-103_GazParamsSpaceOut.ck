public class GazParamsSpaceOut extends GazParamsOut{

    GazParams @ gazParams;

    Pan2 outs[]; //For now only stereo

    1 => float distance0; //position = distance0 for doubling of distance
    static float powerDb;

    fun void init(GazParams gz, int dims[]){
        gz @=> gazParams;
        gz.nbParticules => nbParticules;
        new Pan2[gz.nbParticules] @=> outs;
        gz.gazParamsOuts << this;
        dims @=> dimensions;
    }

    //For now suppose 2 dims, distance (0,+inf) and l/r (-1,1)
    fun void update(){
        for(0 => int par; par < nbParticules; par++){
                outs[par].gain(Math.pow(1+gazParams.positions[par][dimensions[0]]/distance0, powerDb));
                outs[par].pan(gazParams.positions[par][dimensions[1]]);
        }
    }
}
-6./20./Math.log10(2) => GazParamsSpaceOut.powerDb;
