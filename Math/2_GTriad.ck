//Short exact sequence T->G->I of G-torsors (group extension)
//GTriad = root+rAction, type+tAction, phi, zeta
public class GTriad{
    
    ESet root;
    ESet type;
    
    BijUnit @ bij;
    
    fun void setBijUnit(GTriad unitTriad){
        BijUnit biju;
        unitTriad @=> biju.unit;
        biju @=> this.bij;
    }
    
    //In reference for now, define copy for GRoot, GType?
    fun static GTriad Make(ESet rt, ESet tp){
        GTriad res;
        rt @=> res.root;
        tp @=> res.type;
        return res;
    }
    fun static GTriad Make(ESet rt, ESet tp, BijUnit bj){
        GTriad.Make(rt, tp) @=> GTriad res;
        bj @=> res.bij;
        return res;
    }
    fun GTriad copy(){return GTriad.Make(root, type, bij);}
      
    fun GTriad lAction(EGroupExt g){
        return bij.groupToSet(g.op(bij.setToGroup(this, g.phi, g.zeta)));
    }
    
    fun GTriad rAction(EGroupExt g){
        return bij.groupToSet(bij.setToGroup(this, g.phi, g.zeta).op(g));
    }
    
    fun void print(){root.print(); type.print();}
    
    fun static ArrayList doLAction(EGroupExt g, ArrayList l){
        ArrayList res;
        for(0 => int i; i < l.size(); i++){
            res.add((l.get(i)$GTriad).lAction(g));
        }
        return res;
    } 
    
    fun static ArrayList doRAction(EGroupExt g, ArrayList l){
        ArrayList res;
        for(0 => int i; i < l.size(); i++){
            res.add((l.get(i)$GTriad).rAction(g));
        }
        return res;
    }
    
    fun GTriad groupToSet(EGroupExt g){
        return bij.groupToSet(g);
    }
    fun EGroupExt setToGroup(ExtFunction phi, ExtFunction zeta){
        return bij.setToGroup(this, phi, zeta);
    }
}

class BijUnit extends UnaryFunction{
    GTriad @ unit;
    
    fun GTriad groupToSet(EGroupExt g){
        GTriad res;
        unit.root.action(g.t) @=> res.root;
        unit.type.action(g.i) @=> res.type;   
        this @=> res.bij;
        return res;
    }
    
    fun EGroupExt setToGroup(GTriad tr, ExtFunction phi, ExtFunction zeta){
        return EGroupExt.Make(tr.root.toGroupSetUnit(unit.root), tr.type.toGroupSetUnit(unit.type), phi, zeta);
    }
}