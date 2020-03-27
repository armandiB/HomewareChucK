// events
Event attacks[10];
dur newstarttime, newlen;
time starttime_real;

// infinite time loop
while( true )
{
    // detect onset
    if( p.last() > threshold )
    {
        // do something
        <<< "attack!; starting voice", voice >>>;
        // play last sample
        if( voice > -1 ) attacks[voice].signal();
        lisa.recPos() => newstarttime;
        now => starttime_real;
        
		// wait for release
        while( p.last() > releaseThresh ) { pollDur => now; }
        <<< "release..." >>>;

		// spork off new sample
		now - starttime_real => newlen;
        lisa.getVoice() => voice;
        if( voice > -1 ) spork ~ playlast( attacks[voice], newstarttime, newlen, rate, voice );
    }
    
    // determines poll rate
    pollDur => now;
}

// sporkee
fun void playlast( Event on, dur starttime, dur len, float newrate, int myvoice ) 
{
	if( newrate == 0. ) 1. => newrate;
    <<< "sporking shred with rate: ", newrate >>>;
    if( rate > 0. ) lisa.playPos( myvoice, starttime );
    else lisa.playPos( myvoice, lisa.recPos() - 1::ms );

    // wait    
    on => now;

    lisa.rate( myvoice, newrate );
    lisa.rampUp( myvoice, 20::ms );

    Std.fabs( newrate ) => float absrate;
    len / absrate => now;
    lisa.rampDown( myvoice, ( 250 / absrate )::ms );
    ( 250 / absrate )::ms => now;
    
    // bye bye shred....
}