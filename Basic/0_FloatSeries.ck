public class FloatSeries{
    0 => float value;
    0 => int count;
    FloatArrayList queue;
    0 => int posStartQueue; 
    0 => int posEndQueue;
    
    fun void add(float f){
        queue.size() => int n;
        
        if(n == 0)
            queue.add(f); return;
        
        if((posEndQueue+1)%n == posStartQueue){
            for(0=>int i; i < posStartQueue; i++)
                queue.add(queue.get(i));
            queue.add(f);
            n + posStartQueue => posEndQueue;
        }
        else{
            (posEndQueue+1)%n => posEndQueue;
            queue.set(posEndQueue, f);
        }
    }
    fun void add(FloatArrayList fl){
        for(0=>int i; i< fl.size(); i++)
            add(fl.get(i));
    }
    
    
    fun void step(){
        queue.size() => int n;
        
        if(n == 0)
            <<<"Queue empty!">>>; return;
        
        queue.get(posStartQueue) +=> value;
        count++;
        
        if(posStartQueue == posEndQueue){
            queue.size(0);
            0 => posStartQueue; 
            0 => posEndQueue;
        }
        else
            (posStartQueue+1)%n => posStartQueue;
    }
    fun void step(int k){
        for(0=>int i; i<k; i++)
            step();
    }    
}