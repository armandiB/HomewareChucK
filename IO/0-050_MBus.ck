public class MBus
{
	static int PBusSize;
	static Gain @ PChan1[];
    static Gain @ PChan2[];

    static Gain @ PChan0[];
	
	fun static void PInit(int pSize){
		CIO.SetOffsets();
		pSize => PBusSize;
		new Gain[pSize] @=> PChan1;
        new Gain[pSize] @=> PChan2;

        new Gain[pSize] @=> PChan0;
        
        for(0 => int i; i < PBusSize; i++)
            PChan1[i] => CIO.Out[i];
        
        for(0 => int i; i < PBusSize; i++){
            PChan2[i].gain(0);
            PChan2[i] => CIO.Out[i];
        }
		
		for(0 => int i; i < PBusSize; i++)
			PChan0[i] => CIO.Out[i];
	} 
	fun static void PInit(){
          PInit(CIO.OutSize);
        }
	
    fun static void PChanCF(int chan, float trgtGain, float trgtGain2, dur durTot, int nbStep){
        PChan1[chan].gain() => float orGain;
        PChan2[chan].gain() => float orGain2;
        durTot / nbStep => dur durStep;
        
        for(1 => int i; i < nbStep+1; i++){
            PChan1[chan].gain( orGain*(1 - i * 1./nbStep) + trgtGain* i * 1./nbStep);
            PChan2[chan].gain( orGain2*(1 - i * 1./nbStep) + trgtGain2* i * 1./nbStep);
            durStep => now;
        } 
    }
	fun static void PChanCF(IntArrayList chans, float trgtGain, float trgtGain2, dur durTot, int nbStep){
		for(0 => int i; i < chans.size(); i++)
			PChanCF(chans.get(i), trgtGain, trgtGain2, durTot, nbStep);
	}
    fun static void PChanCF(int chan, float trgtGain, float trgtGain2, dur durTot){
        PChanCF(chan, trgtGain, trgtGain2, durTot, 100);}
    fun static void PChanCF12(int chan, float trgtGain2, dur durTot){
        PChanCF(chan, 0, trgtGain2, durTot, 100);}
    fun static void PChanCF21(int chan, float trgtGain, dur durTot){
        PChanCF(chan, trgtGain, 0, durTot, 100);}
    fun static void PChanCut(int chan, dur durTot){
        PChanCF(chan, 0, 0, durTot, 100);}
    fun static void PCutAll(dur durTot){
        for(0=>int i; i < PBusSize; i++)
            PChanCF(i, 0, 0, durTot, 100);
        }
	fun static void PChanCF(IntArrayList chan, float trgtGain, float trgtGain2, dur durTot){			
		PChanCF(chan, trgtGain, trgtGain2, durTot, 100);}			
	fun static void PChanCF12(IntArrayList chan, float trgtGain2, dur durTot){				
		PChanCF(chan, 0, trgtGain2, durTot, 100);}				
	fun static void PChanCF21(IntArrayList chan, float trgtGain, dur durTot){					
		PChanCF(chan, trgtGain, 0, durTot, 100);}					
	fun static void PChanCut(IntArrayList chan, dur durTot){						
		PChanCF(chan, 0, 0, durTot, 100);}						
	fun static void PCutAll(dur durTot){
		for(0=>int i; i < PBusSize; i++)
		PChanCF(i, 0, 0, durTot, 100);						
	}
        
	int busSize;
	Gain @ chan[];
	
	fun static MBus make(int size){
		MBus mbus;
		size => mbus.busSize;
		new Gain[size] @=> mbus.chan;
		return mbus;
	}
}
   
