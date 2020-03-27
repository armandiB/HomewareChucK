public class IOU{
    static float OutScaleFactor;
    static float ZeroFreq;
    
    //Move to Temperaments
    static float ZeroNote;
    fun static float ETVolts(float note, float nbPitchs){
        return (note - ZeroNote) / nbPitchs; //0V is note 69
    } 
    
    fun static float VoltsToFreq(float v){
        return ZeroFreq * Math.pow(2., v);
    }
    
    fun static float ETFreq(float note, float nbPitchs){
        return VoltsToFreq(ETVolts(note, nbPitchs));
    }
    
    fun static float FreqToOut(float f){
        return Math.log2(f / ZeroFreq) / OutScaleFactor;
    }
    
	fun static StepPlayer PlayVolts(float volts, int channel){
		IntArrayList channels;
		channels.add(channel);
		return PlayVolts(volts, channels);
	}
    fun static StepPlayer PlayVolts(float volts, IntArrayList channel){
        StepPlayer player;
        for (0 => int i; i < channel.size(); i++){
            player.step => MBus.PChan0[channel.get(i)];
        }
        player.setNext(volts/OutScaleFactor);
        spork ~ player.playConst();
        return player;
    }
    
	fun static StepPlayer PlayETNote(int note, int nbPitchs,  int channel){	
		return PlayVolts(ETVolts(note, nbPitchs), channel);
		
	}
    fun static StepPlayer PlayETNote(int note, int nbPitchs,  IntArrayList channel){
        return PlayVolts(ETVolts(note, nbPitchs), channel);
    }
    
	fun static void PlayTrig(int channel){
		IntArrayList channels;
		channels.add(channel);
		PlayTrig(channels);
	}
    fun static void PlayTrig(IntArrayList channel){
        StepPlayer player;        
        for (0 => int i; i < channel.size(); i++){
            player.step => MBus.PChan0[channel.get(i)];
        }
        spork ~ player.playTrig();
    }
    
	
    fun static StepPlayer PlayClock(float bpm, IntArrayList channel){
        return PlayClock(bpm, channel, 1);
        } 
    fun static StepPlayer PlayClock(float bpm, IntArrayList channel, float ppqn){
        StepPlayer player;
        for (0 => int i; i < channel.size(); i++){
            player.step => MBus.PChan0[channel.get(i)];
        }
        (1.0/bpm):: minute => dur timeStep;
        spork ~ player.playClock(timeStep/ppqn);
        return player;
    }
	fun static StepPlayer PlayClock(float bpm, int channel, float ppqn, Event beat){
		IntArrayList channels;
		channels.add(channel);
		return PlayClock(bpm, channels, ppqn, beat);
	}
    fun static StepPlayer PlayClock(float bpm, IntArrayList channel, float ppqn, Event beat){
        StepPlayer player;
        for (0 => int i; i < channel.size(); i++){
            player.step => MBus.PChan0[channel.get(i)];
        }
        (1.0/bpm):: minute => dur timeStep;
        spork~ player.playClock(timeStep/ppqn);
        spork~ BeatEvent(beat, timeStep);
        return player;
    }
    
    fun static void BeatEvent(Event beat, dur timeStep){
        while(true){
            beat.broadcast();
            timeStep => now;
        }
    }
}

69. => IOU.ZeroNote;
10. => IOU.OutScaleFactor;
440. => IOU.ZeroFreq;