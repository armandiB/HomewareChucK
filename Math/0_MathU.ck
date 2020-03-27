public class MathU{
    // Modulo extended to negative numbers
    fun static int Mod(int a, int b){return (a%b + b) % b;}
    
    fun static float Modf(float a, float b){return (a%b + b) % b;}
    
    // Function for extended Euclidean Algorithm 
    fun static int[] GcdExtended(int a, int b) 
    { 
        int gcd[3];
        if (a == 0) 
        { 
            b => gcd[0], 0 => gcd[1], 1 => gcd[2]; 
            return gcd; 
        } 
        int gcd1[3]; 
        GcdExtended(Mod(b, a), a) @=> gcd1; 
     
        gcd1[0] => gcd[0];
        gcd1[2] - (b/a) * gcd1[1] => gcd[1]; 
        gcd1[1] => gcd[2]; 
        return gcd; 
    }

    fun static int Ppcm(int a, int b){
        return a * b / GcdExtended(a, b)[0];
    }
    
    // Function to find modulo inverse of a 
    fun static int ModInverse(int a, int m) 
    { 
        a => int a1;
        if(a<0){
            while(a1<0){Math.abs(m) +=> a1;}
        }
        
        int gcd[3]; 
        GcdExtended(a1, m) @=> gcd;
        if (gcd[0] != 1) {
            <<<"Inverse doesn't exist", a, m>>>; 
            return 0;
        }
        else
        { 
            return Mod(gcd[1], m);
        } 
    } 
    
    fun static int CheckConsistentFiniteMetacyclic(int n, int m, int s, int r){
        return ((Math.pow(r,m) $ int)%n == 1)&&((s*(r-1))%n == 0);
    }
    
    fun static ArrayList ListConsistentFiniteMetacyclicReps(int n, int m){
        <<<"List extensions:">>>;
        ArrayList res;
        for(0 => int s; s<n; s++){
            for(1 => int r; r<n; r++){
                int rep[2];
                if((r!=1 || s<2)&&CheckConsistentFiniteMetacyclic(n, m, s, r)){
                    s => rep[0];
                    r => rep[1];
                    res.add(rep);
                    <<<rep[0], rep[1]>>>;
                }
            } 
        } 
        <<<"List extensions done">>>;
        return res;
    }
    
    fun static complex Expc(complex z){
        %(Math.exp(z.re), z.im) => polar out;
        return out $ complex;
    }
	
	fun static int PowUnder(float p, float q, float a){
		if(a == 0)
			return 0;
		return (Math.ceil(a*Math.log(q)/Math.log(p)) - 1) $ int;
	}
}