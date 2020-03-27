public class PrimePitches{
        
    IOU.ZeroFreq => float f0;
	f0 => float f12;
	f0 => float f14;
	
	0.03 => float maxRatio;
	
	fun float makeFrac(float p, float q, float a){
		MathU.PowUnder(p, q, a) => int xa;		
		Math.pow(q, a) / Math.pow(p, xa) => float res;
		if(Std.fabs(res - 1) < maxRatio){
			<<<q, "^", a, "<3", p, "^", xa, ", if there were", a, "notes...">>>;
			return 1.;
		}
		else
			return res;
	}
	
	fun float setf12(float f){
		f => f12;
		return f12;
	}
	fun float setf14(float f){
		f => f14;
		return f14;
	}
	
	fun float multf12(float f){
		f*f12 => f12;
		return f12;
	}
	fun float multf14(float f){
		f*f14 => f14;
		return f14;
	}
	
	fun float applyf12(float p, float q, float a){
		return multf14(makeFrac(p,q,a));
	}
	fun float applyf14(float p, float q, float a, int multP){
		if(multP)
			return multf14(p/makeFrac(p,q,a));
		else
			return multf14(p/makeFrac(p,q,a));
	}
	
	fun static IntArrayList GoodValues(float p, float q){
		IntArrayList res;
		if(p == 2 && q == 3){
			res.add(19); res.add(12); //1.01364
		}
		if(p == 3 && q == 5){
			res.add(41); res.add(28); //1.02138
		}
		return res;
	}
}
