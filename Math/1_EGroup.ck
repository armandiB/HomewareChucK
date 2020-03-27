public class EGroup
{    
    EGroup @ unit;
    
    fun pure EGroup Make();
    fun pure EGroup copy();
    fun pure EGroup op(EGroup b);
    fun pure int equals(EGroup b);
    fun pure EGroup inv(); //Implement like fillUnit for finite groups?
    
    //Only for finite groups
    fun int fillUnit(){
      this.copy() @=> EGroup prevTemp;
      this.op(this) @=> EGroup temp;
      1 => int order;
      while (!equals(temp)){
          temp.copy() @=> prevTemp;
          op(temp) @=> temp;
          order++;
      }
      prevTemp @=> this.unit;
      return order;
    }
    
    fun EGroup powOp(int n){
        if(n==0){
            if(this.unit==null){this.fillUnit();}
            return this.unit.copy();
        }
        else{
            EGroup res;
            EGroup operator;
            if(n<0){this.inv() @=> operator;}
            else{this.copy() @=> operator;}
            operator @=> res;
            for(1 => int i; i<n; i++){res.op(operator) @=> res;}
            return res;
        }
    }
    
    fun static ArrayList RemoveDuplicates(ArrayList in){
        ArrayList out;
        
        in.iterator() @=> Iterator iteratorIn;
        while (iteratorIn.hasNext())
        {
            iteratorIn.next()$EGroup @=> EGroup nextIn;
            
            out.iterator() @=> Iterator iteratorOut;
            1 => int test;
            while (iteratorOut.hasNext())
                if(nextIn.equals(iteratorOut.next()$EGroup)){0 => test; break;}
            
            if(test){out.add(nextIn);}
            else{<<<"Removed duplicate">>>;}
        }
        return out;    
    }
}
