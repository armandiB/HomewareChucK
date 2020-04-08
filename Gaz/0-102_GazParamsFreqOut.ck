public class GazParamsFreqOut extends GazParamsOut{

    GazParams @ gazParams;

    Step outs[]; //Could have a moveMode with ramping for smoothing
    
    "note" => string valMode; 

    IOU.ZeroFreq => float zeroFreq; //For note valMode

    fun void init(GazParams gz, int dim){
        gz @=> gazParams;
        gz.nbParticules => nbParticules;
        new Step[gz.nbParticules] @=> outs;
        gz.gazParamsOuts << this;
        dimensions.size(0);
        dimensions << dim;
    }

    fun void setValMode(string valmod){
        valmod => valMode;
    }

    fun void update(){
        if(valMode == "note"){
            for(0 => int par; par < nbParticules; par++){
                outs[par].next(zeroFreq*Math.pow(2, gazParams.positions[par][dimensions[0]]));
            }
        }
        if(valMode == "unitOut"){
          for(0 => int par; par < nbParticules; par++){
            outs[par].next(gazParams.positions[par][dimensions[0]]/IOU.OutScaleFactor);
          }
        }
        if(valMode == "unit"){
          for(0 => int par; par < nbParticules; par++){
            outs[par].next(gazParams.positions[par][dimensions[0]]);
          }
        }
    }
}

