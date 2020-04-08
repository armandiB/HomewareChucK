public class ControlG{
  
  static MidiIn @ midiIn;
  static MidiMsg @ msg;

  1 => static int _RunningMidi;

  static EnvelopeFollower @ _EF[];

  fun static int _Midi(int run){
    if(run){
      if(!_RunningMidi)
        while( _RunningMidi )
        {
            if ( !midiIn.open(0) ) me.exit();

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
    }
    else
      0 => _RunningMidi;

      return _RunningMidi;
  }
  fun static int _Midi(){
    return _RunningMidi;
  }

  fun static EnvelopeFollower[] EF(int i){
    new EnvelopeFollower @=> _EF[i];

    return _EF;
  }

}

new MidiIn @=> ControlG.midiIn;
new MidiMsg @=> ControlG.msg;
