public class Recording{

    fun static void RecordWavDac(IntArrayList chans, string fileName){

        Gain g[chans.size()];
        WvOut w[chans.size()];
        for(0 => int i; i<chans.size(); i++){
            chans.get(i) => int ch;
            CIO.Out[ch] => g[i] => w[i] => blackhole;
            0.5 => g[i].gain;
            ParamsM.GetCurrentPath() + "Recorded/" + fileName + "_" + now/1::second + "_dac_" + ch + ".wav" => w[i].wavFilename;
            null @=> w[i];
        }
        
        <<< "Writing", chans, "dac channel(s) to file", fileName>>>;
        
        while( true ) 1::second => now;
    }
	fun static void RecordWavDac(int nbChan, string fileName){
		IntArrayList chans;
		for(0 => int i; i < nbChan; i++)
			chans.add(i);
		RecordWavDac(chans, fileName);
	}
    
    fun static void RecordWavAdc(IntArrayList chans, string fileName){
        
        Gain g[chans.size()];
        WvOut w[chans.size()];	
        for(0 => int i; i<chans.size(); i++){
            chans.get(i) => int ch;	
            CIO.In[ch] => g[i] => w[i] => blackhole;		
            0.5 => g[i].gain;	
            ParamsM.GetCurrentPath() + "Recorded/" + fileName + "_" + now/1::second + "_adc_" + ch + ".wav" => w[i].wavFilename;	
            null @=> w[i];	
        }
        
        <<< "Writing", chans, "adc channel(s) to file", fileName>>>;
        
        while( true ) 1::second => now;
    }
	fun static void RecordWavAdc(int nbChan, string fileName){
		IntArrayList chans;
		for(0 => int i; i < nbChan; i++)
			chans.add(i);
		RecordWavAdc(chans, fileName);
	}
}
