public class EventBank extends Chubgraph{
    
    Event events[];
    int size;
    
    Event @ waitOnAll;
    int nbSeen;
    
    fun void init(int siz){
        siz => size;
        new Event[siz] @=> events;
    }
    
    fun void _waitOnAll(){
        new Event @=> waitOnAll;
        0 => nbSeen;
        
        for(0 => int i; i < size; i++)
            spork~ _waitOnOne(i);
        
        waitOnAll => now;        
    }
    fun void _waitOnOne(int i){
        events[i] => now;
        nbSeen++;
        if(nbSeen == size)
            waitOnAll.broadcast();
    }
}