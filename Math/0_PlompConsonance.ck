public class PlompConsonance{
    
    fun static float Plomp(float f1, float f2){
        Math.min(f1, f2) => float fmin;
        Math.max(f1, f2) => float fmax;
        0.24/(0.021*fmin+19.) => float s;
        return (Math.exp(-3.5*s*(fmax-fmin))-Math.exp(-5.75*s*(fmax-fmin)));
    }
    
    fun static float PlompSpectrum(float freqs[][], float amps[][]){
        freqs.size() => int nSpectr;
        freqs[0].size() => int nFreq;
        
        0 => float c;
        for(0=>int i; i<nSpectr; i++){
            for(i+1=>int j; j<nSpectr; j++){
                for(0=>int k; k<nFreq; k++){
                    for(0=>int l; l<nFreq; l++)
                        amps[i][k]*amps[j][l]*Plomp(freqs[i][k], freqs[j][l]) +=> c;
                }
            }
        }
        return c;
    }
    fun static float PlompSpectrum(float freqs[][]){
        float amps[freqs.size()][freqs[0].size()];
        for(0=>int i; i<freqs.size(); i++){
            for(0=>int k; k<freqs[0].size(); k++){
                1 => amps[i][k];
            }
        }
        PlompSpectrum(freqs, amps);
    }
}