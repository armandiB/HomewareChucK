public class Chaos{

    fun static FloatArrayList LogisticMap(FloatArrayList in, float k){
        FloatArrayList out;
        in.get(0) => float x;
        out.set(0, k*x*(1-x));
        for(1=>int i; i<in.size(); i++){
            out.set(i, MathU.Modf(x+in.get(i), 1));
        }
        return out;
    }
    fun static FloatArrayList LogisticMap(FloatArrayList in){
        return LogisticMap(in, 4);}
    
    fun static FloatArrayList Lorenz(FloatArrayList in, float sigma, float beta, float rho, float step){
        FloatArrayList out;
        in.get(0) => float x;
        in.get(1) => float y;
        in.get(2) => float z;
        out.set(0, sigma*(y-x)*step + x);
        out.set(1, (x*(rho-z) - y)*step + y);
        out.set(2, (x*y - beta*z)*step + z);
        return out;
    }
    fun static FloatArrayList Lorenz(FloatArrayList in, float sigma, float beta, float rho){
        return Lorenz(in, sigma, beta, rho, 1);}
    
    fun static ArrayList LorenzCriticalPoints(float sigma, float beta, float rho){
        ArrayList out;
        FloatArrayList one;
        one.add(0);one.add(0);one.add(0);
        out.add(one);
        if(beta == 1)
            <<<"Pitchfork Bifurcation">>>;
        if(beta > 1){
            FloatArrayList two;
            FloatArrayList three;
            FloatArrayList stable;
            
            two.add(Math.sqrt(beta*(rho-1)));two.add(Math.sqrt(beta*(rho-1)));two.add(rho-1);
            three.add(-Math.sqrt(beta*(rho-1)));three.add(-Math.sqrt(beta*(rho-1)));three.add(rho-1);
            
            if(rho < sigma*(sigma+beta+3)/(sigma-beta-1))
                stable.add(1);
            else
                stable.add(0);
            
            out.add(two);out.add(three);out.add(stable);
        }
        return out;
    }
    
    fun static complex PolynomialJulia(complex z, int n, complex c, float magLimit){
        if((z $ polar).mag >= magLimit)
            return z;
        #(1,0) => complex out;
        for(0=> int i; i<n; i++){
            out*z => out;
        }
        out + c => out;
        out $ polar => polar outPol;
        if(outPol.mag < magLimit)
            return out;
        else{
            2 => outPol.mag;
            return outPol $ complex;
        }          
    } 
    fun static complex PolynomialJulia(complex z, int n, complex c){
        return PolynomialJulia(z, n, c, 2);}
    
     fun static complex ArnoldCatMap(complex z){
         return #(MathU.Modf(2*z.re + z.im, 1), MathU.Modf(z.re + z.im, 1));
     }
     
     fun static complex BakerMapFolded(complex z){
         z.re => float x;
         z.im => float y;
         if(x < 0.5)
             return #(2*x, y / 2.);
         else
             return #(2-2*x, 1-y/2.);
     }
     
     fun static complex BakerMapUnfolded(complex z){
         z.re => float x;
         z.im => float y;
         return #(2*x- Math.floor(2*x),(y + Math.floor(2*x))/2.);
     }
     
     fun static complex BogdanovMap(complex z, float epsilon, float k, float mu){
         z.re => float x;
         z.im => float y;
         y + epsilon*y + k*x*(x-1) + mu*x*y => float newY;
         return #(x+newY, newY);
     }
     
     fun static float StandardCircleMap(float theta, float omega, float K){
        return theta + omega - K / Math.TWO_PI * Math.sin(Math.TWO_PI*theta);
     }
     
     fun static polar ChirikovStandardMap(polar z, float K){
         z.phase / Math.TWO_PI => float theta;
         theta + z.mag + K / Math.TWO_PI * Math.sin(Math.TWO_PI * theta) => float newTheta;
         return %(newTheta - theta, theta*Math.TWO_PI);
     }
     
     fun static complex DuffingMap(complex z, float a, float b){
         z.re => float x;
         z.im => float y;
         return #(y,-b*x+a*y-y*y*y);
     }
     fun static complex DuffingMap(complex z){
        return DuffingMap(z, 2.75, 0.2);}
        
     fun static complex ExponentialMap(complex z, complex c){
         return MathU.Expc(z) + c;
     }
     
     fun static complex GingerbreadmanMap(complex z){
         z.re => float x;
         z.im => float y;
         return #(1 - y + Std.fabs(x), x);
     }
     
     fun static complex LoziMap(complex z, float a, float b){
         z.re => float x;
         z.im => float y;
         return #(1 - a*Std.fabs(x) + y, b*x);
     }
     fun static complex LoziMap(complex z){
        return LoziMap(z, 1.7, 0.5);}
     
     fun static complex HenonMap(complex z, float a, float b){
         z.re => float x;
         z.im => float y;
         return #(1 - a*x*x + y, b*x);
     }
     fun static complex HenonMap(complex z){
        return HenonMap(z, 1.4, 0.3);}
        
     fun static complex IkedaMap(complex z, float a, float b, float c){
         return a + b*z*MathU.Expc(Math.i*(c + z.re*z.re + z.im*z.im));
     }
     
     fun static complex KaplanYorkMap(complex z, float a){
         z.re => float x;
         z.im => float y;
         return #(MathU.Modf(2*x, 0.99999999999), a*y + Math.cos(4*Math.PI*x));
     }
     
     fun static complex WalkingDroplet(complex z, float mu, float c, float beta){
        z.re => float x;
        z.im => float w;
        (Math.cos(beta)*Math.sin(3*x)+Math.sin(beta)*Math.sin(5*x))/Math.sqrt(Math.PI) => float psix;
        return #(x-c*w*psix, mu*(w+psix));
     }
     
     fun static complex TinkerbellMap(complex z, float a, float b, float c, float d){
         z.re => float x;
         z.im => float y;
         return #(x*x - y*y + a*x + b*y, 2*x*y + c*x + d*y);
     }
     fun static complex TinkerbellMap(complex z){
        return TinkerbellMap(z, 0.9, -0.6013, 2, 0.5);
        //return TinkerbellMap(z, 0.3, 0.6, 2, 0.27);
     }
     
     fun static complex ZaslavskiiMap(complex z, float epsilon, float nu, float r){
         z.re => float x;
         z.im => float y;
         (1 - Math.exp(-r)) / r => float mu;
         return #(MathU.Modf(x + nu*(1+mu*y) + epsilon*nu*mu*Math.cos(Math.TWO_PI*x), 1), Math.exp(-r)*(y + epsilon*Math.cos(Math.TWO_PI*x)));
     }
     fun static complex ZaslavskiiMap(complex z){
        return ZaslavskiiMap(z, 5, 0.2, 2);
     }
     
     fun static complex GOPY(complex z, float sigma, float omega){
         z.re => float x;
         z.im => float theta;
         return #(2*sigma*Math.tanh(x)*Math.cos(Math.TWO_PI*theta), MathU.Modf(theta+omega, 1));
     }
     fun static complex GOPY(complex z){
        return GOPY(z, 1.5, (Math.sqrt(5)-1)/2.);
     }
}