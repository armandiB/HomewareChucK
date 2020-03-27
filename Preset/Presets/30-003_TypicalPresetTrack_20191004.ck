public class TypicalPresetTrack extends Preset{

	init(0);
	IntArrayList outSzChans; outSzChans.add(0); outSzChans.add(1);
	IntArrayList spChans; spChans.add(0); spChans.add(1); spChans.add(2); spChans.add(3);
	
	StepOut step5 @=> go[5].general;
	
	SinGeneralOut sin8 @=> go[8];
	
	PitchHandlerGeneralOut ph12 @=> go[12];
	
	PitchHandlerGeneralOut ph14 @=> go[14];
	
	SinGeneralOut sin15 @=> go[15];
	
	prepare();
	
	init2(5, outSzChans, spChans);
	CIO.In[4] => sz.in[0];
	
	sp.players.get(0).gain(0.1);
	sp.players.get(0).setChan(0);
	sp.players.get(1).gain(0.1);
	sp.players.get(1).setChan(1);
	
	step5.setNext(-0.5);
	
	sin8.setFreq(0.1);
	sin8.gen.gain(0.1);
	
	sin15.setFreq(4);
	sin15.gen.gain(0.05);
	sin15.gGesture.addMode();
	sin15.gGesture.setVal(0.5);
	
}