public class RandomGen{
    
    float spareGaussian;
    0 => int hasSpareGaussian;
    
    fun float generateGaussian(float mean, float stDev){ //Marsaglia polar method, chugin idea: https://bitbucket.org/cdmcfarland/fast_prng/src/default/
    if(stDev == 0){
        return mean;
    }
    if(hasSpareGaussian){
        0 => hasSpareGaussian;
        return spareGaussian * stDev + mean;
    }
    else{
        Math.randomf() * 2 - 1 => float u;
        Math.randomf() * 2 - 1 => float v;
        u*u + v*v => float s;
        while(s >= 1 || s == 0){
            Math.randomf() * 2 - 1 => u;
            Math.randomf() * 2 - 1 => v;
            u*u + v*v => s;
        }
        Math.sqrt(-2.0 * Math.log(s) / s) => s;
        v * s => spareGaussian;
        1 => hasSpareGaussian;
        return mean + stDev * u * s;
    }
}

fun float generateExponential(float mean){
    Math.random2f(0, 1) => float r;
    while(r == 0)
        Math.random2f(0, 1) => r;
    
    return - Math.log(r) * mean;
}

//Marsaglia again
fun float generateGamma(float k, float theta){
    float a;
    if(k >= 1)
        k => a;
    else
        1+k => a;
    
    a - 1/3 => float d;
    a / Math.sqrt(9*d) => float c; //Can set once for a whole series
    
    generateGaussian(0, 1) => float Z;
    Math.random2f(0, 1) => float U;
    (1 + c*Z) => float cubV;
    cubV*cubV*cubV => float V;
    d*V => float dV;
    while(cubV <= 0 || Math.log(U) >= 0.5*Z*Z + d - dV + d * Math.log(V)){
        generateGaussian(0, 1) => Z;
        Math.random2f(0, 1) => U;
        (1 + c*Z) => cubV;
        cubV*cubV*cubV => V;
        d*V => dV;
    }
    
    if(k>=1)
        return theta * dV;
    else
        return theta * (dV * Math.pow(Math.random2f(0, 1), 1/k));
    
}
}