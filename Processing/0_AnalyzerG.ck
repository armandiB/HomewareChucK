public class AnalyzerG extends Chubgraph{
    inlet => FFT fft =^ Centroid cent => blackhole;
    fft =^ Flux flux => blackhole;
    fft =^ RMS rms => blackhole;
    
    UAnaBlob fftB;
    UAnaBlob centB;
    UAnaBlob fluxB;
    UAnaBlob rmsB;
    float fft_mags[];
    (1::second)/(1::samp)/2. => float Nyquist;

    2048 => fft.size;
    Windowing.hann(1024) => fft.window;
    Nyquist*2./fft.size() => float binRange;
    <<<"Bins: ", fft.size()/2., binRange, Nyquist>>>;

    [100., 500] @=> float lowerRange[];
    [500., 3000] @=> float midRange[];
    [4000., 6000] @=> float sibRange[];

    1000 => float centThreshold;
    300 => float centTolerance;
    time lastCentSwitchTime;
    2::second => dur minCentSwitchDelay;

    1 => int playing;
    Event _upchuck;
    50::ms => dur refreshTime;

    0 => float rmsEwma;
    200::ms => dur carTimeRmsEwma; 
    float rmsEwmaAlpha;

    0 => float rmsShortEwma;
    50::ms => dur carTimeRmsShortEwma; 
    float rmsShortEwmaAlpha;

    0 => float centEwma;
    150::ms => dur carTimeCentEwma; 
    float centEwmaAlpha;

    0.0004 => float rmsEwmaThresholdUp;
    0.0002 => float rmsEwmaThresholdDown;
    0 => int state;

    0 => int resetState;
    0.5::second => dur resetDelay;
    time resetTime;
    0.0001 => float resetThreshold;

    //Initialization

    int fft_argmax;
    float rmsVal;
    float centVal;
    fun void _run(Event start, Event end){
         Math.exp(- (carTimeRmsEwma/refreshTime)) => rmsEwmaAlpha;
         Math.exp(- (carTimeRmsShortEwma/refreshTime)) => rmsShortEwmaAlpha;
         Math.exp(- (carTimeCentEwma/refreshTime)) => centEwmaAlpha;

        while(playing){ 
            _upchuck => now;
            fft.upchuck() @=> fftB;
            fftB.fvals() @=> fft_mags;
            cent.upchuck() @=> centB;
            flux.upchuck() @=> fluxB;
            rms.upchuck() @=> rmsB;

            MathU.ArgMax(fft_mags) => fft_argmax;

            rmsB.fval(0) => rmsVal;
            rmsShortEwma*(1 - rmsShortEwmaAlpha) + rmsVal*rmsShortEwmaAlpha => rmsShortEwma;

            centB.fval(0)*Nyquist => centVal;
            centEwma*(1 - centEwmaAlpha) + centVal*centEwmaAlpha => centEwma;

            if(rmsShortEwma - rmsEwma > rmsEwmaThresholdUp && !state){
                1 => state;
                0 => resetState;
                start.broadcast();
                <<<"Bing Start">>>;
                <<<centVal, fluxB.fval(0), fft_argmax*binRange, (fft_argmax+1)*binRange, fft_mags[fft_argmax]>>>;
            }
            else if(rmsShortEwma - rmsEwma < - rmsEwmaThresholdDown && state){
                0 => state;
                0 => resetState;
                end.broadcast();
                <<<"Bing End">>>;
                <<<centB.fval(0)*Nyquist, fluxB.fval(0), fft_argmax*binRange, (fft_argmax+1)*binRange, fft_mags[fft_argmax]>>>;
            }
            else if(Math.fabs(rmsShortEwma - rmsEwma) < resetThreshold && state){
                if(resetState){
                    if(now - resetTime > resetDelay){
                        0 => state;
                        <<<"Bing End">>>;
                        0 => resetState;
                    }
                }
                else{
                    1 => resetState;
                    now => resetTime;
                }
            }
            else{
                0 => resetState;
            }
            
            rmsEwma*(1 - rmsEwmaAlpha) + rmsVal*rmsEwmaAlpha => rmsEwma;
            //<<<rmsVal, rmsShortEwma, rmsEwma>>>;
        }
    }

    fun void upchuck(){
        _upchuck.broadcast();
    }

    fun void _centMonitor(Event evDown, Event evUp){
        while(1){
            _upchuck => now;
            if(now - lastCentSwitchTime > minCentSwitchDelay){
                if(centEwma > centThreshold + centTolerance){
                    evUp.broadcast();
                    <<<"Going Happy">>>;
                    now => lastCentSwitchTime;
                }             
                else if(centEwma < centThreshold - centTolerance){
                    evDown.broadcast();
                    <<<"Going Sad">>>;
                    now => lastCentSwitchTime;
                }
            }
                
        }
    }

    fun static int LowerBin(float binRange, float freq){
        return Math.trunc(freq/binRange) $ int;
    }

    fun static int HigherBin(float binRange, float freq){
        return Math.ceil(freq/binRange) $ int;
    }

}

