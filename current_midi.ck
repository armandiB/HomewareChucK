<<<second/samp>>>;
MidiIn midiIn;
MidiMsg msg;

if ( !midiIn.open(0) ) me.exit();

while( true )
{
    // wait on midi event
    midiIn => now;

    // receive midimsg(s)
    while( midiIn.recv( msg ) )
    {
        // print content
        if(msg.data1 != 248)
    	<<< msg.data1, msg.data2, msg.data3 >>>;
    }
}


