/*
int iIns[0];
iIns << ParamsM.Alt3In << ParamsM.Alt4In << ParamsM.Mic1In << ParamsM.Mic2In << ParamsM.EffectsIn << ParamsM.ReverbIn << ParamsM.ClockIn;
CIO.IgnoreIns(iIns);

int iOuts[0];
iOuts << ParamsM.DirectOutL << ParamsM.DirectOutR << ParamsM.EffectsOut << ParamsM.RouteOutL << ParamsM.RouteOutR << ParamsM.ClockOut << ParamsM.RunOut;
CIO.IgnoreOuts(iOuts);

//for(0 => int i; i < MBus.PBusSize; i++)
//    MBus.PChan0[i] => CIO.Out[i];

if(CIO.InSize > ParamsM.ReverbIn && CIO.InSize > ParamsM.EffectsIn && CIO.OutSize > ParamsM.DirectOutL && CIO.OutSize > ParamsM.EffectsOut){  
        
	//CIO.In[ParamsM.ReverbIn] => ParamsM.gLeftReverb => CIO.Out[ParamsM.DirectOutL]; //send to RouteOut too?
	//ParamsM.gLeftReverb.gain(0.2);
	
	CIO.In[ParamsM.EffectsIn] => ParamsM.gEffects => CIO.Out[ParamsM.EffectsOut]; 
	ParamsM.gEffects.gain(0.95);
}
*/

adc.chan(ParamsM.EffectsIn)=> ParamsM.gEffects => dac.chan(ParamsM.EffectsOut); 
ParamsM.gEffects.gain(0.95);

adc.chan(ParamsM.Alt3In)=> ParamsM.gLeftReverb => dac.chan(ParamsM.RouteOutR); 
ParamsM.gLeftReverb.gain(0.9);
