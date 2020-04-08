public class GazParamsRecOut extends GazParamsOut{

    GazParams @ gazParams;

    LiSa outs[];
    1 => int updateRate;
    0 => int updatePosition;

    fun void init(GazParams gz, int dims[]){
        gz @=> gazParams;
        gz.nbParticules => nbParticules;
        new LiSa[gz.nbParticules] @=> outs;
        gz.gazParamsOuts << this;
        dims @=> dimensions;
    }

    fun void _recordOne(dur duration, int par){
        duration => outs[par].duration;
        outs[par].record(1);
        duration => now;
        outs[par].record(0);
    }

    //Position? Rate?
    //Turn off when hitting border/not alive? Or change direction?
    fun void update(){
        for(0 => int par; par < nbParticules; par++){
            if(updateRate)
                outs[par].rate(gazParams.positions[par][dimensions[0]]);
        }
    }

    fun void transferAudio(int from, int to){
        TransferAudio(outs[from], outs[to]);
    }
    fun static void TransferAudio(LiSa from, LiSa to){
        from.duration() => to.duration;
        for ( 0::samp => dur i; i < from.duration(); i + samp => i ) {
        	(from.valueAt(i), i) => to.valueAt;
        }
    }

}
