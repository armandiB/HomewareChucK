public class SamplePlayer extends Chubgraph{
    SndBuf buffer => ADSR fade => outlet;
    buffer.interp(2);
    500::ms => dur fadeRelease;
    fade.set(20::ms, 0::ms, 1, fadeRelease);
    
    1 => int letFinish;
    float refBpm;
    0 => float lengthInBeats;
    0::samp => dur minDur;
    
    0::samp => dur startDur;
    
    Event start;
    Event beat;
    0 => int beatCount;
    time debut;
    int remainingSamps;
    Event sendEnd;
    0 => int loop;
    
    0 => int runningSecu;
    
    //Replace remainingSamps with better solution. sendEnd?

    fun void setChan(int i){
        i => buffer.channel;
    }

    fun void copyFrom(SamplePlayer refP){
      buffer.pos(refP.buffer.pos());
      refP.loop => loop;
      refP.minDur => minDur;
      refP.debut => debut;
      setLenBeats(refP.lengthInBeats);
      refP.letFinish => letFinish;
      setStartDur(refP.startDur);
      refP.beatCount => beatCount;
      refP.remainingSamps => remainingSamps;
      refP.runningSecu => runningSecu;
    }

    fun void setLenBeats(float f){
        f => lengthInBeats;
    }
    
    fun void setBeat(Event e){
        e @=> beat;
    }       
    fun void setLoop(int i){
        i => loop;
        if(i)
            0::samp => minDur;
    }  
    fun void setStartDur(dur d){
        d => startDur;
    }  
    fun void setStartDurNow(int wait){
      if(wait)  
        beat => now;
        
      buffer.pos()::samp => startDur;
    }  
    fun void startPlay(){
        start.broadcast();
        0 => int beatCount;
    }
    
    //folder with separator at the end
    fun void load(string folder, string file, int letF){
        letF => letFinish;
        folder + file => string path;
        ParseBpmFromFileName(file) => refBpm;
        
        buffer.read(path);
        buffer.samples() => buffer.pos;
        
        if(letFinish){
            buffer.length() => minDur;
        }
        else{
            refBpm * (buffer.length()/(1::minute)) => lengthInBeats;
            <<<"lengthInBeats =", lengthInBeats>>>;
            1 => loop;
        }             
    }
    fun void load(string folder, string file){
        load(folder, file, 1);}
    fun void load(string file){
        load(ParamsM.GetCurrentPath() + "Library/Samples/", file, 1);}
    fun void load(string file, int letF){
        load(ParamsM.GetCurrentPath() + "Library/Samples/", file, letF);}
    
    fun void play(float trgtBpm, int wait){
        if(trgtBpm != refBpm)
            trgtBpm / refBpm => buffer.rate;
        
        if(wait){
            spork~ trigStart();
            start => now;
        }
        now => debut;
        Math.round(startDur / (1::samp)) $ int=> buffer.pos;
        1 => runningSecu;
        fade.keyOn();
        
        debut => time lastBeat;
        while(beatCount <= lengthInBeats || (now - debut) < minDur){
            now => lastBeat;
            beat => now;
            beatCount++;
        }
        lengthInBeats - beatCount + 1 => float beatRemainder;
        if(beatRemainder > 0 && beatRemainder < 1){
            (now - lastBeat)*beatRemainder => now;
        }
        
        buffer.samples() - buffer.pos() => remainingSamps;       
        Math.min(Math.round(fadeRelease/(1::samp)), remainingSamps) $ int=> int nbSampsRelease;
        
        if(!letFinish){
            sendEnd.broadcast();0 => runningSecu;
            if(loop)
                0 => nbSampsRelease;
            fade.keyOff();
            nbSampsRelease::samp => now;
            if(!runningSecu)
                buffer.samples() => buffer.pos;
        }
        else{
            fade.releaseTime(nbSampsRelease::samp);
            while(remainingSamps - nbSampsRelease >= 100){
              remainingSamps - 100 => remainingSamps;
              100::samp => now;
            }
            (remainingSamps - nbSampsRelease)::samp => now;
            fade.keyOff();
            nbSampsRelease::samp => now;
            0 => runningSecu;
            sendEnd.broadcast(); 
        }
        
        if(loop){
            if(remainingSamps == 0)
                play(trgtBpm, 0);
            else
                play(trgtBpm, 1);
        }         
    }
    fun void play(){
        play(refBpm, 1);}
    fun void play(float trgtBpm){
        play(trgtBpm, 1);}
	fun void play(int wait){
		play(refBpm, wait);}
    
    fun void trigStart(){
        beat => now;
        1 => beatCount;
        start.broadcast();
    }
        
    //yyyyMMdd_000-00_name
    fun static float ParseBpmFromFileName(string file){
        string accBpm;
        0 => int saw_;
        for(0 => int i; i < file.length(); i++){
            file.substring(i,1) => string char;
            if(saw_ == 0){
                if(char == "_")
                    1 => saw_;
                continue;
            }
            
            if(char == "_")
                break;
            
            if(char == "-")
                "." +=> accBpm;
            else
                char +=> accBpm;
        }
        return Std.atof(accBpm);
    }
}
