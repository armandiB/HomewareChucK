public class PrimePitchesPreset extends TypicalPreset{

    fun void prepare(){
		SinGeneralOut sin4 @=> go[4];
		sin4.setFreq(0.5::second/ParamsM.BarTime*5/7);
		sin4.gen.gain(0.025);
	}
	
	SinOsc sin4AM => go[4].gGesture.gAdd;
	sin4AM.freq(0.2::second/ParamsM.BarTime*5/7);

	PrimePitches pp;
	IOU.ZeroFreq/2 => pp.f0;
	
	ParamsM.BarTime / 2 => dur defTargetTime;
	2*ParamsM.BarTime =>  dur defStepTime;
	defTargetTime => dur targetTime;
	3 => int nbCouples;
	int counts[2][2*nbCouples];
	float primes[2][2*nbCouples];
	int goodValue[2*nbCouples];
	int passedMax[2*nbCouples];
	
	2 => primes[0][0]; 3 => primes[1][0]; 5 => primes[1][1]; 7 => primes[1][2];
	for(1 => int i; i < nbCouples; i++)
		primes[1][i-1] => primes[0][i];
	for(0 => int i; i < nbCouples; i++){
		primes[0][i] => primes[1][i+nbCouples];
		primes[1][i] => primes[0][i+nbCouples];
	}
	
	ph12.setFreq(pp.setf12(pp.f0), targetTime);
	ph14.setFreq(pp.setf14(pp.f0), targetTime);
	
	for(0 => int i; i < nbCouples; i++){
		pp.GoodValues(primes[0][i], primes[1][i]) @=> IntArrayList temp;
		if(temp.size() >= 2){
			temp.get(1) => goodValue[i];
			temp.get(0) => goodValue[i+nbCouples];
		}
		else{
			53 => goodValue[i];
			53 => goodValue[i+nbCouples];
		}
	}
	
	fun void launch(){
		for(0 => int i; i < 2*nbCouples - 1; i++){
			while(counts[1][i] > 1 || !passedMax[i])
				step(i, defStepTime);
			step(i, defStepTime, 0, 1);
		    step(i+1, defStepTime, 1, 0);	
		}
		while(counts[1][nbCouples-1] > 0)
				step(nbCouples-1, defStepTime);
		unitFreq(4*defStepTime);
	}
	
	fun void step(int coupleNb, dur stepTime){
		step(coupleNb, stepTime, 0, 0);
	}
	fun void step(int coupleNb, dur stepTime, int no12, int no14){
		targetTime => dur tempTargetTime;
		float p;
		float q;
		primes[0][coupleNb] => p;
		primes[1][coupleNb] => q;

		if(!no12){
			pp.setf12(pp.f0);
			for(0 => int i; i < coupleNb ; i++){
				pp.applyf12(primes[0][i], primes[1][i], counts[0][i]);
				if(coupleNb < nbCouples)
					counts[0][i]++;
				else if(i != coupleNb - nbCouples)
					counts[0][i]--;
			}
			(go[12] $ PitchHandlerGeneralOut).setFreq(pp.applyf12(p, q, counts[0][coupleNb]), targetTime);
			if(coupleNb < nbCouples)
				counts[0][coupleNb]++;
			else
				counts[0][coupleNb]--;
			tempTargetTime => now;
		}
		
		if(!no14){
			pp.setf14(pp.f0);
			for(0 => int i; i < coupleNb ; i++){
				if(counts[1][i] >= 0){
					pp.applyf14(primes[0][i], primes[1][i], counts[1][i], 0);
					countIncr1(i);
				}
			}
			if(counts[1][coupleNb] >= 0){
				(go[14] $ PitchHandlerGeneralOut).setFreq(pp.applyf14(p, q, counts[1][coupleNb], 1), targetTime);
				countIncr1(coupleNb);
			}
			else
				(go[14] $ PitchHandlerGeneralOut).setFreq(pp.f14, targetTime);
			stepTime - tempTargetTime => now;
			modulateTargetTime();
		}
		if(no14){
			tempTargetTime => targetTime;
		}
	}
	
	fun void unitFreq(dur stepTime){
		1.5*targetTime => dur tempTargetTime;
		(go[12] $ PitchHandlerGeneralOut).setFreq(pp.f0, tempTargetTime);
		tempTargetTime => now;
		(go[14] $ PitchHandlerGeneralOut).setFreq(pp.f0, 2*tempTargetTime);
		2*stepTime - tempTargetTime => now;
		modulateTargetTime();
	}
	
	fun void modulateTargetTime(){
		defTargetTime*(1 + Math.sin(Math.PI*(targetTime/defTargetTime - 1)))*(1+Math.tanh(4*CIO.In[7].last())) => targetTime;
	}
	
	fun void countIncr1(int i){
		if(counts[1][i] < goodValue[i]/2 - 1 && !passedMax[i])
			counts[1][i]++;
		else{
			1 => passedMax[i];
			counts[1][i]--;
		}	
		<<<"Going", primes[0][i], primes[1][i], "power", counts[1][i]>>>;
	}
		
}