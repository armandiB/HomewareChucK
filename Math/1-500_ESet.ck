//Set of roots or types
public class ESet{
    Object e;
    
    fun Object gete(){return e;}
    
    fun pure ESet action(EGroup t); //Simply transitive action
    
    fun pure ESet Make();
    
    fun pure EGroup toGroupSetUnit(ESet unit);
    
    fun pure void print();
}