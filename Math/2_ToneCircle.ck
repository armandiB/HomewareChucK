public class EOrbit
{
    EGroup eGroup;
    EGroup @ generator; //generator as reference for dynamic change
    
    fun static EOrbit Make(EGroup egroup, EGroup @ gen){
        EOrbit res;
        egroup @=> res.eGroup;
        gen @=> res.generator;
        return res;
    } 
    
    fun EOrbit copy(){return EOrbit.Make(this.eGroup.copy(), this.generator);}
        
    fun EOrbit next(int times){
        EOrbit res;
        this.eGroup.copy() @=> res.eGroup;
                
        if (times<0) {
            generator.inv() @=> EGroup tempGen;
            for(0=>int i; i < -times;i++){
                res.eGroup.op(tempGen) @=> res.eGroup;
            }
        }
        else if (times>0){
            for(0=>int i; i < times;i++){
                res.eGroup.op(generator) @=> res.eGroup;
            }
        }
        
        this.generator @=> res.generator;
        return res;
    }
    fun EOrbit next(){return next(1);}
       
}