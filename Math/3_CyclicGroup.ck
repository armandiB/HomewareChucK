public class Nint extends EGroup
{
    int eqClass;
    int Order;
    
    fun int getOrder() {return Order;}
    fun void setOrder(int val) {val => Order;}
    
    fun int getClass() {return MathU.Mod(eqClass, Order);}
    fun void setClass(int val) {MathU.Mod(val, Order)=> eqClass;}
    
    fun void set(int cls, int order) {order => Order; MathU.Mod(cls, Order) => eqClass;}
    fun static Nint Make(int cls, int order){
        Nint res;
        res.set(cls, order);
        return res;
    }
    
    fun float getIntNote(float octave){
        return eqClass + Order*octave;
    }
        
    fun Nint neg() {
        return Nint.Make(-eqClass, Order);
    }
    
    fun Nint add(Nint b) {
        if(b.getOrder() != Order){
            <<<"Order", Order, "(kept) does not match order", b.getOrder()>>>;
            return null;
            }
            return Nint.Make(eqClass + b.getClass(), Order);            
        }
        
     fun Nint multiply(Nint b) {
        if(b.getOrder() != Order){
            <<<"Order", Order, "(kept) does not match order", b.getOrder()>>>;
            return null;
            }
            return Nint.Make(eqClass * b.getClass(), Order);            
        }
      
     fun Nint invert() {return Nint.Make(MathU.ModInverse(eqClass, Order), Order);}
        
     fun EGroup op(EGroup b){return add(b$Nint);} 
     fun int equals(EGroup b){return (Order==(b$Nint).Order)&&((MathU.Mod(eqClass,Order))==(MathU.Mod((b$Nint).eqClass,(b$Nint).Order)));}   
     fun EGroup inv(){return this.neg();}
     fun EGroup copy(){return Nint.Make(this.eqClass, this.Order);}
     
     fun ArrayList MakeArray(IntArrayList ints, int ord){
        ArrayList out;
        for (0 => int i; i < ints.size(); i++){
                out.add(Nint.Make(ints.get(i), ord));
        }
        return out;
    }
     //Find for any ord formula for approx 4:5:6 ratio and corresponding utonal (60/6:60/5:60/4)
     //Extend to tetrachords (dominant 7th 4:5:6:7)? 
     //Is type group cyclic when extended? Not sure
     fun static GScale GetClassicTriad(GTriad tr){   
         GScale res;
         ESetCyclic.fromESet(tr.root) @=> ESetCyclic rt;
         (tr.root.e $Nint).getOrder() => int ord;
         ord => res.Order;
         
         //Action of Nint as group of rotations on Nint as set of notes
         if(ord == 12){
             res.subset.add(rt.action(Nint.Make(0, ord)).gete());
             
             if((tr.type.e $Nint).getClass() == 1)
                 res.subset.add(rt.action(Nint.Make(3, ord)).gete());
             else
                 res.subset.add(rt.action(Nint.Make(4, ord)).gete());
             
             res.subset.add(rt.action(Nint.Make(7, ord)).gete());
         }
         return res;
     }
     //Define triads as minimally transformed elements by the dual of non-contextual isometries? Should arise from previously-defined objects

      //Minor harmonic for now
      fun static GScale GetClassicDiatonicScale(GTriad tr){   
         GScale res;
         ESetCyclic.fromESet(tr.root) @=> ESetCyclic rt;
         (tr.root.e $Nint).getOrder() => int ord;
         ord => res.Order;
         
         if(ord == 12){
             res.subset.add(rt.action(Nint.Make(0, ord)).gete());
             res.subset.add(rt.action(Nint.Make(2, ord)).gete());
             
             if((tr.type.e $Nint).getClass() == 1)
                 res.subset.add(rt.action(Nint.Make(3, ord)).gete());
             else
                 res.subset.add(rt.action(Nint.Make(4, ord)).gete());
             
             res.subset.add(rt.action(Nint.Make(5, ord)).gete());
             res.subset.add(rt.action(Nint.Make(7, ord)).gete());
             
             if((tr.type.e $Nint).getClass() == 1)
                 res.subset.add(rt.action(Nint.Make(8, ord)).gete());
             else
                 res.subset.add(rt.action(Nint.Make(9, ord)).gete());
             
             res.subset.add(rt.action(Nint.Make(11, ord)).gete());
         }
         return res;
     }
     
     fun ESetCyclic makeESet(){return ESetCyclic.Make(this);}
     
     fun void print(){<<<eqClass, Order>>>;}

     fun static Phi MakePhi(int r){
         Phi phi;
         r => phi.r;
         return phi;
     }
     
     fun static Zeta MakeZeta(int s, int order_t){
         Zeta zeta;
         order_t => zeta.order_t;
         s => zeta.s;
         return zeta;
     }
}

class ESetCyclic extends ESet{
    
    fun Object gete(){return (this.e $Nint);}
    
    fun static ESetCyclic fromESet(ESet el){
        ESetCyclic res;
        (el.e $Nint) @=> res.e;
        return res;
    }
    
    fun ESet action(EGroup t){
        ESetCyclic res;
        (this.e $Nint).op(t) @=> res.e; //As right action
        return res;
    };
    
    fun static ESetCyclic Make(EGroup n){
        ESetCyclic res;
        n.copy() @=> res.e;
        return res;
    };
    fun ESetCyclic Make(int cls, int order){
        ESetCyclic res;
        Nint.Make(cls, order) @=> res.e;
        return res;
    };
 
    fun EGroup toGroupSetUnit(ESet unit){return (unit.e $Nint).inv().op(this.e $Nint);}
    
    fun void print(){(e$Nint).print();}
}

//Presentation of finite metacyclic subgroup (without unicity)
class Phi extends ExtFunction{
    int r;
    fun EGroup evaluate(EGroup i, EGroup t){
        return t.powOp(Math.pow(r,(i$Nint).getClass())$ int);
    }
}

//Only for I=Z2 for now
class Zeta extends ExtFunction{
    int s;
    int order_t;
    fun EGroup evaluate(EGroup i, EGroup j){
        if(((i$Nint).getClass() == 0)||((j$Nint).getClass() == 0))
            return Nint.Make(0, order_t);
        else
            return Nint.Make(1, order_t).powOp(s);
    }
}