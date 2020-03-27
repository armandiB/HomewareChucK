public class SPBundle{
    
    SPArrayList players;
    IntArrayList channels;
    int side;
    0 => int isPlaying;
    Event @ beat;
    time timePlayed;
	
    fun void fillPlayers(int nbPlayers){
        for(0 => int i; i < nbPlayers ; i++){   
            players.add(new SamplePlayer);
        }
    }
    
    fun void setBeat(Event e){
        for(0 => int i; i < players.size() ; i++){
            players.get(i).setBeat(e);
        }
        e @=> beat;
    }
    fun void setBeat(){
        setBeat(ParamsM.Beat);
        ParamsM.Beat @=> beat;
    }
    
    fun void setChans(IntArrayList chans, int sid){
        sid => side;
        chans @=> channels;
        for(0 => int i; i < players.size() ; i++){
            if(sid == 0)
                players.get(i) => MBus.PChan0[chans.get(i)];
            if(sid == 1)
                players.get(i) => MBus.PChan1[chans.get(i)];
            if(sid == 2)
                players.get(i) => MBus.PChan2[chans.get(i)];
        }
    }
    fun void setChans(int begChan, int sid){
        IntArrayList chans;
        for(begChan => int i; i < begChan + players.size(); i++)
            chans.add(i);
        
        setChans(chans, sid);
    }
    
    fun void init(int begChan, int nbPlayers, int sid){
        fillPlayers(nbPlayers);
        setBeat();
        setChans(begChan, sid);
    } 
    
    fun void load(string pre, string files[], string suf, int letFinish){
        for(0 => int i; i < players.size() ; i++){
            players.get(i).load(pre+files[i]+suf, letFinish);
        }
    }
    
    fun void setLenBeats(float loobLen){
        for(0 => int i; i < players.size() ; i++){
            players.get(i).setLenBeats(loobLen);
        }
    }
    
   fun void setStartDur(dur d){
        for(0 => int i; i < players.size() ; i++){
            players.get(i).setStartDur(d);
        }
    }
    fun void setStartDur(float nbBeatsStart, float bpm){
        setStartDur((nbBeatsStart/bpm) :: minute);}
    
    fun void setMinDur(dur d){
        for(0 => int i; i < players.size() ; i++){
            d => players.get(i).minDur;
        }
    }
        
    fun void play(int wait){
        if(!isPlaying){
            1 => isPlaying;
            now => timePlayed;
            
            for(0 => int i; i < players.size() ; i++){
                spork~ players.get(i).play(wait);
            }
            
            while(isPlaying)
                100::ms => now;
                  
            0 => isPlaying;
        }
    }
	fun void play(){
		play(1);
	}
	
    fun void cut(){
        for(0 => int i; i < players.size() ; i++){
            players.get(i).setLoop(0);
            0 => players.get(i).letFinish;
            players.get(i).setLenBeats(0);
            0::samp => players.get(i).minDur;
        }
        
        beat => now;
        for(0 => int i; i < players.size() ; i++){
            players.get(i).fade.keyOff();
        }
        
         0 => isPlaying;
    }
    
    fun void letFinish(int f){
        for(0 => int i; i < players.size() ; i++){
            f => players.get(i).letFinish;
        }
    }
    
    fun void setLoop(int l){
        for(0 => int i; i < players.size() ; i++){
            players.get(i).setLoop(l);
        }
    }
    
    fun void loopFromNow(float loopLenBeats){
        setLoop(1);        
        for(0 => int i; i < players.size() ; i++){
            players.get(i).setStartDurNow(1);
        }
        setLenBeats(loopLenBeats);
    }

    fun void resyncFrom(int player){
      players.get(player) @=> SamplePlayer refP;
      beat => now;
      for(0 => int i; i < players.size() ; i++){
        if(i != player){
          players.get(i).copyFrom(refP);
        }
      }
    }
	
	fun void startPlay(){
		for(0 => int i; i < players.size() ; i++){
			players.get(i).startPlay();
		}
	}
}

class SPArrayList{
    
    ArrayList players;
    
    fun void add(SamplePlayer sp){
        players.add(sp);
    }
    
    fun SamplePlayer get(int i){
        return players.get(i) $ SamplePlayer;
    }
    
    fun void set(int i, SamplePlayer sp){
        players.set(i, sp);
    }
    
    fun int size(){
        return players.size();
    }
}
