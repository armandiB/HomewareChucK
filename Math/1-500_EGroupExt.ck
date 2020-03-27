public class EGroupExt extends EGroup{
    EGroup t;
    EGroup i;
    ExtFunction @ phi; 
    ExtFunction @ zeta; 
    
    //Assumes group T abelian?
    fun EGroupExt op(EGroupExt b){
        return EGroupExt.Make((this.t).op(phi.evaluate(this.i, b.t).op(zeta.evaluate(this.i, b.i))), (this.i).op(b.i), phi, zeta);
    }
    
    fun static EGroupExt Make(EGroup t1, EGroup i1, ExtFunction phi1, ExtFunction zeta1){
        EGroupExt res;
        t1.copy() @=> res.t;
        i1.copy() @=> res.i;
        phi1 @=> res.phi;
        zeta1 @=> res.zeta;
        return res;
    }
    fun EGroup copy(){return EGroupExt.Make(t, i, phi, zeta);}
    
    fun int equals(EGroupExt b){return this.t.equals(b.t)&&this.i.equals(b.i);}
    
}