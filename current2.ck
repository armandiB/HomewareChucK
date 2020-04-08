Std.srand(3);

int CrecordDac[0];
CrecordDac << 0 << 1 << 2 << 3 << 4 << 5 << 6 << 7;
spork ~ Recording.RecordWavDac(CrecordDac, "20191202_Nice_0");

8 => int nbParticules;

GazParams gazParams;
gazParams.init(nbParticules, 1, 1, samp);
-0.5 => gazParams.borders[0][0][0]; 1.5 => gazParams.borders[0][0][1];
0.1 => gazParams.visibleparticulesFactor;

GazParamsFreqOut freqOut;
freqOut.init(gazParams, 0);
freqOut.setValMode("unit");
//220 => freqOut.zeroFreq;

SineBank sineBank;
sineBank.init(gazParams.nbParticules);

/*
float freqs[0];
for(0 => int i ; i < nbParticules; i++){
    freqs << i * Math.PI / 4.;
}
sineBank.setFreqs(freqs);
Step s => sineBank.oscs[0];
s.next(110);
*/

//freqOut.outs => sineBank.gFreqs; //See SineBank line 16
//sineBank => dac;

freqOut.outs => CIO.Out;

spork~ gazParams._run();
spork~ updateParams();

for(0 => int par; par < nbParticules; par++){
    (10 - par*0.4)::second => now;
    gazParams.createParticule(par, 1);
    sineBank.setGains(par, 0.02);
}

gazParams.done => now;

fun void updateParams(){
  CIO.In[2] => blackhole;
  CIO.In[3] => blackhole;
  while(gazParams.running){
    Math.exp(CIO.In[2].last()*22) => gazParams.temperatures[0][0];
    CIO.In[3].last() => gazParams.borders[0][0][1];
    samp => now;
  }
}

