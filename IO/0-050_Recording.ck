public class Recording{

    fun static void RecordWavDac(int chans[], string fileName){
        RecordWavDac(chans, fileName, 1);
    }
    fun static void RecordWavDac(int chans[], string fileName, int useCIO){

        Gain g[chans.size()];
        WvOut w[chans.size()];
        for(0 => int i; i<chans.size(); i++){
            chans[i] => int ch;
            if(useCIO)
                CIO.Out[ch] => g[i] => w[i] => blackhole;
            else
                dac.chan(ch) => g[i] => w[i] => blackhole;
            0.5 => g[i].gain;
            ParamsM.GetCurrentPath() + "Recorded/" + fileName + "_" + now/1::second + "_dac_" + ch + ".wav" => w[i].wavFilename;
            null @=> w[i];
        }
        
        <<< "Writing", chans, "dac channel(s) to file", fileName>>>;
        
        while( true ) 1::second => now;
    }
	fun static void RecordWavDac(int nbChan, string fileName){
		int chans[nbChan];
		for(0 => int i; i < nbChan; i++)
			 i => chans[i];
		RecordWavDac(chans, fileName);
	}
    
    fun static void RecordWavAdc(int chans[], string fileName){
        RecordWavAdc(chans, fileName, 1);
    }
    fun static void RecordWavAdc(int chans[], string fileName, int useCIO){
        
        Gain g[chans.size()];
        WvOut w[chans.size()];	
        for(0 => int i; i<chans.size(); i++){
            chans[i] => int ch;	
            if(useCIO)
                CIO.In[ch] => g[i] => w[i] => blackhole;
            else
                adc.chan(ch) => g[i] => w[i] => blackhole;	
            0.5 => g[i].gain;	
            ParamsM.GetCurrentPath() + "Recorded/" + fileName + "_" + now/1::second + "_adc_" + ch + ".wav" => w[i].wavFilename;	
            null @=> w[i];	
        }
        
        <<< "Writing", chans, "adc channel(s) to file", fileName>>>;
        
        while( true ) 1::second => now;
    }
	fun static void RecordWavAdc(int nbChan, string fileName){
		int chans[nbChan];
		for(0 => int i; i < nbChan; i++)
			i => chans[i];
		RecordWavAdc(chans, fileName);
	}
}
