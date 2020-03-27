//Modulation movement-style, add early reflections feedback?

//* *************************************************************************
//*
//*  Leslie.ck
//*
//*                    Leslie rotating horn
//*
//*  Dopplers for Leslie algorithm in ChucK 
//*  Using DelayL or DelayP (not documented)
//*
//*
//*  NOTES:
//*  This is ChucK code testing STK's DelayL(P) on ChucK.
//*  Max delay time in samples and delay read position (in samples) are function
//*  of sampling rate.
//*  
//*  This program models the upper and lower parts of the Leslie cabinet
//*
//*  Doppler using DelayL lines changing with a growing factor (Hi part)
//*  Low pass filter with changing cutoff frequicies (Lo part).
//*  Use really short decay time for reverb(small room) Nverb.
//*  Needs reverb on lower port.
//*
//*
//*
//*  Tested on ChucK v1.34 
//*
//*  Juanig_at_ccrma_Stanford_EDU
//*  (c) 2007-14
//*
//* 

//signal

SqrOsc sqr =>  Gain gains => blackhole;
gains => DelayL dline1 => blackhole;
gains => DelayL dline2 => blackhole;
gains => DelayL dline3 => blackhole;
gains => DelayL dline4 => blackhole;


dline1 => DelayL reflPath0 => NRev reva => Gain g1 => dac.left;
dline2 => DelayL reflPath1 => NRev revb => Gain g2 => dac.right;
dline3 => DelayL reflPath2 => NRev revc => Gain g3 => dac.left;
dline4 => DelayL reflPath3 => NRev revd => Gain g4 => dac.right;

gains => LPF filtera => Gain gf1 => dac.left;
gains => LPF filterb => Gain gf2 => dac.right; 
gains => LPF filterc => Gain gf3 => dac.left;
gains => LPF filterd => Gain gf4 => dac.right; 


// sample rate
1::second / 1::samp => float srate;


Math.PI => float myPi;
Math.PI*2 => float my2Pi;


// Leslie dimensions
0.18 => float hornRadius;          // radius(mts) 0.18
0.19050 => float baffleRadius;     // lower baffle radius(mts) 15in wooffer
0.71 => float cabinetLen;          // cabinet length
0.52 => float cabinetWid;          // cabinet width

//gain
0.125 => gains.gain;               // Overall input gain


0.1250 => g1.gain;                 // Doppler gain outputs 
0.1250 => g2.gain;
0.1250 => g3.gain;
0.1250 => g4.gain;


0.250 => gf1.gain;                 // LP Filter gain
0.250 => gf2.gain;
0.250 => gf3.gain;
0.250 => gf4.gain;



// REVERB
// ======
0.2 => float T60;


// gain
.75 => reva.gain;
.75 => revb.gain;
.75 => revc.gain;
.75 => revd.gain;

// Mix
0.0125 => reva.mix;
0.0125 => revb.mix;
0.0125 => revc.mix;
0.0125 => revd.mix;


// speed
345.12 => float sspeedmts;         // speed of sound mts/s
4.0 => float speedsl;              // speed of source mt/s (50KPH) => 50000/3600 m/s
//0.3333 => float speedsl;         // Between 0.3333 and 4.0

// Meters to samples
srate / sspeedmts => float m2samp;

// delay lengths:
float maxDopDelay;                 // Maximum delay line length
float startDopDelay;               // starting length of delay line

if (srate == 44100) {
	96 => maxDopDelay;
	48 => startDopDelay;}
if (srate == 48000) {
	104 => maxDopDelay;
	52 => startDopDelay;}

10.0 => float startFreqShift;     // Frequency shift in Hz (for Lo baffle)

maxDopDelay::samp => dline1.max;
maxDopDelay::samp => dline2.max;
maxDopDelay::samp => dline3.max;
maxDopDelay::samp => dline4.max;

startDopDelay => float dshift1;
startDopDelay => float dshift2;
startDopDelay => float dshift3;
startDopDelay => float dshift4;

float fshift1,fshift2,fshift3,fshift4;

startFreqShift*my2Pi => fshift1;  // Frequency shift in radians
startFreqShift*my2Pi => fshift2,fshift3,fshift4;

	
float hornAngVel, baffleAngVel;
float hornAngle, baffleAngle;
0.0 => hornAngle, baffleAngle;       // initial phases of angular motion
	

// Doppler DelayLine incrment

float incr0, incr1, incra,incrb;
0.0 =>  incr0, incr1;
0.0 =>  incra, incrb;

// Reflection variables and array

float xDev, yDev;
float reflectLen[4];	

// Speed
speedsl => hornAngVel;
0.98*speedsl => baffleAngVel;

	
while( true ) {

	// Frequency
	500 => sqr.freq;

	
	my2Pi * hornAngVel/srate +=> hornAngle;
	my2Pi * baffleAngVel/srate +=> baffleAngle;
	
	if (hornAngle > my2Pi) my2Pi -=> hornAngle;
	if (baffleAngle > my2Pi) my2Pi -=> baffleAngle;
	
	-my2Pi*hornRadius*hornAngVel*Math.cos(hornAngle)/sspeedmts => incr0;
	-my2Pi*hornRadius*hornAngVel*Math.sin(hornAngle)/sspeedmts => incr1;

	incr0 -=> dshift1;
	incr1 -=> dshift2;
	-incr0 -=> dshift3;
	-incr1 -=> dshift4;
	
	dshift1::samp => dline1.delay;
	dshift2::samp => dline2.delay;
	dshift3::samp => dline3.delay;
	dshift4::samp => dline4.delay;

	// Reflections
	hornRadius* Math.cos(hornAngle) => xDev;         
	hornRadius* Math.sin(hornAngle) => yDev;         
	(cabinetWid/2 + yDev)*m2samp => reflectLen[0];           // direct path length
	(cabinetLen - xDev)*m2samp => reflectLen[1];             // right wall reflection
	(1.5*(cabinetWid)-yDev)*m2samp => reflectLen[2];         // back wall reflection
	(cabinetLen + xDev)*m2samp => reflectLen[3];             // left wall reflection

	reflectLen[0]::samp => reflPath0.delay;
	reflectLen[1]::samp => reflPath1.delay;
	reflectLen[2]::samp => reflPath2.delay;
	reflectLen[3]::samp => reflPath3.delay;

	// Baffle low port section
	-my2Pi*baffleRadius*baffleAngVel*Math.cos(baffleAngle)/sspeedmts => incra;
	-my2Pi*baffleRadius*baffleAngVel*Math.sin(baffleAngle)/sspeedmts => incrb;
	
	incra -=> fshift1;
	incrb -=> fshift2;
	-incra -=> fshift3;
	-incrb -=> fshift4;

	
	// fshift1*100 => filtera.freq;
	// fshift2*100 => filterb.freq;

	
	fshift1*10+50*my2Pi => filtera.freq;
	fshift2*10+50*my2Pi => filterb.freq;
	fshift3*10+50*my2Pi => filterc.freq;
	fshift4*10+100*my2Pi => filterd.freq;

	
	
	// advance "1" sample.
	1.0::samp => now;

}