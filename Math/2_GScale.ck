public class GScale //Subset of EGroup
{
    ArrayList subset;
    fun ArrayList getSubset() {return subset;}
    
    int Order;
    fun int getOrder() {return Order;}
    fun void fillOrder(int val) {return;} //TBC (see scale as EGroup with op on subset?)
    
    //TBC implement intervals? (probs in group class)
    
    //TBC implement rotation
    
    fun void set(ArrayList val) {EGroup.RemoveDuplicates(val) @=> subset;}
    
    fun void set(ArrayList vals, int order){
        order => Order;
        set(vals);
    }
    
    fun static GScale Make(ArrayList vals){
        GScale res;
        res.set(vals);
        return res;
    }
    fun static GScale Make(ArrayList vals, int order){
        GScale res;
        order => res.Order;
        res.set(vals);
        return res;
    }
    
    //Unicity-preserving
    fun GScale inter(GScale scl){
        GScale res;

        for(0 => int i; i<subset.size(); i++){
            for(0 => int j; j<scl.subset.size(); j++){
                if((subset.get(i)$EGroup).equals(scl.subset.get(j)$EGroup)){
                    res.subset.add(subset.get(i));
                    break;
                }
            }
        }
        
        if(Order == scl.Order)
            Order => res.Order;
        else
            MathU.Ppcm(Order, scl.Order) => res.Order;
        
        return res;
    }
    
    fun GScale union(GScale scl){
        GScale res;

        for(0 => int i; i<subset.size(); i++){
            1 => int test;
            for(0 => int j; j<scl.subset.size(); j++){
                if((subset.get(i)$EGroup).equals(scl.subset.get(j)$EGroup)){
                    0 => test;
                    break;
                }
            }
            if(test)
                res.subset.add(subset.get(i));
        }
        for(0 => int j; j<scl.subset.size(); j++)
            res.subset.add(scl.subset.get(j));    
        
        if(Order == scl.Order)
            Order => res.Order;
        else
            MathU.Ppcm(Order, scl.Order) => res.Order;
        
        return res;
    }
}

