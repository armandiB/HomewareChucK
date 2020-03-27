public class AK{
        
    int ORDER_T;
    int ORDER_I;
    ExtFunction phi;
    ExtFunction zeta;
    Nint note0;
    float octave0;
    
    ArrayList triads;
    0 => int posTriads;
    GTriad triad0;
    GScale scale0;
    GScale diatonicScale0;
    GTriad unitTriad;
    EGroupExt transfo0;
    
    fun void Init(int r, int s, int order_t, int order_i){
        order_t => ORDER_T;
        order_i => ORDER_I;
        Nint.MakePhi(r) @=> phi;
        Nint.MakeZeta(s, ORDER_T) @=> zeta;

        Nint.Make(0, ORDER_T) @=> note0;
        5. => octave0;
        
        Nint.Make(0, ORDER_T) @=> Nint startRoot;
        Nint.Make(0, ORDER_I) @=> Nint startType;
        GTriad.Make(startRoot.makeESet(), startType.makeESet()) @=> triad0;
        
        GTriad.Make(Nint.Make(0, ORDER_T).makeESet(), Nint.Make(0, ORDER_I).makeESet()) @=> unitTriad;
        triad0.setBijUnit(unitTriad);
        unitTriad.setBijUnit(unitTriad);
    }
    
    fun void FillTriads(ArrayList couples){
        for(0=> int i; i < couples.size(); i++){
            couples.get(i) $ IntArrayList @=> IntArrayList triadInts;
            GTriad.Make(Nint.Make(triadInts.get(0), ORDER_T).makeESet(), Nint.Make(triadInts.get(1), ORDER_I).makeESet()) @=> GTriad toAdd;
			toAdd.setBijUnit(unitTriad);
			triads.add(toAdd);
        }
        triads.get(0) $ GTriad @=> triad0;
    }
    
    fun void SetTransfo0(int t, int i){
        EGroupExt.Make(Nint.Make(t, ORDER_T), Nint.Make(i, ORDER_I), phi, zeta) @=> transfo0;
    }
    
    fun void UpdateScale0(){
        Nint.GetClassicTriad(triad0) @=> scale0;
        Nint.GetClassicDiatonicScale(triad0) @=> diatonicScale0;
    }
        
    fun void ApplyTransfo0(){
        triad0.rAction(transfo0) @=> triad0;
    }
    
    fun void ApplyTransfoTriads(){
		triads.get(posTriads) $ GTriad @=> triad0;
        triads.set(posTriads, triad0.rAction(transfo0));	    
        (posTriads+1) % triads.size() => posTriads;
    }
    
    fun float GetFreqScale0(int pos){       
        return IOU.ETFreq((scale0.subset.get(pos)$Nint).getIntNote(octave0), ORDER_T);
    }
    
    fun float GetJIFreqTriad0(int pos){       
        IOU.ETFreq((triad0.root.e $ Nint).getIntNote(octave0), ORDER_T) => float rootFreq;
        if(pos == 0)
            return rootFreq;
        if(pos == 2)
            return rootFreq*3/2;
        if(pos == 1)
            if((triad0.type.e $ Nint).getClass() == 0)
                return rootFreq*5/4;
            if((triad0.type.e $ Nint).getClass() == 1)
                return rootFreq*10/9;      
    }
    
    fun float GetCloseFreqClassicDiatonic(int zeroedClass){
        Nint res;
        10000 => int distance;
        for(0 => int i; i < diatonicScale0.subset.size(); i++){
            diatonicScale0.subset.get(i)$Nint @=> Nint currentNint;
            Math.abs(currentNint.getClass() - zeroedClass) => int currentDistance;
            if((currentDistance < distance) || ( (currentDistance == distance) && (Math.random2(0, 1) == 0))){
                currentNint @=> res;
                currentDistance => distance;
            }
        }
        
        return IOU.ETFreq(res.getIntNote(octave0), ORDER_T);
    }
	
}
